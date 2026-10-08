import 'package:astro/src/core/update/app_update_watcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_update/in_app_update.dart';

void main() {
  test('a newer version on the store is offered', () {
    expect(
      promptFor(
        availability: UpdateAvailability.updateAvailable,
        installStatus: InstallStatus.unknown,
      ),
      AppUpdatePrompt.available,
    );
  });

  test('a downloaded update only needs the restart', () {
    expect(
      promptFor(
        availability: UpdateAvailability.updateAvailable,
        installStatus: InstallStatus.downloaded,
      ),
      AppUpdatePrompt.readyToInstall,
    );
  });

  test('an app that is up to date says nothing', () {
    expect(
      promptFor(
        availability: UpdateAvailability.updateNotAvailable,
        installStatus: InstallStatus.unknown,
      ),
      AppUpdatePrompt.none,
    );
  });
}
