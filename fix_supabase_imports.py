#!/usr/bin/env python3 oi
"""
Script to automatically add Supabase imports to Dart files that need them.
"""

import os
import re
from pathlib import Path

def needs_supabase_import(file_path):
    """Check if a Dart file needs Supabase import based on usage patterns."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Check if file already has supabase import
        if "import '/backend/supabase/supabase.dart';" in content:
            return False
            
        # Patterns that indicate need for Supabase import
        patterns = [
            r'\b(AppUsersRow|DriversRow|DriverWalletsRow|PassengersRow|TripsRow|NotificationsRow)\b',
            r'\b(AppUsersTable|DriversTable|DriverWalletsTable|PassengersTable|TripsTable|NotificationsTable)\(\)',
            r'List<\w+Row>',
            r'Stream<List<\w+Row>>'
        ]
        
        for pattern in patterns:
            if re.search(pattern, content):
                return True
                
        return False
        
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return False

def add_supabase_import(file_path):
    """Add Supabase import to a Dart file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Find the position to insert the import
        lines = content.split('\n')
        insert_position = 0
        
        # Find the last import statement
        for i, line in enumerate(lines):
            if line.strip().startswith('import '):
                insert_position = i + 1
            elif line.strip() and not line.strip().startswith('import '):
                break
                
        # Insert the Supabase import
        supabase_import = "import '/backend/supabase/supabase.dart';"
        lines.insert(insert_position, supabase_import)
        
        # Write back to file
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(lines))
            
        print(f"✅ Added Supabase import to {file_path}")
        return True
        
    except Exception as e:
        print(f"❌ Error updating {file_path}: {e}")
        return False

def main():
    """Main function to process all Dart files."""
    lib_dir = Path('lib')
    
    if not lib_dir.exists():
        print("❌ lib directory not found")
        return
        
    dart_files = list(lib_dir.rglob('*.dart'))
    print(f"Found {len(dart_files)} Dart files")
    
    updated_count = 0
    
    for dart_file in dart_files:
        if needs_supabase_import(dart_file):
            if add_supabase_import(dart_file):
                updated_count += 1
                
    print(f"\n✅ Updated {updated_count} files with Supabase imports")

if __name__ == '__main__':
    main()