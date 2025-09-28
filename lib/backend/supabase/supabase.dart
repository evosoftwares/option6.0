import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

export 'database/database.dart';
export 'auth/supabase_auth_manager.dart';
export 'auth/supabase_user_provider.dart';

String _kSupabaseUrl = dotenv.env['SUPABASE_URL'] ?? 'https://qlbwacmavngtonauxnte.supabase.co';
String _kSupabaseAnonKey =
    dotenv.env['SUPABASE_ANON_KEY'] ?? 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFsYndhY21hdm5ndG9uYXV4bnRlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDg3MTYzMzIsImV4cCI6MjAyNDI5MjMzMn0.IPFL2f8dslKK-jU2lYGJJwHcL0ZqOVmTIiTQK5QzF2E';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  // Expor URL configurada para logs/diagnósticos (sem segredos)
  static String get configuredUrl => _kSupabaseUrl;

  // Fornecer uma "impressão digital" da anon key sem expor o segredo completo em logs
  static String get anonKeyFingerprint {
    final k = _kSupabaseAnonKey;
    if (k.isEmpty) return 'unset';
    if (k.length <= 10) return '${k.substring(0, k.length ~/ 2)}***';
    return '${k.substring(0, 6)}...${k.substring(k.length - 4)}';
  }

  static Future initialize() => Supabase.initialize(
        url: _kSupabaseUrl,
        headers: {
          'X-Client-Info': 'flutterflow',
        },
        anonKey: _kSupabaseAnonKey,
        debug: false,
        authOptions:
            FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
      );
}