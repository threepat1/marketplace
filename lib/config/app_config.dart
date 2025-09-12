class AppConfig {
  /// Base URL for backend API.
  ///
  /// Defaults to [http://10.0.2.2:4000], which works for Android emulators.
  /// Override at build time with `--dart-define=API_BASE_URL=...` for other
  /// environments.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:4000',
  );
}
