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

  /// OAuth server client ID for Google Sign-In.
  ///
  /// Provide at build time with
  /// `--dart-define=GOOGLE_SERVER_CLIENT_ID=your_client_id`.
  static const googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '',
  );
}
