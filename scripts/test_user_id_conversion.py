#!/usr/bin/env python3
"""
Script para testar e corrigir a conversão de user_id entre Firebase UID e UUID do Supabase
"""

import re
import os
from pathlib import Path

class UserIdConversionAnalyzer:
    def __init__(self, project_root):
        self.project_root = Path(project_root)
        self.issues = []
        
    def analyze_user_id_usage(self):
        """Analisa como user_id é usado em todo o projeto"""
        print("🔍 Analisando uso de user_id no projeto...")
        
        # Padrões para buscar
        patterns = {
            'firebase_uid_usage': r'currentUserUid|firebaseUserId|currentUserReference\.id',
            'user_id_queries': r"q\.eq\(['\"]user_id['\"],\s*([^)]+)\)",
            'user_id_assignments': r"['\"]user_id['\"]\s*:\s*([^,}]+)",
            'passenger_creation': r'PassengersTable\(\)\.insert\(',
            'app_user_creation': r'AppUsersTable\(\)\.insert\(',
        }
        
        dart_files = list(self.project_root.rglob('*.dart'))
        
        for file_path in dart_files:
            if 'generated' in str(file_path) or '.dart_tool' in str(file_path):
                continue
                
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    
                for pattern_name, pattern in patterns.items():
                    matches = re.finditer(pattern, content, re.MULTILINE)
                    for match in matches:
                        line_num = content[:match.start()].count('\n') + 1
                        context = self._get_line_context(content, match.start())
                        
                        self.issues.append({
                            'file': str(file_path.relative_to(self.project_root)),
                            'line': line_num,
                            'pattern': pattern_name,
                            'match': match.group(0),
                            'context': context
                        })
                        
            except Exception as e:
                print(f"❌ Erro ao processar {file_path}: {e}")
                
    def _get_line_context(self, content, position):
        """Obtém o contexto da linha onde ocorreu o match"""
        lines = content.split('\n')
        line_num = content[:position].count('\n')
        
        start = max(0, line_num - 1)
        end = min(len(lines), line_num + 2)
        
        context_lines = []
        for i in range(start, end):
            prefix = '>>> ' if i == line_num else '    '
            context_lines.append(f"{prefix}{i+1:3d}: {lines[i]}")
            
        return '\n'.join(context_lines)
        
    def generate_report(self):
        """Gera relatório dos problemas encontrados"""
        print("\n📊 RELATÓRIO DE ANÁLISE DE USER_ID")
        print("=" * 50)
        
        # Agrupar por tipo de padrão
        by_pattern = {}
        for issue in self.issues:
            pattern = issue['pattern']
            if pattern not in by_pattern:
                by_pattern[pattern] = []
            by_pattern[pattern].append(issue)
            
        for pattern_name, issues in by_pattern.items():
            print(f"\n🔍 {pattern_name.upper()} ({len(issues)} ocorrências):")
            print("-" * 40)
            
            for issue in issues[:5]:  # Mostrar apenas os primeiros 5
                print(f"📁 {issue['file']}:{issue['line']}")
                print(f"🎯 Match: {issue['match']}")
                print(f"📝 Contexto:")
                print(issue['context'])
                print()
                
            if len(issues) > 5:
                print(f"... e mais {len(issues) - 5} ocorrências\n")
                
    def identify_conversion_issues(self):
        """Identifica problemas específicos de conversão"""
        print("\n🚨 PROBLEMAS DE CONVERSÃO IDENTIFICADOS:")
        print("=" * 50)
        
        # Buscar casos onde Firebase UID é usado diretamente como user_id
        firebase_to_user_id = []
        for issue in self.issues:
            if issue['pattern'] == 'user_id_assignments':
                match_text = issue['match'].lower()
                if any(term in match_text for term in ['currentuseruid', 'firebaseuserid', 'currentuserreference']):
                    firebase_to_user_id.append(issue)
                    
        if firebase_to_user_id:
            print(f"\n❌ FIREBASE UID USADO DIRETAMENTE COMO USER_ID ({len(firebase_to_user_id)} casos):")
            for issue in firebase_to_user_id:
                print(f"  📁 {issue['file']}:{issue['line']} - {issue['match']}")
                
        # Buscar queries que podem falhar
        problematic_queries = []
        for issue in self.issues:
            if issue['pattern'] == 'user_id_queries':
                match_text = issue['match'].lower()
                if any(term in match_text for term in ['currentuseruid', 'firebaseuserid']):
                    problematic_queries.append(issue)
                    
        if problematic_queries:
            print(f"\n❌ QUERIES PROBLEMÁTICAS ({len(problematic_queries)} casos):")
            for issue in problematic_queries:
                print(f"  📁 {issue['file']}:{issue['line']} - {issue['match']}")
                
    def suggest_fixes(self):
        """Sugere correções para os problemas encontrados"""
        print("\n💡 SUGESTÕES DE CORREÇÃO:")
        print("=" * 50)
        
        print("\n1. 🔄 PADRONIZAR USO DE USER_ID:")
        print("   - Sempre usar app_users.id (UUID) como user_id nas tabelas relacionadas")
        print("   - Nunca usar Firebase UID diretamente como user_id")
        print("   - Criar função helper para converter Firebase UID -> app_users.id")
        
        print("\n2. 🛠️ IMPLEMENTAR FUNÇÃO DE CONVERSÃO:")
        print("   ```dart")
        print("   Future<String?> getAppUserIdFromFirebaseUid(String firebaseUid) async {")
        print("     final query = await AppUsersTable().queryRows(")
        print("       queryFn: (q) => q.eq('fcm_token', firebaseUid).limit(1),")
        print("     );")
        print("     return query.isNotEmpty ? query.first.id : null;")
        print("   }")
        print("   ```")
        
        print("\n3. 🔧 CORRIGIR QUERIES EXISTENTES:")
        print("   - Substituir queries diretas por Firebase UID")
        print("   - Usar a função de conversão antes de fazer queries")
        print("   - Atualizar métodos como _getPassengerTrips")
        
        print("\n4. 🗄️ VERIFICAR SCHEMA DO BANCO:")
        print("   - Confirmar que user_id é UUID em todas as tabelas")
        print("   - Verificar constraints e foreign keys")
        print("   - Considerar adicionar índices para performance")

def main():
    project_root = "/Users/gabrielggcx/Desktop/option"
    
    analyzer = UserIdConversionAnalyzer(project_root)
    
    print("🚀 Iniciando análise de conversão de user_id...")
    analyzer.analyze_user_id_usage()
    
    analyzer.generate_report()
    analyzer.identify_conversion_issues()
    analyzer.suggest_fixes()
    
    print("\n✅ Análise concluída!")
    print(f"📊 Total de ocorrências encontradas: {len(analyzer.issues)}")

if __name__ == "__main__":
    main()