package com.talkacharya.sounds;

import android.content.Context;
import android.media.AudioAttributes;
import android.media.AudioManager;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.media.SoundPool;
import android.media.ToneGenerator;
import android.net.Uri;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.os.VibratorManager;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * App sounds, all native so they follow the phone's own ringtone/notification
 * choice and its ringer mode (silent = nothing, vibrate = vibration only):
 *
 * <ul>
 *   <li>{@code startRinging} — incoming call / consultation request: the default
 *       ringtone, looped, plus a repeating vibration.
 *   <li>{@code startRingback} — the caller's "tring tring" while the other side rings
 *       (voice-call stream, like the dialer; plays even in vibrate mode because the
 *       caller is looking at the call screen).
 *   <li>{@code stop} — ends either loop.
 *   <li>{@code notify} — the default notification sound once (or a short buzz).
 *   <li>{@code effect} — short bundled tones: message in/out, call
 *       connected/ended, and the pair that mark a call dropping and coming back.
 * </ul>
 */
public class TalkacharyaSoundsPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler {
    private static final long[] RING_VIBRATION = {0, 700, 900};
    private static final long RINGTONE_RELOOP_MS = 1000;

    private MethodChannel channel;
    private Context context;
    private final Handler main = new Handler(Looper.getMainLooper());

    private Ringtone ringtone;
    private Runnable ringtoneRelooper;
    private ToneGenerator ringback;
    private boolean vibrating;

    private SoundPool pool;
    private final Map<String, Integer> effects = new HashMap<>();

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        context = binding.getApplicationContext();
        channel = new MethodChannel(binding.getBinaryMessenger(), "talkacharya/sounds");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        stopAll();
        if (pool != null) {
            pool.release();
            pool = null;
            effects.clear();
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        try {
            switch (call.method) {
                case "startRinging":
                    startRinging();
                    break;
                case "startRingback":
                    startRingback();
                    break;
                case "stop":
                    stopAll();
                    break;
                case "notify":
                    playNotification();
                    break;
                case "effect":
                    playEffect(call.argument("name"));
                    break;
                default:
                    result.notImplemented();
                    return;
            }
            result.success(null);
        } catch (Exception e) {
            // A sound must never break the flow that asked for it.
            result.success(null);
        }
    }

    // --- ringer mode ------------------------------------------------------

    private int ringerMode() {
        AudioManager am = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
        return am == null ? AudioManager.RINGER_MODE_NORMAL : am.getRingerMode();
    }

    // --- incoming ring ------------------------------------------------------

    private void startRinging() {
        stopAll();
        int mode = ringerMode();
        if (mode == AudioManager.RINGER_MODE_SILENT) return;
        startVibration(RING_VIBRATION, 1);
        if (mode != AudioManager.RINGER_MODE_NORMAL) return;

        Uri uri = RingtoneManager.getActualDefaultRingtoneUri(context, RingtoneManager.TYPE_RINGTONE);
        if (uri == null) uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE);
        Ringtone r = RingtoneManager.getRingtone(context, uri);
        if (r == null) return;
        r.setAudioAttributes(new AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build());
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            r.setLooping(true);
        } else {
            final Ringtone looped = r;
            ringtoneRelooper = new Runnable() {
                @Override
                public void run() {
                    if (ringtone != looped) return;
                    if (!looped.isPlaying()) looped.play();
                    main.postDelayed(this, RINGTONE_RELOOP_MS);
                }
            };
            main.postDelayed(ringtoneRelooper, RINGTONE_RELOOP_MS);
        }
        ringtone = r;
        r.play();
    }

    // --- outgoing ringback --------------------------------------------------

    private void startRingback() {
        stopAll();
        if (ringerMode() == AudioManager.RINGER_MODE_SILENT) return;
        ringback = new ToneGenerator(AudioManager.STREAM_VOICE_CALL, 70);
        // Plays the network ringing cadence until stopTone().
        ringback.startTone(ToneGenerator.TONE_SUP_RINGTONE);
    }

    // --- one-shots --------------------------------------------------------

    private void playNotification() {
        int mode = ringerMode();
        if (mode == AudioManager.RINGER_MODE_SILENT) return;
        if (mode == AudioManager.RINGER_MODE_VIBRATE) {
            startVibration(new long[]{0, 180}, -1);
            return;
        }
        Uri uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        Ringtone r = RingtoneManager.getRingtone(context, uri);
        if (r == null) return;
        r.setAudioAttributes(new AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build());
        r.play();
    }

    private void playEffect(String name) {
        if (name == null || ringerMode() != AudioManager.RINGER_MODE_NORMAL) return;
        ensurePool();
        Integer id = effects.get(name);
        if (id != null) pool.play(id, 0.8f, 0.8f, 1, 0, 1f);
    }

    private void ensurePool() {
        if (pool != null) return;
        pool = new SoundPool.Builder()
                .setMaxStreams(2)
                .setAudioAttributes(new AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ASSISTANCE_SONIFICATION)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build())
                .build();
        // load() is async; the first play of each effect after start-up may be
        // skipped, so warm them all at once.
        effects.put("message_in", pool.load(context, R.raw.ta_msg_in, 1));
        effects.put("message_out", pool.load(context, R.raw.ta_msg_out, 1));
        effects.put("call_connected", pool.load(context, R.raw.ta_call_connected, 1));
        effects.put("call_ended", pool.load(context, R.raw.ta_call_ended, 1));
        effects.put("call_reconnecting", pool.load(context, R.raw.ta_call_reconnecting, 1));
        effects.put("call_reconnected", pool.load(context, R.raw.ta_call_reconnected, 1));
    }

    // --- vibration --------------------------------------------------------

    private Vibrator vibrator() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            VibratorManager vm = (VibratorManager) context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE);
            return vm == null ? null : vm.getDefaultVibrator();
        }
        return (Vibrator) context.getSystemService(Context.VIBRATOR_SERVICE);
    }

    private void startVibration(long[] pattern, int repeat) {
        Vibrator v = vibrator();
        if (v == null || !v.hasVibrator()) return;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            v.vibrate(VibrationEffect.createWaveform(pattern, repeat));
        } else {
            v.vibrate(pattern, repeat);
        }
        if (repeat >= 0) vibrating = true;
    }

    // --- stop -------------------------------------------------------------

    private void stopAll() {
        if (ringtoneRelooper != null) {
            main.removeCallbacks(ringtoneRelooper);
            ringtoneRelooper = null;
        }
        if (ringtone != null) {
            ringtone.stop();
            ringtone = null;
        }
        if (ringback != null) {
            ringback.stopTone();
            ringback.release();
            ringback = null;
        }
        if (vibrating) {
            Vibrator v = vibrator();
            if (v != null) v.cancel();
            vibrating = false;
        }
    }
}
