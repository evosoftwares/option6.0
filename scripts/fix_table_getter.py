#!/usr/bin/env python3

import os
import re

# Configuration
DART_OUTPUT_DIR = "lib/backend/supabase/database/tables"

def fix_table_getter_in_file(file_path: str):
    """Fix the table getter in a Dart file."""
    try:
        with open(file_path, 'r') as f:
            content = f.read()
        
        # Replace tableField with table to match the abstract class
        content = re.sub(
            r'SupabaseTable get tableField =>',
            'SupabaseTable get table =>',
            content
        )
        
        with open(file_path, 'w') as f:
            f.write(content)
        
        print(f"Fixed table getter in {file_path}")
    except Exception as e:
        print(f"Error fixing {file_path}: {e}")

def fix_all_dart_files():
    """Fix table getter in all Dart files in the tables directory."""
    if not os.path.exists(DART_OUTPUT_DIR):
        print(f"Directory {DART_OUTPUT_DIR} does not exist")
        return
    
    dart_files = [f for f in os.listdir(DART_OUTPUT_DIR) if f.endswith('.dart')]
    
    for dart_file in dart_files:
        file_path = os.path.join(DART_OUTPUT_DIR, dart_file)
        fix_table_getter_in_file(file_path)
    
    print(f"Fixed table getter in {len(dart_files)} Dart files")

def main():
    """Main function to fix table getter issues."""
    print("Fixing table getter issues...")
    
    fix_all_dart_files()
    
    print("\nDone! Run 'flutter analyze lib/backend/supabase/database/' to check for remaining issues.")

if __name__ == "__main__":
    main()