part of selene;

/// A list of configuration options when initializing a client.
class SessionOptions {
  /// The transport platform to use for all requests.
  transport.TransportPlatform transportPlatform;

  /// The REST wrapper to use for all REST requests.
  RestApiBase restClient;

  /// The WebSocket wrapper to use for all WebSocket-related events.
  WSBase webSocket;

  /// The token to authorize with.
  String token;

  /// The type of the token.
  String tokenType = 'Bot';

  SessionOptions(this.transportPlatform, this.tokenType, this.token,
      {this.restClient, this.webSocket}) {
    if (restClient == null)
      restClient = new RestApi(transportPlatform, tokenType + ' ' + token);
    if (webSocket == null)
      webSocket = new DiscordWebSocket(token, restClient, transportPlatform);
  }
}
