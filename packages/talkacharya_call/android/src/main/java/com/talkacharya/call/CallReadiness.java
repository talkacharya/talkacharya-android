package com.talkacharya.call;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.PowerManager;
import android.provider.Settings;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

/**
 * Whether this phone will ring for a consultation with the screen off, and the
 * settings screens that fix it when it will not.
 *
 * <p>A request reaches a locked phone as a high-priority push; the app then raises a
 * full-screen, ringing notification. Four things on the phone decide whether that
 * happens: notifications allowed at all; the ringing channel still loud (a user can
 * silence one channel); permission to show over the lock screen (Android 14 asks
 * for it separately); and being allowed to run while the phone sleeps — battery
 * optimisation, and on Xiaomi, Oppo, Vivo, Realme and others their own "autostart"
 * switch, which stops a push from waking the app at all.
 */
final class CallReadiness {

    private CallReadiness() {}

    static Map<String, Object> check(Context context, String callChannelId) {
        Map<String, Object> out = new HashMap<>();
        NotificationManager nm =
            (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        out.put("notifications", nm == null || nm.areNotificationsEnabled());

        boolean channelLoud = true;
        if (nm != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
            && callChannelId != null && !callChannelId.isEmpty()) {
            NotificationChannel channel = nm.getNotificationChannel(callChannelId);
            // Not created yet: it will be, at full volume, on the first ring.
            channelLoud = channel == null
                || channel.getImportance() >= NotificationManager.IMPORTANCE_HIGH;
        }
        out.put("callChannel", channelLoud);

        boolean fullScreen = true;
        if (nm != null && Build.VERSION.SDK_INT >= 34) {
            fullScreen = nm.canUseFullScreenIntent();
        }
        out.put("fullScreen", fullScreen);

        boolean battery = true;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PowerManager pm = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
            battery = pm == null || pm.isIgnoringBatteryOptimizations(context.getPackageName());
        }
        out.put("battery", battery);

        String maker = Build.MANUFACTURER == null ? "" : Build.MANUFACTURER;
        out.put("manufacturer", maker.toLowerCase(Locale.ROOT));
        out.put("sdk", Build.VERSION.SDK_INT);
        return out;
    }

    /** Open the settings screen for {@code which}. False when none could be opened. */
    static boolean open(Context context, String which, String callChannelId) {
        String pkg = context.getPackageName();
        Uri pkgUri = Uri.parse("package:" + pkg);
        switch (which) {
            case "notifications":
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    return start(context, new Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                        .putExtra(Settings.EXTRA_APP_PACKAGE, pkg)) || appDetails(context);
                }
                return appDetails(context);
            case "callChannel":
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    return start(context, new Intent(Settings.ACTION_CHANNEL_NOTIFICATION_SETTINGS)
                        .putExtra(Settings.EXTRA_APP_PACKAGE, pkg)
                        .putExtra(Settings.EXTRA_CHANNEL_ID, callChannelId))
                        || open(context, "notifications", callChannelId);
                }
                return appDetails(context);
            case "fullScreen":
                if (Build.VERSION.SDK_INT >= 34) {
                    return start(context, new Intent(
                        "android.settings.MANAGE_APP_USE_FULL_SCREEN_INTENT", pkgUri))
                        || appDetails(context);
                }
                return appDetails(context);
            case "battery":
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    // The direct "allow" dialog needs REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
                    // in the app's manifest; without it, the full list is the way.
                    return start(context, new Intent(
                        Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS, pkgUri))
                        || start(context, new Intent(
                            Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS))
                        || appDetails(context);
                }
                return appDetails(context);
            case "autostart":
                return autostart(context) || appDetails(context);
            case "lockScreen":
                return lockScreen(context, pkg) || appDetails(context);
            default:
                return appDetails(context);
        }
    }

    /** The maker's own "let this app start by itself" screen, where there is one. */
    private static boolean autostart(Context context) {
        String[][] screens = {
            // Xiaomi / Redmi / Poco
            {"com.miui.securitycenter",
                "com.miui.permcenter.autostart.AutoStartManagementActivity"},
            // Oppo / Realme / OnePlus (ColorOS)
            {"com.coloros.safecenter",
                "com.coloros.safecenter.permission.startup.StartupAppListActivity"},
            {"com.coloros.safecenter",
                "com.coloros.safecenter.startupapp.StartupAppListActivity"},
            {"com.oppo.safe",
                "com.oppo.safe.permission.startup.StartupAppListActivity"},
            // Vivo / iQOO
            {"com.vivo.permissionmanager",
                "com.vivo.permissionmanager.activity.BgStartUpManagerActivity"},
            {"com.iqoo.secure",
                "com.iqoo.secure.ui.phoneoptimize.BgStartUpManager"},
            // Huawei / Honor
            {"com.huawei.systemmanager",
                "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity"},
            // Asus
            {"com.asus.mobilemanager", "com.asus.mobilemanager.entry.FunctionActivity"},
            // Samsung: sleeping / never-sleeping apps
            {"com.samsung.android.lool",
                "com.samsung.android.sm.battery.ui.BatteryActivity"},
        };
        for (String[] s : screens) {
            Intent intent = new Intent().setComponent(new ComponentName(s[0], s[1]));
            if (start(context, intent)) return true;
        }
        return false;
    }

    /** Xiaomi's per-app "Show on lock screen" lives in its own permission editor. */
    private static boolean lockScreen(Context context, String pkg) {
        Intent miui = new Intent("miui.intent.action.APP_PERM_EDITOR")
            .setClassName("com.miui.securitycenter",
                "com.miui.permcenter.permissions.PermissionsEditorActivity")
            .putExtra("extra_pkgname", pkg);
        return start(context, miui);
    }

    private static boolean appDetails(Context context) {
        return start(context, new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
            Uri.parse("package:" + context.getPackageName())));
    }

    private static boolean start(Context context, Intent intent) {
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        try {
            PackageManager pm = context.getPackageManager();
            if (intent.resolveActivity(pm) == null) return false;
            context.startActivity(intent);
            return true;
        } catch (RuntimeException e) {
            return false;
        }
    }
}
