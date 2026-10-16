import os
import re

apps = [r'k:\talkacharya\android\astrologer\astro', r'k:\talkacharya\android\customer\customr']

target_files = [
    'brand_colors.dart',
    'astro_palette.dart',
    'app_bottom_sheet.dart',
    'app_button.dart',
    'app_error_widget.dart',
    'cosmic.dart',
    'empty_state.dart',
    'error_view.dart',
    'fade_slide_in.dart',
    'hue_widgets.dart',
    'pressable.dart',
    'skeleton.dart'
]

# Regex to match any import statement that ends with one of the target files.
# example: import '../../shared/widgets/app_button.dart';
pattern = re.compile(r"^import\s+['\"].*?(" + "|".join(target_files) + r")['\"];\s*\n?", re.MULTILINE)

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    if not pattern.search(content):
        return # no matches
        
    # Remove all matching imports
    new_content = pattern.sub('', content)
    
    # Check if the new import is already there
    pkg_import = "import 'package:talkacharya_ui/talkacharya_ui.dart';\n"
    if pkg_import not in new_content:
        # Find the last import to insert after
        imports = list(re.finditer(r"^import\s+['\"].*?['\"];\s*\n?", new_content, re.MULTILINE))
        if imports:
            last_import = imports[-1]
            insert_pos = last_import.end()
            new_content = new_content[:insert_pos] + pkg_import + new_content[insert_pos:]
        else:
            # No imports at all, just put at the top
            new_content = pkg_import + new_content
            
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print(f"Updated {filepath}")

for app in apps:
    for root, dirs, files in os.walk(os.path.join(app, 'lib')):
        for file in files:
            if file.endswith('.dart'):
                process_file(os.path.join(root, file))

print("All imports updated!")
