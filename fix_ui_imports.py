import os
import re

ui_pkg_root = r'k:\talkacharya\android\packages\talkacharya_ui\lib\src\widgets'

def replace_in_file(filename, replacements):
    path = os.path.join(ui_pkg_root, filename)
    if not os.path.exists(path):
        return
    with open(path, 'r', encoding='utf-8') as f:
        text = f.read()
    for old, new in replacements:
        text = text.replace(old, new)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(text)

replace_in_file('app_error_widget.dart', [
    ("import '../../core/network/friendly_error.dart';", "")
])
replace_in_file('cosmic.dart', [
    ("import '../../core/theme/astro_palette.dart';", "import '../theme/astro_palette.dart';"),
    ("import '../../core/theme/brand_colors.dart';", "import '../theme/brand_colors.dart';")
])
replace_in_file('empty_state.dart', [
    ("import '../../core/theme/astro_palette.dart';", "import '../theme/astro_palette.dart';"),
    ("import '../../core/theme/brand_colors.dart';", "import '../theme/brand_colors.dart';")
])
replace_in_file('hue_widgets.dart', [
    ("import '../../core/theme/astro_palette.dart';", "import '../theme/astro_palette.dart';")
])
replace_in_file('pressable.dart', [
    ("import '../../core/utils/haptic_service.dart';", "import 'package:flutter/services.dart';"),
    ("HapticService.selection();", "HapticFeedback.selectionClick();"),
    ("HapticService.light();", "HapticFeedback.lightImpact();")
])
replace_in_file('skeleton.dart', [
    ("import '../../core/theme/brand_colors.dart';", "import '../theme/brand_colors.dart';")
])

print("Widget imports fixed in UI package.")
