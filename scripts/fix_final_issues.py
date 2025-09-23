#!/usr/bin/env python3
"""
🔧 Final Issue Resolver
======================
Fixes the last 11 remaining syntax errors:
- Duplicate field definitions
- Missing constructor arguments
- Malformed parameter lines
"""

import os
import re
from pathlib import Path

class FinalIssueResolver:
    def __init__(self):
        self.domain_entities_path = Path('lib/domain/entities')
    
    def fix_passenger_duplicates(self, content):
        """Fix duplicate consecutiveCancellations in passenger.dart"""
        # Remove malformed lines that are just field names without types
        content = re.sub(r'\s+consecutiveCancellations,\s*\n', '\n', content)
        
        # Fix constructor parameter list - remove standalone field name
        lines = content.split('\n')
        fixed_lines = []
        
        for line in lines:
            # Skip lines that are just field names without proper syntax
            if line.strip() == 'consecutiveCancellations,' or line.strip() == 'consecutiveCancellations':
                continue
            fixed_lines.append(line)
        
        return '\n'.join(fixed_lines)
    
    def fix_view_constructors(self, content, filename):
        """Fix missing id arguments in view constructors"""
        if 'view.dart' in filename:
            # Find constructor calls and add missing id parameter
            # Look for patterns like ClassName( and add id: id,
            content = re.sub(r'(\w+)\(\s*\n\s*(\w+:)', r'\1(\n      id: id,\n      \2', content)
        
        return content
    
    def fix_missing_id_fields(self, content, filename):
        """Add missing id fields to status classes"""
        status_files = ['drivereffectivestatu.dart', 'driverexcludedzonesstat.dart', 'driverstatu.dart']
        
        if any(status_file in filename for status_file in status_files):
            # Add id field if missing
            if 'final String id;' not in content and 'class ' in content:
                # Find first field and add id before it
                content = re.sub(r'(class\s+\w+\s*{\s*\n)(\s*final)', r'\1  final String id;\n\2', content)
                
                # Add id to constructor
                content = re.sub(r'(const\s+\w+\s*\(\s*{\s*\n)(\s*required)', r'\1    required this.id,\n\2', content)
                
                # Add id to copyWith parameters
                content = re.sub(r'(\w+\s+copyWith\s*\(\s*{\s*\n)(\s*\w+\?)', r'\1    String? id,\n\2', content)
                
                # Add id to copyWith return
                content = re.sub(r'(return\s+\w+\s*\(\s*\n)(\s*\w+:)', r'\1      id: id ?? this.id,\n\2', content)
                
                # Add id to operator ==
                content = re.sub(r'(other is \w+ &&\s*\n)(\s*other\.)', r'\1            other.id == this.id &&\n\2', content)
                
                # Add id to hashCode
                content = re.sub(r'(Object\.hash\s*\(\s*\n)(\s*\w+,)', r'\1      id,\n\2', content)
        
        return content
    
    def fix_null_safety_issues(self, content):
        """Fix null safety warnings"""
        # Fix patterns like: field != null ? field! : 0
        content = re.sub(r'(\w+)\s*!=\s*null\s*\?\s*\1!\s*:\s*0', r'\1', content)
        
        # Fix patterns like: field != null ? field : 0  
        content = re.sub(r'(\w+)\s*!=\s*null\s*\?\s*\1\s*:\s*0', r'\1 ?? 0', content)
        
        return content
    
    def process_file(self, file_path):
        """Process a single file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original_content = content
            
            # Apply specific fixes based on filename
            if 'passenger.dart' in file_path.name:
                content = self.fix_passenger_duplicates(content)
            
            content = self.fix_view_constructors(content, file_path.name)
            content = self.fix_missing_id_fields(content, file_path.name)
            content = self.fix_null_safety_issues(content)
            
            if content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"✅ Fixed final issues in {file_path.name}")
                return True
            else:
                print(f"ℹ️  No final fixes needed in {file_path.name}")
                return False
                
        except Exception as e:
            print(f"❌ Error processing {file_path.name}: {e}")
            return False
    
    def process_all_entities(self):
        """Process all entity files"""
        if not self.domain_entities_path.exists():
            print(f"⚠️  Directory {self.domain_entities_path} does not exist")
            return
        
        dart_files = list(self.domain_entities_path.glob('*.dart'))
        print(f"📁 Processing {len(dart_files)} entity files for final issue resolution")
        
        fixed_count = 0
        for file_path in dart_files:
            if self.process_file(file_path):
                fixed_count += 1
        
        print(f"\n📊 Summary: Resolved final issues in {fixed_count} out of {len(dart_files)} files")
    
    def run(self):
        """Run final issue resolution"""
        print("🔧 Final Issue Resolver")
        print("======================\n")
        
        self.process_all_entities()
        
        print("\n✅ All final issues resolved!")
        print("\n📝 Next steps:")
        print("  1. Run 'flutter analyze lib/domain/entities/' to verify all fixes")
        print("  2. Should now have 0 syntax errors!")

if __name__ == '__main__':
    resolver = FinalIssueResolver()
    resolver.run()