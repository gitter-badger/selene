part of selene;

/// An event dispatcher, which consumes and emits Discord entity events.
class DiscordDispatcher {
  /// A map of all event handlers.
  Map<String, Future Function(Map<String, dynamic> data)> _eventHandlers;

  /// The [DiscordSession] this dispatcher belongs to.
  DiscordSession session;

  // EVENTS

  /// Emitted when the client is ready.
  Stream onReady = null;
  StreamController _onReadyController = new StreamController.broadcast();

  /// Emitted when the client joins a guild.
  Stream<DiscordGuild> onGuildJoin = null;
  StreamController<DiscordGuild> _onGuildJoinController =
      new StreamController.broadcast();

  /// Emited when a guild is updated.
  Stream<DiscordGuild> onGuildUpdate = null;
  StreamController<DiscordGuild> _onGuildUpdateController =
      new StreamController.broadcast();

  /// Emitted when the client leaves, or is removed from, a guild.
  Stream<DiscordGuild> onGuildLeave = null;
  StreamController<DiscordGuild> _onGuildLeaveController =
      new StreamController.broadcast();

  /// Creates a new dispatcher, and attaches events.
  DiscordDispatcher(this.session) {
    onReady = _onReadyController.stream;
    onGuildJoin = _onGuildJoinController.stream;
    onGuildUpdate = _onGuildUpdateController.stream;
    onGuildLeave = _onGuildLeaveController.stream;

    _eventHandlers = {
      'READY': (data) async {
        if (data['guilds'] != null) {
          for (var lazyJsonGuild in data['guilds']) {
            var lazyGuild = new DiscordGuild(session);
            await lazyGuild._update(lazyJsonGuild);
            session._guildCache[lazyGuild.id] = lazyGuild;
          }
        }
      },
      'GUILD_CREATE': (data) async {
        var guildId = data['id'];
        if (session._guildCache[guildId] != null) {
          // Lazy loading guild from READY or a guild becomes available again to client
          await (session._guildCache[guildId])._update(data);
        } else {
          var guild = new DiscordGuild(session);
          await guild._update(data);
          session._guildCache[guildId] = guild;
          _onGuildJoinController.add(guild);
        }
      },
      'GUILD_UPDATE': (data) async {
        var guild = session._guildCache[data['id']];
        await guild._update(data);
        session._guildCache[guild.id] = guild;
        _onGuildUpdateController.add(guild);
      },
      'GUILD_DELETE': (data) async {
        var guild = session._guildCache[data['id']];
        if (data['unavailable'] == null) {
          // Removed or left guild
          _onGuildLeaveController.add(guild);
          session._guildCache.remove(data['id']);
        } else {
          // Guild has gone offline
          await guild._update(data);
          session._guildCache[guild.id] = guild;
        }
      },
      'CHANNEL_CREATE': (data) async {
        var channel = DiscordChannel.fromJson(data, session);
        await channel._update(data);

        if (channel.type == ChannelType.GuildCategory ||
            channel.type == ChannelType.GuildText ||
            channel.type == ChannelType.GuildVoice) {
          var guildChannel = channel as DiscordGuildChannel;
          session._channelGuildMap[guildChannel.id] = guildChannel.guildId;
        }
      },
      'CHANNEL_UPDATE': (data) async {},
      'CHANNEL_DELETE': (data) async {},
    };
  }

  /// Handles a raw Discord event from Discord.
  Future _handle(String eventName, Map<String, dynamic> data) async {
    var handler = _eventHandlers[eventName];
    if (handler != null) await handler(data);
  }
}
