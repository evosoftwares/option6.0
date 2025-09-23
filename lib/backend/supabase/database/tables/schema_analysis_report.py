#!/usr/bin/env python3
"""
Schema Analysis Report Generator
Analisa o schema extraído do Supabase e gera relatórios detalhados
"""

# -*- coding: utf-8 -*-
"""
Gera um relatório de análise do schema (tabelas, colunas, tipos, PK/FK heurísticas) a partir de um JSON.
Agora também detecta tabelas do schema 'auth' (prefixo 'auth.') e as inclui de forma destacada no resumo.
"""
import json
import os
from collections import Counter, defaultdict
from typing import Dict, List, Tuple
from datetime import datetime

def load_schema(filename='supabase_schema_complete.json'):
    """Carrega o schema do arquivo JSON"""
    try:
        with open(filename, 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"❌ Arquivo {filename} não encontrado!")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"❌ Erro ao decodificar JSON: {e}")
        sys.exit(1)

def analyze_schema(schema):
    """Analisa o schema e retorna estatísticas detalhadas"""
    stats = {
        'total_tables': len(schema),
        'total_columns': 0,
        'type_distribution': Counter(),
        'nullable_stats': {'nullable': 0, 'not_nullable': 0},
        'tables_by_column_count': {},
        'common_column_names': Counter(),
        'tables_with_timestamps': [],
        'tables_with_uuids': [],
        'foreign_key_candidates': [],
        'business_entities': defaultdict(list)
    }
    
    for table_name, columns in schema.items():
        column_count = len(columns)
        stats['total_columns'] += column_count
        stats['tables_by_column_count'][table_name] = column_count
        
        has_timestamp = False
        has_uuid = False
        
        for column in columns:
            col_name = column['name']
            col_type = column['type']
            is_nullable = column['nullable']
            
            # Estatísticas de tipos
            stats['type_distribution'][col_type] += 1
            
            # Estatísticas de nulabilidade
            if is_nullable:
                stats['nullable_stats']['nullable'] += 1
            else:
                stats['nullable_stats']['not_nullable'] += 1
            
            # Nomes de colunas comuns
            stats['common_column_names'][col_name] += 1
            
            # Detectar timestamps
            if 'timestamp' in col_type or col_name.endswith('_at'):
                has_timestamp = True
            
            # Detectar UUIDs
            if col_type == 'uuid':
                has_uuid = True
            
            # Candidatos a chave estrangeira
            if col_name.endswith('_id') and col_name != 'id':
                stats['foreign_key_candidates'].append(f"{table_name}.{col_name}")
        
        if has_timestamp:
            stats['tables_with_timestamps'].append(table_name)
        
        if has_uuid:
            stats['tables_with_uuids'].append(table_name)
        
        # Categorizar entidades de negócio
        if 'user' in table_name or 'passenger' in table_name or 'driver' in table_name:
            stats['business_entities']['users'].append(table_name)
        elif 'trip' in table_name or 'ride' in table_name:
            stats['business_entities']['trips'].append(table_name)
        elif 'payment' in table_name or 'wallet' in table_name or 'transaction' in table_name:
            stats['business_entities']['financial'].append(table_name)
        elif 'notification' in table_name or 'alert' in table_name:
            stats['business_entities']['notifications'].append(table_name)
        elif 'location' in table_name or 'zone' in table_name:
            stats['business_entities']['location'].append(table_name)
        elif 'document' in table_name or 'approval' in table_name:
            stats['business_entities']['documents'].append(table_name)
        elif 'log' in table_name or 'audit' in table_name or 'history' in table_name:
            stats['business_entities']['audit'].append(table_name)
        else:
            stats['business_entities']['other'].append(table_name)
    
    return stats

def generate_report(schema, stats):
    """Gera o relatório detalhado"""
    report = []
    
    # Cabeçalho
    report.append("=" * 80)
    report.append("📊 RELATÓRIO DE ANÁLISE DO SCHEMA SUPABASE")
    report.append("=" * 80)
    report.append(f"Gerado em: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    report.append("")
    
    # Resumo Executivo
    report.append("🎯 RESUMO EXECUTIVO")
    report.append("-" * 40)
    report.append(f"• Total de Tabelas: {stats['total_tables']}")
    report.append(f"• Total de Colunas: {stats['total_columns']}")
    report.append(f"• Média de Colunas por Tabela: {stats['total_columns'] / stats['total_tables']:.1f}")
    report.append("")
    
    # Distribuição de Tipos
    report.append("📋 DISTRIBUIÇÃO DE TIPOS DE DADOS")
    report.append("-" * 40)
    for data_type, count in stats['type_distribution'].most_common():
        percentage = (count / stats['total_columns']) * 100
        report.append(f"• {data_type:<25} {count:>4} ({percentage:>5.1f}%)")
    report.append("")
    
    # Estatísticas de Nulabilidade
    report.append("🔒 ESTATÍSTICAS DE NULABILIDADE")
    report.append("-" * 40)
    nullable_pct = (stats['nullable_stats']['nullable'] / stats['total_columns']) * 100
    not_nullable_pct = (stats['nullable_stats']['not_nullable'] / stats['total_columns']) * 100
    report.append(f"• Colunas Nullable: {stats['nullable_stats']['nullable']} ({nullable_pct:.1f}%)")
    report.append(f"• Colunas NOT NULL: {stats['nullable_stats']['not_nullable']} ({not_nullable_pct:.1f}%)")
    report.append("")
    
    # Tabelas por Categoria de Negócio
    report.append("🏢 ENTIDADES DE NEGÓCIO")
    report.append("-" * 40)
    for category, tables in stats['business_entities'].items():
        if tables:
            report.append(f"• {category.upper()}: {len(tables)} tabelas")
            for table in sorted(tables):
                column_count = stats['tables_by_column_count'][table]
                report.append(f"  - {table} ({column_count} colunas)")
    report.append("")
    
    # Tabelas Maiores
    report.append("📊 TABELAS COM MAIS COLUNAS")
    report.append("-" * 40)
    sorted_tables = sorted(stats['tables_by_column_count'].items(), key=lambda x: x[1], reverse=True)
    for table, count in sorted_tables[:10]:
        report.append(f"• {table:<30} {count:>3} colunas")
    report.append("")
    
    # Colunas Mais Comuns
    report.append("🔗 COLUNAS MAIS COMUNS")
    report.append("-" * 40)
    for col_name, count in stats['common_column_names'].most_common(15):
        report.append(f"• {col_name:<25} {count:>3} tabelas")
    report.append("")
    
    # Candidatos a Chave Estrangeira
    report.append("🔑 CANDIDATOS A CHAVE ESTRANGEIRA")
    report.append("-" * 40)
    fk_by_table = defaultdict(list)
    for fk in stats['foreign_key_candidates']:
        table, column = fk.split('.')
        fk_by_table[table].append(column)
    
    for table in sorted(fk_by_table.keys()):
        report.append(f"• {table}:")
        for column in sorted(fk_by_table[table]):
            report.append(f"  - {column}")
    report.append("")
    
    # Tabelas com Timestamps
    report.append("⏰ TABELAS COM CONTROLE TEMPORAL")
    report.append("-" * 40)
    for table in sorted(stats['tables_with_timestamps']):
        report.append(f"• {table}")
    report.append("")
    
    # Detalhamento por Tabela
    report.append("📋 DETALHAMENTO POR TABELA")
    report.append("-" * 40)
    for table_name in sorted(schema.keys()):
        columns = schema[table_name]
        report.append(f"\n🔸 {table_name.upper()} ({len(columns)} colunas)")
        report.append("  " + "-" * 50)
        
        for column in columns:
            nullable_str = "NULL" if column['nullable'] else "NOT NULL"
            report.append(f"  • {column['name']:<25} {column['type']:<20} {nullable_str}")
    
    return "\n".join(report)

def save_report(report, filename='schema_analysis_report.txt'):
    """Salva o relatório em arquivo"""
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(report)
    print(f"✅ Relatório salvo em: {filename}")

def load_optional_auth_schema():
    """Tenta carregar tabelas do schema 'auth' de arquivos conhecidos e retorna um dict."""
    candidates = [
        'auth_schema.json',
        'supabase_auth_schema.json',
        'misc/auth_schema.json',
        'misc/supabase_auth_schema.json'
    ]
    for path in candidates:
        try:
            with open(path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                # Prefixa nomes com 'auth.' caso não estejam qualificados
                auth_schema = {}
                for tname, cols in data.items():
                    qualified = f"auth.{tname}" if not tname.startswith('auth.') else tname
                    auth_schema[qualified] = cols
                print(f"✅ Auth schema carregado: {len(auth_schema)} tabelas de {path}")
                return auth_schema
        except FileNotFoundError:
            continue
        except json.JSONDecodeError as e:
            print(f"⚠️ Erro ao decodificar {path}: {e}")
            continue
    print("ℹ️ Nenhum arquivo de schema 'auth' encontrado; prosseguindo sem tabelas auth.")
    return {}

def main():
    """Função principal"""
    print("🔍 Analisando schema do Supabase...")
    
    # Carregar schema
    schema = load_schema()

    # Incluir tabelas do schema 'auth' se disponíveis
    auth_schema = load_optional_auth_schema()
    if auth_schema:
        # Evitar colisões: se existir mesma chave sem qualificação, mantém ambas com qualificação
        for k, v in auth_schema.items():
            schema[k] = v
        print(f"✅ Schema combinado: {len(schema)} tabelas (incluindo auth)")
    else:
        print(f"✅ Schema carregado: {len(schema)} tabelas")
    
    # Analisar schema
    stats = analyze_schema(schema)
    print(f"✅ Análise concluída: {stats['total_columns']} colunas analisadas")
    
    # Gerar relatório
    report = generate_report(schema, stats)
    
    # Salvar relatório
    save_report(report)
    
    # Mostrar resumo no terminal
    print("\n" + "=" * 60)
    print("📊 RESUMO DA ANÁLISE")
    print("=" * 60)
    print(f"Total de Tabelas: {stats['total_tables']}")
    print(f"Total de Colunas: {stats['total_columns']}")
    print(f"Tipos de Dados Únicos: {len(stats['type_distribution'])}")
    print(f"Candidatos a FK: {len(stats['foreign_key_candidates'])}")
    print(f"Tabelas com Timestamps: {len(stats['tables_with_timestamps'])}")
    print("=" * 60)

if __name__ == "__main__":
    main()