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

  /// A map of channel IDs to their respective guilds.
  Map<String, String> _channelGuildMap = {};

  /// The entity cache for Discord guilds.
  Map<String, DiscordGuild> _guildCache = {};

  /// The entity cache for private messages.
  Map<String, DiscordDMChannel> _privateChannelCache = {};

  /// Creates a Discord session.
  DiscordSession(
    String token,
    transport.TransportPlatform transportPlatform, {
    RestApiBase rest,
    WSBase socket,
    String tokenType = 'Bot',
  }) {
    this.token = token;
    this.tokenType = tokenType;
    this.transportPlatform = transportPlatform;
    this.restClient =
        rest ?? new RestApi(transportPlatform, tokenType + ' ' + token);
    this.webSocket = socket ?? new DiscordWebSocket(token, restClient, this);
    dispatcher = new DiscordDispatcher(this);
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

  /// Retrieves a channel from the cache.
  DiscordChannel getChannel(String id) {
    if (_channelGuildMap.containsKey(id)) {
      var guild = getGuild(_channelGuildMap[id]);
      return guild.channels[id];
    } else if (_privateChannelCache.containsKey(id)) {
      return _privateChannelCache[id];
    } else {
      return null;
    }
  }

  /// Retrieves a guild from the cache.
  DiscordGuild getGuild(String id) {
    return _guildCache[id];
  }
}
