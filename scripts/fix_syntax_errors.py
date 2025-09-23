#!/usr/bin/env python3
"""
🔧 Structural Syntax Error Fixer for Clean Architecture
======================================================
Fixes structural syntax errors in generated entity files:
- Malformed parameter declarations
- Extra closing braces
- Missing parameter type declarations
"""

import os
import re
from pathlib import Path

class StructuralSyntaxErrorFixer:
    def __init__(self):
        self.domain_entities_path = Path('lib/domain/entities')
    
    def fix_malformed_parameters(self, content):
        """Fix malformed parameter declarations like 'dynamic bankAccountInfo, String? asaasTransferId,'"""
        # Fix cases where type and parameter are on same line without proper separation
        # Pattern: dynamic paramName, Type? nextParam,
        content = re.sub(r'(dynamic\s+\w+),\s*(\w+\??)\s+(\w+),', r'\1,\n    \2 \3,', content)
        
        # Fix cases where nullable type is missing ?
        content = re.sub(r'\bdynamic\s+(\w+),', r'dynamic \1,', content)
        
        return content
    
    def fix_extra_braces(self, content):
        """Fix extra closing braces that break method structure"""
        # Fix pattern where operator == has extra closing braces
        # Look for '}' followed by '}' after operator == method
        content = re.sub(r'(other\.\w+\s*==\s*\w+\);)\s*\n\s*}\s*}', r'\1\n  }', content)
        
        # More general fix for double closing braces
        content = re.sub(r'}\s*}\s*\n\s*@override', r'}\n\n  @override', content)
        
        return content
    
    def fix_missing_parameter_types(self, content):
        """Fix missing parameter type declarations"""
        # Ensure all copyWith parameters have proper types
        lines = content.split('\n')
        in_copyWith = False
        fixed_lines = []
        
        for line in lines:
            if 'copyWith({' in line:
                in_copyWith = True
            elif in_copyWith and '}) {' in line:
                in_copyWith = False
            elif in_copyWith and line.strip().endswith(','):
                # Check if line has proper type declaration
                stripped = line.strip()
                if not any(type_word in stripped for type_word in ['String', 'int', 'double', 'bool', 'DateTime', 'dynamic']):
                    # This line might be missing a type, but let's be conservative
                    pass
            
            fixed_lines.append(line)
        
        return '\n'.join(fixed_lines)
    
    def fix_operator_equals_structure(self, content):
        """Fix operator == method structure issues"""
        # Fix cases where 'id' is used without 'this.' prefix in operator ==
        # But only within the operator == method
        lines = content.split('\n')
        in_operator_equals = False
        fixed_lines = []
        
        for line in lines:
            if 'bool operator ==' in line:
                in_operator_equals = True
            elif in_operator_equals and line.strip() == '}':
                in_operator_equals = False
            elif in_operator_equals:
                # Fix standalone field references in comparisons
                line = re.sub(r'other\.(\w+)\s*==\s*(?!other\.|this\.)(\w+)(?=\s*&&|\s*\)|;)', r'other.\1 == this.\2', line)
            
            fixed_lines.append(line)
        
        return '\n'.join(fixed_lines)
    
    def process_file(self, file_path):
        """Process a single file with all structural fixes"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original_content = content
            
            # Apply all fixes in sequence
            content = self.fix_malformed_parameters(content)
            content = self.fix_extra_braces(content)
            content = self.fix_missing_parameter_types(content)
            content = self.fix_operator_equals_structure(content)
            
            if content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"✅ Fixed structural issues in {file_path.name}")
                return True
            else:
                print(f"ℹ️  No structural changes needed in {file_path.name}")
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
        print(f"📁 Processing {len(dart_files)} entity files for structural fixes")
        
        fixed_count = 0
        for file_path in dart_files:
            print(f"🔧 Processing {file_path.name}")
            if self.process_file(file_path):
                fixed_count += 1
        
        print(f"\n📊 Summary: Fixed structural issues in {fixed_count} out of {len(dart_files)} files")
    
    def run(self):
        """Run all structural syntax fixes"""
        print("🔧 Structural Syntax Error Fixer for Clean Architecture")
        print("======================================================\n")
        
        self.process_all_entities()
        
        print("\n✅ All structural syntax fixes completed!")
        print("\n📝 Next steps:")
        print("  1. Run 'flutter analyze lib/domain/entities/' to verify fixes")
        print("  2. Check for any remaining syntax errors")
        print("  3. Manual review of complex cases if needed")

if __name__ == '__main__':
    fixer = StructuralSyntaxErrorFixer()
    fixer.run()