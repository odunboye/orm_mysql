import 'dart:io';
import 'package:dotenv/dotenv.dart' as dotenv;

/// Config class
abstract class Config {
  // ignore: always_specify_types
  static Map<String, dynamic> get _env => dotenv.env ?? {};
  static String get host => _env['HOST'] as String ?? '127.0.0.1';
  static int get port => int.tryParse(_env['PORT'] as String) ?? 3000;
  static String get secret => _env['JWT_AUTH_SECRET'] as String ?? '';
  static String get db => _env['DB'] as String ?? 'MYSQL';
  static bool get isCors => ((_env['IS_CORS']) as String)?.parseBool() ?? false;
  static String get corsUrl => _env['CORS_URL'] as String ?? '*';
  static Future<void> init() async {
    final String filename = (await File.fromUri(Uri.parse('.env')).exists())
        ? '.env'
        : '.env.example';
    return dotenv.load(filename);
  }
}

extension BoolParsing on String {
  bool parseBool() {
    return this.toLowerCase() == 'true';
  }
}
