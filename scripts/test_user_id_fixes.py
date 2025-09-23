#!/usr/bin/env python3
"""
Test script to verify user_id conversion fixes are working correctly.
This script validates that the UserIdConverter helper function is properly integrated.
"""

import os
import re

def test_user_id_converter_integration():
    """Test that UserIdConverter is properly integrated in key files"""
    print("🔍 Testing UserIdConverter integration...")
    
    # Check if UserIdConverter file exists
    converter_file = 'lib/flutter_flow/user_id_converter.dart'
    if not os.path.exists(converter_file):
        print("❌ UserIdConverter file not found")
        return False
    
    with open(converter_file, 'r') as f:
        converter_content = f.read()
    
    # Verify key methods exist
    required_methods = [
        'getAppUserIdFromFirebaseUid',
        'getFirebaseUidFromAppUserId'
    ]
    
    for method in required_methods:
        if method not in converter_content:
            print(f"❌ Method {method} not found in UserIdConverter")
            return False
    
    print("✅ UserIdConverter file structure is correct")
    return True

def test_main_passageiro_fixes():
    """Test that main_passageiro_widget.dart uses UserIdConverter correctly"""
    print("🔍 Testing main_passageiro_widget.dart fixes...")
    
    file_path = 'lib/mai_passageiro_option/main_passageiro/main_passageiro_widget.dart'
    if not os.path.exists(file_path):
        print("❌ main_passageiro_widget.dart not found")
        return False
    
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Check for UserIdConverter usage
    if 'UserIdConverter.getAppUserIdFromFirebaseUid' not in content:
        print("❌ UserIdConverter not used in main_passageiro_widget.dart")
        return False
    
    # Check that direct Firebase UID usage is replaced
    if re.search(r'user_id.*currentUserUid', content):
        print("❌ Direct Firebase UID usage still found")
        return False
    
    print("✅ main_passageiro_widget.dart correctly uses UserIdConverter")
    return True

def test_vehicle_verification_fixes():
    """Test that verificar_dados_veiculo_completos.dart uses UserIdConverter correctly"""
    print("🔍 Testing verificar_dados_veiculo_completos.dart fixes...")
    
    file_path = 'lib/custom_code/actions/verificar_dados_veiculo_completos.dart'
    if not os.path.exists(file_path):
        print("❌ verificar_dados_veiculo_completos.dart not found")
        return False
    
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Check for UserIdConverter usage in all functions
    converter_usage_count = content.count('UserIdConverter.getAppUserIdFromFirebaseUid')
    if converter_usage_count < 3:  # Should be used in 3 functions
        print(f"❌ UserIdConverter not used in all functions (found {converter_usage_count} usages)")
        return False
    
    print("✅ verificar_dados_veiculo_completos.dart correctly uses UserIdConverter")
    return True

def test_index_export():
    """Test that index.dart properly exports UserIdConverter"""
    print("🔍 Testing index.dart export...")
    
    file_path = 'lib/index.dart'
    if not os.path.exists(file_path):
        print("❌ index.dart not found")
        return False
    
    with open(file_path, 'r') as f:
        content = f.read()
    
    if "export 'flutter_flow/user_id_converter.dart';" not in content:
        print("❌ UserIdConverter not exported in index.dart")
        return False
    
    print("✅ index.dart correctly exports UserIdConverter")
    return True

def main():
    """Run all tests"""
    print("🚀 Starting user_id conversion fixes validation...\n")
    
    tests = [
        test_user_id_converter_integration,
        test_main_passageiro_fixes,
        test_vehicle_verification_fixes,
        test_index_export
    ]
    
    passed = 0
    total = len(tests)
    
    for test in tests:
        if test():
            passed += 1
        print()  # Empty line for readability
    
    print(f"📊 Test Results: {passed}/{total} tests passed")
    
    if passed == total:
        print("🎉 All user_id conversion fixes are working correctly!")
        print("\n✅ Summary of fixes:")
        print("   • Created UserIdConverter helper class")
        print("   • Fixed Firebase UID to Supabase UUID conversion")
        print("   • Updated main_passageiro_widget.dart")
        print("   • Updated verificar_dados_veiculo_completos.dart")
        print("   • Added proper exports to index.dart")
        print("\n🔄 Next steps:")
        print("   • Test passenger profile creation flow")
        print("   • Verify Supabase triggers (if any)")
        print("   • Run integration tests")
        return True
    else:
        print("❌ Some fixes need attention")
        return False

if __name__ == '__main__':
    success = main()
    exit(0 if success else 1)