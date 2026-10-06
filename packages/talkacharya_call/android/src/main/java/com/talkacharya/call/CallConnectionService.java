package com.talkacharya.call;

import android.annotation.TargetApi;
import android.os.Build;
import android.os.Bundle;
import android.telecom.Connection;
import android.telecom.ConnectionRequest;
import android.telecom.ConnectionService;
import android.telecom.PhoneAccountHandle;
import android.telecom.TelecomManager;
import android.telecom.VideoProfile;

/** Telecom builds our {@link CallConnection}s through this. Declared in the manifest. */
@TargetApi(Build.VERSION_CODES.O)
public class CallConnectionService extends ConnectionService {

    @Override
    public Connection onCreateOutgoingConnection(
        PhoneAccountHandle connectionManagerPhoneAccount, ConnectionRequest request
    ) {
        Bundle extras = request == null ? null : request.getExtras();
        CallConnection connection = build(request, extras);
        // Our own stack has the call up already; there is no dialing state to show.
        connection.setActive();
        CallTelecom.connection = connection;
        return connection;
    }

    @Override
    public void onCreateOutgoingConnectionFailed(
        PhoneAccountHandle connectionManagerPhoneAccount, ConnectionRequest request
    ) {
        CallTelecom.emit("failed", CallTelecom.callIdMap(""));
    }

    /**
     * A ringing consultation. It stays RINGING until the app answers it
     * ({@link CallTelecom#answerIncoming}), the system does ({@link CallConnection#onAnswer}),
     * it is declined, or it times out.
     */
    @Override
    public Connection onCreateIncomingConnection(
        PhoneAccountHandle connectionManagerPhoneAccount, ConnectionRequest request
    ) {
        Bundle extras = request == null ? null : request.getExtras();
        Bundle inner = extras == null ? null
            : extras.getBundle(TelecomManager.EXTRA_INCOMING_CALL_EXTRAS);
        if (inner == null) inner = extras;
        CallConnection connection = build(request, inner);
        if (inner != null && inner.getBoolean(CallTelecom.EXTRA_VIDEO, false)) {
            connection.setVideoState(VideoProfile.STATE_BIDIRECTIONAL);
        }
        connection.setRinging();
        CallTelecom.onRinging(
            connection,
            inner == null ? 0 : inner.getLong(CallTelecom.EXTRA_EXPIRES_MS, 0)
        );
        return connection;
    }

    @Override
    public void onCreateIncomingConnectionFailed(
        PhoneAccountHandle connectionManagerPhoneAccount, ConnectionRequest request
    ) {
        // Usually: another call is in progress and the user was not offered ours.
        // The app's own notification is still ringing, which is the real UI.
        CallTelecom.emit("failed", CallTelecom.callIdMap(""));
    }

    private static CallConnection build(ConnectionRequest request, Bundle extras) {
        String callId = extras == null ? "" : extras.getString(CallTelecom.EXTRA_CALL_ID, "");
        CallConnection connection = new CallConnection(callId);
        if (request != null && request.getAddress() != null) {
            connection.setAddress(request.getAddress(), TelecomManager.PRESENTATION_ALLOWED);
        }
        String peer = extras == null ? null : extras.getString(CallTelecom.EXTRA_PEER_NAME);
        if (peer != null && !peer.isEmpty()) {
            connection.setCallerDisplayName(peer, TelecomManager.PRESENTATION_ALLOWED);
        }
        return connection;
    }
}
