#!/usr/bin/env python3
import os
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPOS_DIR = ROOT / 'lib' / 'infrastructure' / 'repositories'
DOMAIN_REPO_DIR = ROOT / 'lib' / 'domain' / 'repositories'

FIND_EMPTY_SIG_1 = re.compile(r"Future<Result<>>\s+findById\(\s*String\s+id\s*\)\s*async")
FIND_EMPTY_SIG_2 = re.compile(r"Future<Result<>>\s+findById\(\s*String\s*\)\s*async")

INTERFACE_FIND_REGEX = re.compile(r"Future<Result<([A-Za-z0-9_]+)\?>>\s*findById\(String id\)\s*;")

IMPORT_DOMAIN_REPO_REGEX = re.compile(r"import\s+['\"]\.\./\.\./domain/repositories/([a-z0-9_]+_repository)\.dart['\"];?")

REPO_EXCEPTION_CLASS_START = "class RepositoryException implements Exception {"

STANDARD_REPO_EXCEPTION = (
    "class RepositoryException implements Exception {\n"
    "  final String message;\n"
    "  const RepositoryException(this.message);\n\n"
    "  @override\n"
    "  String toString() => 'RepositoryException: $message';\n"
    "}\n"
)

def get_interface_type(repo_impl_content):
    m = IMPORT_DOMAIN_REPO_REGEX.search(repo_impl_content)
    if not m:
        return None
    interface_file = m.group(1) + '.dart'
    interface_path = DOMAIN_REPO_DIR / interface_file
    if not interface_path.exists():
        return None
    try:
        content = interface_path.read_text(encoding='utf-8')
    except Exception:
        return None
    m2 = INTERFACE_FIND_REGEX.search(content)
    if m2:
        return m2.group(1)
    return None


def replace_findbyid_signature(content, type_name):
    if not type_name:
        return content, False
    replaced = False
    if FIND_EMPTY_SIG_1.search(content):
        content = FIND_EMPTY_SIG_1.sub(f"Future<Result<{type_name}?>> findById(String id) async", content)
        replaced = True
    if FIND_EMPTY_SIG_2.search(content):
        content = FIND_EMPTY_SIG_2.sub(f"Future<Result<{type_name}?>> findById(String id) async", content)
        replaced = True
    return content, replaced


def sanitize_repository_exception(content):
    # Find the RepositoryException class and replace its body with the standard definition using brace counting
    start_idx = content.find(REPO_EXCEPTION_CLASS_START)
    if start_idx == -1:
        return content, False
    # Find matching closing brace
    i = start_idx + len(REPO_EXCEPTION_CLASS_START)
    brace_count = 1  # already inside class '{'
    # Move to first '{' position
    # Find the index of '{' that opens the class (it's the last char of START)
    # Continue scanning
    while i < len(content) and brace_count > 0:
        ch = content[i]
        if ch == '{':
            brace_count += 1
        elif ch == '}':
            brace_count -= 1
        i += 1
    if brace_count != 0:
        # Unbalanced, skip
        return content, False
    end_idx = i  # 'i' is position after the closing '}'
    new_content = content[:start_idx] + STANDARD_REPO_EXCEPTION + content[end_idx:]
    return new_content, True


def process_file(path: Path):
    try:
        text = path.read_text(encoding='utf-8')
    except Exception:
        return False, False
    type_name = get_interface_type(text)
    text2, changed_sig = replace_findbyid_signature(text, type_name)
    text3, changed_exc = sanitize_repository_exception(text2)
    if changed_sig or changed_exc:
        path.write_text(text3, encoding='utf-8')
        return True, (changed_sig or changed_exc)
    return True, False


def main():
    changed_files = []
    for file in REPOS_DIR.glob('supabase_*_repository.dart'):
        ok, changed = process_file(file)
        if not ok:
            print(f"Skipped (read error): {file}")
            continue
        if changed:
            changed_files.append(str(file))
    if changed_files:
        print("Updated files:")
        for f in changed_files:
            print(f" - {f}")
    else:
        print("No changes applied.")

if __name__ == '__main__':
    main()