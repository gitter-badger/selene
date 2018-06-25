part of selene;

/// A list of configuration options when initializing a client.
class SessionOptions {
  /// The transport platform to use for all requests.
  transport.TransportPlatform transportPlatform;

  /// The REST wrapper to use for all REST requests.
  RestApiBase restClient;

  /// The token to authorize with.
  String token;

  /// The type of the token.
  String tokenType = 'Bot';

  SessionOptions(this.transportPlatform, this.token,
      {this.restClient, this.tokenType}) {
    if (restClient == null)
      restClient = new RestApi(transportPlatform, tokenType + ' ' + token);
  }
}
