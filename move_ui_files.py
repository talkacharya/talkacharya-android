import os
import shutil
import re

astro_root = r'k:\talkacharya\android\astrologer\astro'
customer_root = r'k:\talkacharya\android\customer\customr'
ui_pkg_root = r'k:\talkacharya\android\packages\talkacharya_ui'

# 1. Define files to move
files_to_move = [
    # Theme files
    (fr'{astro_root}\lib\src\core\theme\brand_colors.dart', 'theme/brand_colors.dart'),
    (fr'{astro_root}\lib\src\core\theme\astro_palette.dart', 'theme/astro_palette.dart'),
    
    # Widget files
    (fr'{astro_root}\lib\src\shared\widgets\app_bottom_sheet.dart', 'widgets/app_bottom_sheet.dart'),
    (fr'{astro_root}\lib\src\shared\widgets\app_button.dart', 'widgets/app_button.dart'),
    (fr'{astro_root}\lib\src\shared\widgets\app_error_widget.dart', 'widgets/app_error_widget.dart'),
    (fr'{astro_root}\lib\src\shared\widgets\cosmic.dart', 'widgets/cosmic.dart'),
    (fr'{astro_root}\lib\src\shared\widgets\empty_state.dart', 'widgets/empty_state.dart'),
    (fr'{astro_root}\lib\src\shared\widgets\error_view.dart', 'widgets/error_view.dart'),
    (fr'{astro_root}\lib\src\shared\widgets\fade_slide_in.dart', 'widgets/fade_slide_in.dart'),
    (fr'{astro_root}\lib\src\shared\widgets\hue_widgets.dart', 'widgets/hue_widgets.dart'),
    (fr'{astro_root}\lib\src\shared\widgets\pressable.dart', 'widgets/pressable.dart'),
    (fr'{astro_root}\lib\src\shared\widgets\skeleton.dart', 'widgets/skeleton.dart'),
]

# 2. Copy files to package
for src, dest_rel in files_to_move:
    dest = os.path.join(ui_pkg_root, 'lib', 'src', dest_rel)
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    if os.path.exists(src):
        shutil.copyfile(src, dest)

# 3. Create barrel file
barrel_path = os.path.join(ui_pkg_root, 'lib', 'talkacharya_ui.dart')
with open(barrel_path, 'w', encoding='utf-8') as f:
    f.write("library talkacharya_ui;\n\n")
    for _, dest_rel in files_to_move:
        f.write(f"export 'src/{dest_rel}';\n")

print("Files copied and barrel created.")
