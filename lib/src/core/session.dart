part of selene;

/// A Discord session, capable of connecting to the WebSocket and handling requests.
class DiscordSession {
  /// The transport platform to use for all requests from this session.
  transport.TransportPlatform transportPlatform;

  /// The token to use for authorization.
  String token = '';

  /// The token type to prefix tokens.
  String tokenType = 'Bot';

  /// The REST API currently in use.
  RestApiBase rest;

  /// Creates a Discord session.
  DiscordSession(SessionOptions options) {
    if (rest == null)
      rest = new RestApi(
          transportPlatform, options.tokenType + ' ' + options.token);
  }
}
