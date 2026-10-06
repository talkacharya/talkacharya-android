package com.talkacharya.call;

import android.content.Context;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Bridges {@link CallTelecom} to Dart on the {@code talkacharya/telecom} channel.
 *
 * <p>A plugin — not code in each app's MainActivity, where it used to live — so it
 * is attached to every Flutter engine, including the FCM background isolate. That
 * isolate is what rings a phone whose app is killed, and it is exactly the moment
 * Android most needs to be told a call is ringing.
 */
public class CallTelecomPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler {

    private MethodChannel channel;
    private Context context;
    private final CallTelecom.Listener listener = (event, data) -> {
        MethodChannel c = channel;
        if (c != null) c.invokeMethod(event, data);
    };

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        context = binding.getApplicationContext();
        CallTelecom.appContext = context;
        channel = new MethodChannel(binding.getBinaryMessenger(), "talkacharya/telecom");
        channel.setMethodCallHandler(this);
        CallTelecom.addListener(listener);
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        CallTelecom.removeListener(listener);
        if (channel != null) channel.setMethodCallHandler(null);
        channel = null;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "isSupported":
                result.success(CallTelecom.supported());
                break;
            case "start":
                result.success(CallTelecom.start(context, str(call, "peerName"), str(call, "callId")));
                break;
            case "reportIncoming": {
                Number expires = call.argument("expiresMs");
                Boolean video = call.argument("video");
                result.success(CallTelecom.reportIncoming(
                    context,
                    str(call, "callId"),
                    str(call, "peerName"),
                    video != null && video,
                    expires == null ? 0 : expires.longValue()
                ));
                break;
            }
            case "answerIncoming":
                result.success(CallTelecom.answerIncoming(str(call, "callId")));
                break;
            case "declineIncoming":
                CallTelecom.declineIncoming(str(call, "callId"));
                result.success(null);
                break;
            case "takePendingAnswer":
                result.success(CallTelecom.takePendingAnswer());
                break;
            case "setSpeaker": {
                Boolean on = call.argument("on");
                result.success(CallTelecom.setSpeaker(on != null && on));
                break;
            }
            case "setAudioRoute":
                result.success(CallTelecom.setAudioRoute(str(call, "route")));
                break;
            case "end":
                CallTelecom.end();
                result.success(null);
                break;
            default:
                result.notImplemented();
        }
    }

    private static String str(MethodCall call, String key) {
        Object v = call.argument(key);
        return v == null ? "" : v.toString();
    }
}
