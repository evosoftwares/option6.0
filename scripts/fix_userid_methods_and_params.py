#!/usr/bin/env python3
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPOS_DIR = ROOT / 'lib' / 'infrastructure' / 'repositories'

def process_file(path: Path):
    text = path.read_text(encoding='utf-8')
    original = text
    changed = False

    # 1) Fix duplicate findById that should be findByUserId
    # Find second occurrence of a findById method whose body queries user_id
    # We'll search method headers and inspect following lines
    method_iter = list(re.finditer(r"@override\s*\n\s*Future<Result<([A-Za-z0-9_]+)\?>>\s+findById\(String\s+id\)\s+async\s*\{", text))
    if len(method_iter) >= 2:
        # try to transform occurrences after the first
        for m in method_iter[1:]:
            start = m.start()
            # extract method body up to matching closing brace using brace counting
            i = m.end()  # position after '{'
            brace = 1
            while i < len(text) and brace:
                if text[i] == '{':
                    brace += 1
                elif text[i] == '}':
                    brace -= 1
                i += 1
            body = text[m.end():i-1]
            if "q.eq('user_id'" in body:
                # rename signature and parameter, and replace eq argument inside body
                header_old = text[m.start():m.end()]
                # Build new header preserving generic type
                type_name = m.group(1)
                header_new = re.sub(r"findById\(String\s+id\)", "findByUserId(String userId)", header_old)
                new_body = body.replace("q.eq('user_id', String)", "q.eq('user_id', userId)")
                # also handle cases where it used id variable inside user_id filter
                new_body = new_body.replace("q.eq('user_id', id)", "q.eq('user_id', userId)")
                # reassemble
                text = text[:m.start()] + header_new + new_body + text[i-1:]
                changed = True
                # Since text changed length, do not reuse previous indices; break to rescan file
                break

    # 2) Fix wrong eq argument leftover globally: replace in any findByUserId method scopes
    text = text.replace("q.eq('user_id', String)", "q.eq('user_id', userId)")

    # 3) Fix DriverRepository method parameter names in driver repository files
    if path.name == 'supabase_driver_repository.dart':
        # updateOnlineStatus signature and usage
        text2 = re.sub(r"updateOnlineStatus\(String\s+String,\s*bool\s+isOnline\)",
                       "updateOnlineStatus(String driverId, bool isOnline)", text)
        text2 = text2.replace("matchingRows: (rows) => rows.eq('id', String)",
                              "matchingRows: (rows) => rows.eq('id', driverId)")
        # updateLocation signature and usage
        text2 = re.sub(r"updateLocation\(String\s+String,\s*Location\s+location\)",
                       "updateLocation(String driverId, Location location)", text2)
        text2 = text2.replace("matchingRows: (rows) => rows.eq('id', String)",
                              "matchingRows: (rows) => rows.eq('id', driverId)")
        # Add @override to findAvailableInRadius if missing
        text2 = re.sub(r"(\n\s*)Future<Result<List<Driver>>>\s+findAvailableInRadius",
                       r"\1@override\n  Future<Result<List<Driver>>> findAvailableInRadius", text2)
        if text2 != text:
            text = text2
            changed = True

    if changed:
        path.write_text(text, encoding='utf-8')
        return True
    return False


def main():
    changed_files = []
    for file in REPOS_DIR.glob('supabase_*_repository.dart'):
        try:
            if process_file(file):
                changed_files.append(str(file))
        except Exception as e:
            print(f"Error processing {file}: {e}")
    if changed_files:
        print("Updated files:")
        for f in changed_files:
            print(f" - {f}")
    else:
        print("No changes applied.")

if __name__ == '__main__':
    main()