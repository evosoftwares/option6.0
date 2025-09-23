#!/usr/bin/env python3
"""
Script para corrigir a conversão de Firebase UID para UUID do Supabase
"""

import re
import os
from pathlib import Path

class UserIdConversionFixer:
    def __init__(self, project_root):
        self.project_root = Path(project_root)
        self.fixes_applied = []
        
    def create_conversion_helper(self):
        """Cria função helper para conversão de Firebase UID para app_users.id"""
        print("🛠️ Criando função helper de conversão...")
        
        helper_content = '''// lib/flutter_flow/user_id_converter.dart
import '../backend/supabase/database/tables/app_users.dart';

/// Helper class para conversão entre Firebase UID e Supabase UUID
class UserIdConverter {
  /// Converte Firebase UID para app_users.id (UUID)
  /// 
  /// Busca o usuário na tabela app_users usando o fcm_token (que armazena o Firebase UID)
  /// e retorna o UUID correspondente.
  /// 
  /// Returns null se o usuário não for encontrado.
  static Future<String?> getAppUserIdFromFirebaseUid(String firebaseUid) async {
    try {
      final query = await AppUsersTable().queryRows(
        queryFn: (q) => q.eq('fcm_token', firebaseUid).limit(1),
      );
      
      if (query.isNotEmpty) {
        final appUserId = query.first.id;
        print('🔄 [UserIdConverter] Firebase UID "$firebaseUid" -> App User ID "$appUserId"');
        return appUserId;
      } else {
        print('⚠️ [UserIdConverter] Usuário não encontrado para Firebase UID: $firebaseUid');
        return null;
      }
    } catch (e) {
      print('❌ [UserIdConverter] Erro na conversão: $e');
      return null;
    }
  }
  
  /// Converte app_users.id (UUID) para Firebase UID
  /// 
  /// Busca o usuário na tabela app_users pelo ID e retorna o fcm_token (Firebase UID).
  /// 
  /// Returns null se o usuário não for encontrado.
  static Future<String?> getFirebaseUidFromAppUserId(String appUserId) async {
    try {
      final query = await AppUsersTable().queryRows(
        queryFn: (q) => q.eq('id', appUserId).limit(1),
      );
      
      if (query.isNotEmpty) {
        final firebaseUid = query.first.fcmToken;
        print('🔄 [UserIdConverter] App User ID "$appUserId" -> Firebase UID "$firebaseUid"');
        return firebaseUid;
      } else {
        print('⚠️ [UserIdConverter] Usuário não encontrado para App User ID: $appUserId');
        return null;
      }
    } catch (e) {
      print('❌ [UserIdConverter] Erro na conversão: $e');
      return null;
    }
  }
  
  /// Verifica se um ID é um Firebase UID (string) ou UUID do Supabase
  /// 
  /// Firebase UIDs geralmente têm 28 caracteres e contêm letras e números
  /// UUIDs têm 36 caracteres com hífens no formato: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  static bool isFirebaseUid(String id) {
    // UUID pattern: 8-4-4-4-12 characters separated by hyphens
    final uuidPattern = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', caseSensitive: false);
    
    if (uuidPattern.hasMatch(id)) {
      return false; // É UUID
    }
    
    // Firebase UID geralmente tem 28 caracteres alfanuméricos
    return id.length >= 20 && id.length <= 30 && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(id);
  }
}
'''
        
        helper_path = self.project_root / 'lib' / 'flutter_flow' / 'user_id_converter.dart'
        helper_path.parent.mkdir(parents=True, exist_ok=True)
        
        with open(helper_path, 'w', encoding='utf-8') as f:
            f.write(helper_content)
            
        print(f"✅ Função helper criada: {helper_path}")
        self.fixes_applied.append(f"Created helper: {helper_path}")
        
    def fix_main_passageiro_widget(self):
        """Corrige o método _getPassengerTrips no main_passageiro_widget.dart"""
        print("🔧 Corrigindo main_passageiro_widget.dart...")
        
        file_path = self.project_root / 'lib' / 'mai_passageiro_option' / 'main_passageiro' / 'main_passageiro_widget.dart'
        
        if not file_path.exists():
            print(f"❌ Arquivo não encontrado: {file_path}")
            return
            
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Adicionar import do helper
        if "import '../../flutter_flow/user_id_converter.dart';" not in content:
            # Encontrar a linha de imports e adicionar o novo import
            import_pattern = r"(import\s+['\"][^'\"]*flutter_flow[^'\"]*['\"];)"
            match = re.search(import_pattern, content)
            if match:
                new_import = match.group(1) + "\nimport '../../flutter_flow/user_id_converter.dart';"
                content = content.replace(match.group(1), new_import)
            else:
                # Se não encontrar imports do flutter_flow, adicionar no início dos imports
                import_start = content.find("import 'package:")
                if import_start != -1:
                    content = content[:import_start] + "import '../../flutter_flow/user_id_converter.dart';\n" + content[import_start:]
                    
        # Substituir o método _getPassengerTrips
        old_method = r'''  /// Gets passenger trips by first finding the passenger record, then querying trips
  Future<List<TripsRow>> _getPassengerTrips\(String firebaseUserId\) async \{
    try \{
      // First, get the passenger record using the Firebase user_id
      final passengerQuery = await PassengersTable\(\)\.queryRows\(
        queryFn: \(q\) => q\.eq\('user_id', firebaseUserId\),
      \);

      if \(passengerQuery\.isEmpty\) \{
        // No passenger record found, return empty list
        return \[\];
      \}

      final passenger = passengerQuery\.first;
      final passengerId = passenger\.id; // This is the UUID we need

      // Now query trips using the correct passenger_id \(UUID\)
      final trips = await TripsTable\(\)\.queryRows\(
        queryFn: \(q\) => q\.eq\('passenger_id', passengerId\)
            \.order\('created_at', ascending: false\)
            \.limit\(10\), // Limit to recent trips for performance
      \);

      return trips;
    \} catch \(e\) \{
      debugPrint\('Erro ao buscar viagens do passageiro: \$e'\);
      throw e; // Re-throw to be handled by FutureBuilder
    \}
  \}'''
        
        new_method = '''  /// Gets passenger trips by first converting Firebase UID to app_users.id, then querying trips
  Future<List<TripsRow>> _getPassengerTrips(String firebaseUserId) async {
    try {
      // Convert Firebase UID to app_users.id (UUID)
      final appUserId = await UserIdConverter.getAppUserIdFromFirebaseUid(firebaseUserId);
      
      if (appUserId == null) {
        debugPrint('Usuário não encontrado para Firebase UID: $firebaseUserId');
        return [];
      }
      
      // Get the passenger record using the correct app_users.id
      final passengerQuery = await PassengersTable().queryRows(
        queryFn: (q) => q.eq('user_id', appUserId),
      );

      if (passengerQuery.isEmpty) {
        debugPrint('Perfil de passageiro não encontrado para app_users.id: $appUserId');
        return [];
      }

      final passenger = passengerQuery.first;
      final passengerId = passenger.id; // This is the passenger UUID

      // Now query trips using the correct passenger_id (UUID)
      final trips = await TripsTable().queryRows(
        queryFn: (q) => q.eq('passenger_id', passengerId)
            .order('created_at', ascending: false)
            .limit(10), // Limit to recent trips for performance
      );

      return trips;
    } catch (e) {
      debugPrint('Erro ao buscar viagens do passageiro: $e');
      throw e; // Re-throw to be handled by FutureBuilder
    }
  }'''
        
        content = re.sub(old_method, new_method, content, flags=re.MULTILINE | re.DOTALL)
        
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
            
        print(f"✅ Corrigido: {file_path}")
        self.fixes_applied.append(f"Fixed _getPassengerTrips method in {file_path}")
        
    def fix_verificar_dados_veiculo_completos(self):
        """Corrige as queries no verificar_dados_veiculo_completos.dart"""
        print("🔧 Corrigindo verificar_dados_veiculo_completos.dart...")
        
        file_path = self.project_root / 'lib' / 'custom_code' / 'actions' / 'verificar_dados_veiculo_completos.dart'
        
        if not file_path.exists():
            print(f"❌ Arquivo não encontrado: {file_path}")
            return
            
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Adicionar import do helper
        if "import '../../flutter_flow/user_id_converter.dart';" not in content:
            # Adicionar import após os outros imports
            import_pattern = r"(import\s+['\"][^'\"]*\.dart['\"];)"
            matches = list(re.finditer(import_pattern, content))
            if matches:
                last_import = matches[-1]
                new_import = last_import.group(1) + "\nimport '../../flutter_flow/user_id_converter.dart';"
                content = content.replace(last_import.group(1), new_import)
                
        # Substituir todas as queries que usam currentUserUid diretamente
        # Padrão: q.eq('user_id', currentUserUid)
        query_pattern = r"q\.eq\('user_id',\s*currentUserUid\)"
        
        # Encontrar todas as funções que contêm essas queries
        function_pattern = r"(Future<[^>]*>\s+\w+\([^)]*\)\s+async\s*\{[^}]*q\.eq\('user_id',\s*currentUserUid\)[^}]*\})"
        
        # Para este arquivo específico, vamos fazer uma substituição mais direcionada
        # Substituir as queries diretas por conversão
        old_query = "q.eq('user_id', currentUserUid)"
        
        # Contar quantas vezes aparece
        count = content.count(old_query)
        
        if count > 0:
            print(f"📊 Encontradas {count} queries para corrigir")
            
            # Adicionar função helper no início da função principal
            # Procurar pela função principal (geralmente a primeira)
            main_function_pattern = r"(Future<[^>]*>\s+verificarDadosVeiculoCompletos\([^)]*\)\s+async\s*\{)"
            match = re.search(main_function_pattern, content)
            
            if match:
                # Adicionar conversão no início da função
                function_start = match.group(1)
                conversion_code = '''\n  // Convert Firebase UID to app_users.id for database queries
  final appUserId = await UserIdConverter.getAppUserIdFromFirebaseUid(currentUserUid);
  
  if (appUserId == null) {
    return false; // User not found
  }
'''
                new_function_start = function_start + conversion_code
                content = content.replace(function_start, new_function_start)
                
                # Substituir todas as queries
                new_query = "q.eq('user_id', appUserId)"
                content = content.replace(old_query, new_query)
                
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
            
        print(f"✅ Corrigido: {file_path} ({count} queries atualizadas)")
        self.fixes_applied.append(f"Fixed {count} queries in {file_path}")
        
    def update_index_dart(self):
        """Atualiza o index.dart para incluir o novo helper"""
        print("📝 Atualizando index.dart...")
        
        index_path = self.project_root / 'lib' / 'index.dart'
        
        if not index_path.exists():
            print(f"❌ Arquivo index.dart não encontrado: {index_path}")
            return
            
        with open(index_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Adicionar export do helper
        export_line = "export 'flutter_flow/user_id_converter.dart';"
        
        if export_line not in content:
            # Encontrar onde adicionar (após outros exports do flutter_flow)
            flutter_flow_exports = re.findall(r"export\s+'flutter_flow/[^']*';", content)
            
            if flutter_flow_exports:
                # Adicionar após o último export do flutter_flow
                last_export = flutter_flow_exports[-1]
                new_exports = last_export + "\n" + export_line
                content = content.replace(last_export, new_exports)
            else:
                # Adicionar no final dos exports
                content += "\n" + export_line + "\n"
                
            with open(index_path, 'w', encoding='utf-8') as f:
                f.write(content)
                
            print(f"✅ Adicionado export ao index.dart")
            self.fixes_applied.append("Added export to index.dart")
        else:
            print("ℹ️ Export já existe no index.dart")
            
    def create_test_script(self):
        """Cria script de teste para verificar as correções"""
        print("🧪 Criando script de teste...")
        
        test_content = '''// test_user_id_conversion.dart
// Script para testar a conversão de user_id

import 'package:flutter/material.dart';
import 'lib/flutter_flow/user_id_converter.dart';
import 'lib/backend/supabase/database/tables/app_users.dart';
import 'lib/backend/supabase/database/tables/passengers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Teste de conversão
  await testUserIdConversion();
}

Future<void> testUserIdConversion() async {
  print('🧪 Testando conversão de user_id...');
  
  try {
    // Buscar um usuário de exemplo
    final users = await AppUsersTable().queryRows(
      queryFn: (q) => q.limit(1),
    );
    
    if (users.isEmpty) {
      print('❌ Nenhum usuário encontrado para teste');
      return;
    }
    
    final user = users.first;
    final firebaseUid = user.fcmToken;
    final appUserId = user.id;
    
    print('📊 Dados do usuário de teste:');
    print('  Firebase UID: $firebaseUid');
    print('  App User ID: $appUserId');
    
    // Teste 1: Firebase UID -> App User ID
    print('\n🔄 Teste 1: Firebase UID -> App User ID');
    final convertedAppUserId = await UserIdConverter.getAppUserIdFromFirebaseUid(firebaseUid!);
    print('  Resultado: $convertedAppUserId');
    print('  ✅ Sucesso: ${convertedAppUserId == appUserId}');
    
    // Teste 2: App User ID -> Firebase UID
    print('\n🔄 Teste 2: App User ID -> Firebase UID');
    final convertedFirebaseUid = await UserIdConverter.getFirebaseUidFromAppUserId(appUserId);
    print('  Resultado: $convertedFirebaseUid');
    print('  ✅ Sucesso: ${convertedFirebaseUid == firebaseUid}');
    
    // Teste 3: Verificar se é Firebase UID
    print('\n🔍 Teste 3: Identificação de tipo de ID');
    print('  Firebase UID "$firebaseUid" é Firebase UID: ${UserIdConverter.isFirebaseUid(firebaseUid!)}');
    print('  App User ID "$appUserId" é Firebase UID: ${UserIdConverter.isFirebaseUid(appUserId)}');
    
    // Teste 4: Buscar passageiro usando conversão
    print('\n👤 Teste 4: Buscar passageiro com conversão');
    if (convertedAppUserId != null) {
      final passengers = await PassengersTable().queryRows(
        queryFn: (q) => q.eq('user_id', convertedAppUserId),
      );
      print('  Passageiros encontrados: ${passengers.length}');
    }
    
    print('\n✅ Todos os testes concluídos!');
    
  } catch (e, stackTrace) {
    print('❌ Erro durante os testes: $e');
    print('Stack trace: $stackTrace');
  }
}
'''
        
        test_path = self.project_root / 'test_user_id_conversion.dart'
        
        with open(test_path, 'w', encoding='utf-8') as f:
            f.write(test_content)
            
        print(f"✅ Script de teste criado: {test_path}")
        self.fixes_applied.append(f"Created test script: {test_path}")
        
    def generate_summary(self):
        """Gera resumo das correções aplicadas"""
        print("\n📋 RESUMO DAS CORREÇÕES APLICADAS")
        print("=" * 50)
        
        for i, fix in enumerate(self.fixes_applied, 1):
            print(f"{i:2d}. {fix}")
            
        print("\n🎯 PRÓXIMOS PASSOS:")
        print("1. Execute 'flutter analyze' para verificar erros de sintaxe")
        print("2. Execute 'flutter test' para rodar os testes")
        print("3. Teste a funcionalidade de login e criação de perfil")
        print("4. Verifique se as queries de passageiro funcionam corretamente")
        print("5. Execute o script de teste: 'dart test_user_id_conversion.dart'")
        
        print("\n⚠️ ATENÇÃO:")
        print("- Verifique se todos os imports estão corretos")
        print("- Teste em ambiente de desenvolvimento antes de produção")
        print("- Monitore logs para identificar possíveis problemas")

def main():
    project_root = "/Users/gabrielggcx/Desktop/option"
    
    fixer = UserIdConversionFixer(project_root)
    
    print("🚀 Iniciando correção de conversão de user_id...")
    
    # Aplicar todas as correções
    fixer.create_conversion_helper()
    fixer.fix_main_passageiro_widget()
    fixer.fix_verificar_dados_veiculo_completos()
    fixer.update_index_dart()
    fixer.create_test_script()
    
    fixer.generate_summary()
    
    print("\n✅ Correções concluídas com sucesso!")

if __name__ == "__main__":
    main()