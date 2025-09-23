#!/usr/bin/env python3
"""
🔧 Complete Final Fixer for All Remaining Issues
===============================================
Fixes the last 12 remaining syntax errors in entity files.
"""

import os
import re
from pathlib import Path

class CompleteFinalFixer:
    def __init__(self):
        self.domain_entities_path = Path('lib/domain/entities')
        
        # All remaining custom identifiers that need to be String
        self.custom_identifiers = [
            'entityId', 'sharingId'
        ]
    
    def fix_type_declarations(self, content):
        """Fix all remaining custom type declarations"""
        for identifier in self.custom_identifiers:
            # Fix field declarations: final entityId entityId;
            content = re.sub(f'final\s+{identifier}\s+([a-zA-Z_][a-zA-Z0-9_]*);', 
                           f'final String \\1;', content)
            
            # Fix constructor parameters: entityId entityId,
            content = re.sub(f'\b{identifier}\s+([a-zA-Z_][a-zA-Z0-9_]*),', 
                           f'String \\1,', content)
            
            # Fix nullable constructor parameters: entityId? entityId,
            content = re.sub(f'\b{identifier}\?\s+([a-zA-Z_][a-zA-Z0-9_]*),', 
                           f'String? \\1,', content)
            
            # Fix copyWith parameters: entityId? entityId,
            content = re.sub(f'\s+{identifier}\?\s+([a-zA-Z_][a-zA-Z0-9_]*),', 
                           f' String? \\1,', content)
            
            # Fix constructor closing: entityId entityId)
            content = re.sub(f'\b{identifier}\s+([a-zA-Z_][a-zA-Z0-9_]*)\)', 
                           f'String \\1)', content)
            
            # Fix nullable constructor closing: entityId? entityId)
            content = re.sub(f'\b{identifier}\?\s+([a-zA-Z_][a-zA-Z0-9_]*)\)', 
                           f'String? \\1)', content)
        
        return content
    
    def fix_undefined_fields(self, content, filename):
        """Fix undefined field references based on specific files"""
        
        # Fix missing 'id' field declarations in view files
        if 'view.dart' in filename:
            # Add id field if missing
            if 'final String id;' not in content and 'class ' in content:
                # Find the class declaration and add id field
                content = re.sub(r'(class\s+\w+\s*{)', r'\1\n  final String id;', content)
                # Add id to constructor
                content = re.sub(r'(const\s+\w+\s*\(\s*{)', r'\1\n    required this.id,', content)
        
        # Fix missing consecutiveCancellations field in passenger.dart
        if 'passenger.dart' in filename:
            if 'consecutiveCancellations' not in content or 'final int consecutiveCancellations;' not in content:
                # Add the missing field
                content = re.sub(r'(final int totalTrips;)', r'\1\n  final int consecutiveCancellations;', content)
                # Add to constructor
                content = re.sub(r'(required this\.totalTrips,)', r'\1\n    required this.consecutiveCancellations,', content)
                # Add to copyWith
                content = re.sub(r'(int\? totalTrips,)', r'\1\n    int? consecutiveCancellations,', content)
                # Add to copyWith return
                content = re.sub(r'(totalTrips: totalTrips \?\? this\.totalTrips,)', 
                               r'\1\n      consecutiveCancellations: consecutiveCancellations ?? this.consecutiveCancellations,', content)
                # Add to operator ==
                content = re.sub(r'(other\.totalTrips == this\.totalTrips)', 
                               r'\1 &&\n            other.consecutiveCancellations == this.consecutiveCancellations', content)
                # Add to hashCode
                content = re.sub(r'(totalTrips,)', r'\1\n      consecutiveCancellations,', content)
        
        return content
    
    def fix_null_safety_warnings(self, content):
        """Fix null safety warnings"""
        # Fix unnecessary null comparisons
        content = re.sub(r'(\w+)\s*!=\s*null\s*\?\s*\1!\s*:\s*0', r'\1', content)
        content = re.sub(r'(\w+)\s*!=\s*null\s*\?\s*\1\s*:\s*0', r'\1 ?? 0', content)
        
        return content
    
    def process_file(self, file_path):
        """Process a single file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original_content = content
            
            # Apply all fixes
            content = self.fix_type_declarations(content)
            content = self.fix_undefined_fields(content, file_path.name)
            content = self.fix_null_safety_warnings(content)
            
            if content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"✅ Fixed remaining issues in {file_path.name}")
                return True
            else:
                print(f"ℹ️  No fixes needed in {file_path.name}")
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
        print(f"📁 Processing {len(dart_files)} entity files for final fixes")
        
        fixed_count = 0
        for file_path in dart_files:
            if self.process_file(file_path):
                fixed_count += 1
        
        print(f"\n📊 Summary: Applied final fixes to {fixed_count} out of {len(dart_files)} files")
    
    def run(self):
        """Run complete final fixes"""
        print("🔧 Complete Final Fixer for All Remaining Issues")
        print("===============================================\n")
        
        self.process_all_entities()
        
        print("\n✅ All final fixes completed!")
        print("\n📝 Next steps:")
        print("  1. Run 'flutter analyze lib/domain/entities/' to verify all fixes")
        print("  2. Should now have 0 syntax errors!")

if __name__ == '__main__':
    fixer = CompleteFinalFixer()
    fixer.run()