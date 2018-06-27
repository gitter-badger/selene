part of selene;

/// A Discord session, capable of connecting to the WebSocket and handling requests.
class DiscordSession {
  /// The transport platform to use for all requests from this session.
  transport.TransportPlatform transportPlatform;

  /// The current dispatcher in use.
  DiscordDispatcher dispatcher;

  /// The token to use for authorization.
  String token = '';

  /// The token type to prefix tokens.
  String tokenType = 'Bot';

  /// The REST API currently in use.
  RestApiBase restClient;

  /// The WebSocket adapter currently in use.
  WSBase webSocket;

  /// Creates a Discord session.
  DiscordSession(
    String token,
    transport.TransportPlatform transportPlatform, {
    RestApiBase restClient,
    WSBase webSocket,
    String tokenType = 'Bot',
  }) {
    this.token = token;
    this.tokenType = tokenType;
    this.transportPlatform = transportPlatform;
    this.restClient =
        restClient ?? new RestApi(transportPlatform, tokenType + ' ' + token);
    this.webSocket = webSocket ?? new DiscordWebSocket(token, restClient, this);
  }

  /// Starts the WebSocket.
  Future start() async {
    await webSocket.start();
  }

  /// Stops the WebSocket.
  Future stop() async {
    await webSocket.stop();
  }

  // Utility functions
}
