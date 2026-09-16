import 'package:flutter/foundation.dart';

class AppConfig {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const String googleMapsApiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

  static bool get isConfigured {
    return supabaseUrl.isNotEmpty &&
        supabaseAnonKey.isNotEmpty &&
        googleMapsApiKey.isNotEmpty;
  }

  static void validate() {
    if (!isConfigured) {
      final missing = <String>[];
      if (supabaseUrl.isEmpty) missing.add('SUPABASE_URL');
      if (supabaseAnonKey.isEmpty) missing.add('SUPABASE_ANON_KEY');
      if (googleMapsApiKey.isEmpty) missing.add('GOOGLE_MAPS_API_KEY');
      throw StateError(
        'Missing required configuration: ${missing.join(', ')}. '
        'Pass them via --dart-define or platform config files.',
      );
    }
  }
}