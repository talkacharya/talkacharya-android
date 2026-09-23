package com.talkacharya.customer

import android.content.ComponentName
import android.content.Context
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.telecom.CallAudioState
import android.telecom.Connection
import android.telecom.ConnectionRequest
import android.telecom.ConnectionService
import android.telecom.DisconnectCause
import android.telecom.PhoneAccount
import android.telecom.PhoneAccountHandle
import android.telecom.TelecomManager
import androidx.annotation.RequiresApi

/**
 * Registers a consultation call with Android's telecom stack as a *self-managed*
 * call, so the OS treats it as a real call rather than an app making noise.
 *
 * What that buys, and why it is worth native code:
 *  - **Cellular interop.** A GSM call arriving mid-consultation now puts our call
 *    on hold (or ends it) through Telecom, instead of two calls fighting over the
 *    microphone.
 *  - **Audio focus and routing.** Telecom owns the audio route — earpiece,
 *    speaker, a Bluetooth headset — and headset buttons reach us as call actions.
 *  - **Calling-app status.** From Android 14 `USE_FULL_SCREEN_INTENT`, which the
 *    whole ringing flow depends on, is only granted to apps that actually provide
 *    calling. Owning a `ConnectionService` is what makes that true of this app.
 *
 * Self-managed calls keep their own UI: Android does not draw a call screen for
 * them and does not write them to the system call log. The ringing notification
 * stays exactly as it is — this sits underneath it.
 *
 * Needs API 26. Below that every entry point is a no-op and a call behaves
 * exactly as it did before, which is also what happens if Telecom refuses us:
 * nothing here may ever be the reason a paid consultation fails to start.
 */
object CallTelecom {

    const val EXTRA_PEER_NAME = "com.talkacharya.PEER_NAME"

    private const val ACCOUNT_ID = "talkacharya-calls"
    private const val ACCOUNT_LABEL = "TalkAcharya"

    /** Set by MainActivity; forwards connection callbacks to Dart. */
    var listener: ((String, Map<String, Any?>) -> Unit)? = null

    @RequiresApi(Build.VERSION_CODES.O)
    internal var connection: CallConnection? = null

    private var registered = false

    val supported: Boolean get() = Build.VERSION.SDK_INT >= Build.VERSION_CODES.O

    internal fun emit(event: String, data: Map<String, Any?> = emptyMap()) {
        listener?.invoke(event, data)
    }

    private fun telecom(context: Context): TelecomManager? =
        context.getSystemService(Context.TELECOM_SERVICE) as? TelecomManager

    @RequiresApi(Build.VERSION_CODES.O)
    internal fun handle(context: Context) = PhoneAccountHandle(
        ComponentName(context.applicationContext, CallConnectionService::class.java),
        ACCOUNT_ID,
    )

    /**
     * Self-managed accounts need no user consent and no dialer role, so this is
     * safe to do lazily on the first call.
     */
    @RequiresApi(Build.VERSION_CODES.O)
    private fun register(context: Context): Boolean {
        if (registered) return true
        val manager = telecom(context) ?: return false
        return try {
            manager.registerPhoneAccount(
                PhoneAccount.builder(handle(context), ACCOUNT_LABEL)
                    .setCapabilities(PhoneAccount.CAPABILITY_SELF_MANAGED)
                    .addSupportedUriScheme(PhoneAccount.SCHEME_SIP)
                    .build()
            )
            registered = true
            true
        } catch (e: SecurityException) {
            false
        } catch (e: IllegalArgumentException) {
            false
        }
    }

    /**
     * Hand a call that is already under way to Telecom. Returns false when the
     * platform won't have it (too old, another call in progress, permission
     * refused) — the caller then simply carries on without it.
     *
     * Placed as an outgoing call from both sides: for a self-managed call the
     * direction only decides which callbacks Telecom uses to set it up, and
     * there is no system call UI or call-log entry either way.
     */
    fun start(context: Context, peerName: String, callId: String): Boolean {
        if (!supported) return false
        return startOnO(context, peerName, callId)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun startOnO(context: Context, peerName: String, callId: String): Boolean {
        val manager = telecom(context) ?: return false
        if (!register(context)) return false
        val account = handle(context)
        return try {
            if (!manager.isOutgoingCallPermitted(account)) return false
            val extras = Bundle().apply {
                putParcelable(TelecomManager.EXTRA_PHONE_ACCOUNT_HANDLE, account)
                putBundle(
                    TelecomManager.EXTRA_OUTGOING_CALL_EXTRAS,
                    Bundle().apply { putString(EXTRA_PEER_NAME, peerName) },
                )
            }
            // MANAGE_OWN_CALLS covers placeCall for a self-managed account; the
            // platform rejects it rather than throwing if that ever changes.
            @Suppress("MissingPermission")
            manager.placeCall(
                Uri.fromParts(PhoneAccount.SCHEME_SIP, "$callId@talkacharya", null),
                extras,
            )
            true
        } catch (e: SecurityException) {
            false
        } catch (e: IllegalStateException) {
            false
        }
    }

    /** The call ended in our own stack — release the Telecom connection. */
    fun end() {
        if (!supported) return
        endOnO()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun endOnO() {
        connection?.finish(DisconnectCause.LOCAL)
        connection = null
    }
}

/**
 * The Telecom end of one consultation call. Everything it is told by the system
 * is forwarded to Dart, which owns the actual call.
 */
@RequiresApi(Build.VERSION_CODES.O)
class CallConnection : Connection() {

    init {
        connectionProperties = PROPERTY_SELF_MANAGED
        connectionCapabilities = CAPABILITY_HOLD or CAPABILITY_SUPPORT_HOLD
        audioModeIsVoip = true
    }

    override fun onAnswer() {
        setActive()
        CallTelecom.emit("answer")
    }

    override fun onReject() {
        CallTelecom.emit("disconnect", mapOf("reason" to "rejected"))
        finish(DisconnectCause.REJECTED)
    }

    override fun onDisconnect() {
        // The headset's hang-up button, or Telecom making room for a cellular
        // call. Either way the consultation should end, not linger unheard.
        CallTelecom.emit("disconnect", mapOf("reason" to "local"))
        finish(DisconnectCause.LOCAL)
    }

    override fun onAbort() {
        CallTelecom.emit("disconnect", mapOf("reason" to "aborted"))
        finish(DisconnectCause.CANCELED)
    }

    override fun onHold() {
        setOnHold()
        CallTelecom.emit("hold")
    }

    override fun onUnhold() {
        setActive()
        CallTelecom.emit("unhold")
    }

    override fun onCallAudioStateChanged(state: CallAudioState) {
        CallTelecom.emit(
            "audio",
            mapOf(
                "muted" to state.isMuted,
                "speaker" to (state.route == CallAudioState.ROUTE_SPEAKER),
                "bluetooth" to (state.route == CallAudioState.ROUTE_BLUETOOTH),
            ),
        )
    }

    internal fun finish(cause: Int) {
        setDisconnected(DisconnectCause(cause))
        destroy()
        if (CallTelecom.connection === this) CallTelecom.connection = null
    }
}

/** Telecom builds our [CallConnection] through this. Declared in the manifest. */
@RequiresApi(Build.VERSION_CODES.O)
class CallConnectionService : ConnectionService() {

    override fun onCreateOutgoingConnection(
        connectionManagerPhoneAccount: PhoneAccountHandle?,
        request: ConnectionRequest?,
    ): Connection {
        val connection = CallConnection()
        request?.address?.let {
            connection.setAddress(it, TelecomManager.PRESENTATION_ALLOWED)
        }
        request?.extras?.getString(CallTelecom.EXTRA_PEER_NAME)?.takeIf { it.isNotEmpty() }?.let {
            connection.setCallerDisplayName(it, TelecomManager.PRESENTATION_ALLOWED)
        }
        // Our own stack has the call up already; there is no dialing state to show.
        connection.setActive()
        CallTelecom.connection = connection
        return connection
    }

    override fun onCreateOutgoingConnectionFailed(
        connectionManagerPhoneAccount: PhoneAccountHandle?,
        request: ConnectionRequest?,
    ) {
        CallTelecom.emit("failed")
    }

    override fun onCreateIncomingConnection(
        connectionManagerPhoneAccount: PhoneAccountHandle?,
        request: ConnectionRequest?,
    ): Connection = onCreateOutgoingConnection(connectionManagerPhoneAccount, request)
}
