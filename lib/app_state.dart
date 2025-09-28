import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    secureStorage = FlutterSecureStorage();
    await _safeInitAsync(() async {
      _currencyValue =
          await secureStorage.getDouble('ff_currencyValue') ?? _currencyValue;
    });
    await _safeInitAsync(() async {
      _supabaseAnnonkey =
          await secureStorage.getString('ff_supabaseAnnonkey') ??
              _supabaseAnnonkey;
    });
    await _safeInitAsync(() async {
      _supabaseUrl =
          await secureStorage.getString('ff_supabaseUrl') ?? _supabaseUrl;
    });
    await _safeInitAsync(() async {
      _currentUserUIDSupabase =
          await secureStorage.getString('ff_currentUserUIDSupabase') ??
              _currentUserUIDSupabase;
    });
    await _safeInitAsync(() async {
      _currentUserEmail =
          await secureStorage.getString('ff_currentUserEmail') ??
              _currentUserEmail;
    });
    await _safeInitAsync(() async {
      _supabaseAccessToken =
          await secureStorage.getString('ff_supabaseAccessToken') ??
              _supabaseAccessToken;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  double _currencyValue = 0.0;
  double get currencyValue => _currencyValue;
  set currencyValue(double value) {
    _currencyValue = value;
    secureStorage.setDouble('ff_currencyValue', value);
  }

  void deleteCurrencyValue() {
    secureStorage.delete(key: 'ff_currencyValue');
  }

  LatLng? _latlngVazio = LatLng(0, 0);
  LatLng? get latlngVazio => _latlngVazio;
  set latlngVazio(LatLng? value) {
    _latlngVazio = value;
  }

  String _supabaseAnnonkey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5tb2hxZXZzZGFlbWJwanViYmF1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM0Njk1NDIsImV4cCI6MjA2OTA0NTU0Mn0.r95LNoK9hvR0puJlp1E0UtDIAGNdaoGXynoueYs8e4s';
  String get supabaseAnnonkey => _supabaseAnnonkey;
  set supabaseAnnonkey(String value) {
    _supabaseAnnonkey = value;
    secureStorage.setString('ff_supabaseAnnonkey', value);
  }

  void deleteSupabaseAnnonkey() {
    secureStorage.delete(key: 'ff_supabaseAnnonkey');
  }

  String _supabaseUrl = 'https://nmohqevsdaembpjubbau.supabase.co';
  String get supabaseUrl => _supabaseUrl;
  set supabaseUrl(String value) {
    _supabaseUrl = value;
    secureStorage.setString('ff_supabaseUrl', value);
  }

  void deleteSupabaseUrl() {
    secureStorage.delete(key: 'ff_supabaseUrl');
  }

  String _currentUserUIDSupabase = '';
  String get currentUserUIDSupabase => _currentUserUIDSupabase;
  set currentUserUIDSupabase(String value) {
    _currentUserUIDSupabase = value;
    secureStorage.setString('ff_currentUserUIDSupabase', value);
  }

  void deleteCurrentUserUIDSupabase() {
    secureStorage.delete(key: 'ff_currentUserUIDSupabase');
  }

  String _currentUserEmail = '';
  String get currentUserEmail => _currentUserEmail;
  set currentUserEmail(String value) {
    _currentUserEmail = value;
    secureStorage.setString('ff_currentUserEmail', value);
  }

  void deleteCurrentUserEmail() {
    secureStorage.delete(key: 'ff_currentUserEmail');
  }

  String _supabaseAccessToken = '';
  String get supabaseAccessToken => _supabaseAccessToken;
  set supabaseAccessToken(String value) {
    _supabaseAccessToken = value;
    secureStorage.setString('ff_supabaseAccessToken', value);
  }

  void deleteSupabaseAccessToken() {
    secureStorage.delete(key: 'ff_supabaseAccessToken');
  }
}

// Removido: função não utilizada _safeInit

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: ListToCsvConverter().convert([value]));
}
