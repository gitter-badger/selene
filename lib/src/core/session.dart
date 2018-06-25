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
  RestApiBase restClient;

  /// Creates a Discord session.
  DiscordSession(SessionOptions options) {
    restClient = options.restClient;
    transportPlatform = options.transportPlatform;

    token = options.token;
    tokenType = options.tokenType;

    if (restClient == null)
      restClient = new RestApi(transportPlatform,
          options.tokenType + ' ' + options.token); // Default implementation
  }
}
