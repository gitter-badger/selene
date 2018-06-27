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
  StreamController onReadyController = new StreamController.broadcast();

  /// Emitted when the client joins a guild.
  Stream<DiscordGuild> onGuildJoin = null;
  StreamController<DiscordGuild> onGuildJoinController =
      new StreamController.broadcast();

  /// Emited when a guild is updated.
  Stream<DiscordGuild> onGuildUpdate = null;
  StreamController<DiscordGuild> onGuildUpdateController =
      new StreamController.broadcast();

  /// Emitted when the client leaves, or is removed from, a guild.
  Stream<DiscordGuild> onGuildLeave = null;
  StreamController<DiscordGuild> onGuildLeaveController =
      new StreamController.broadcast();

  /// Creates a new dispatcher, and attaches events.
  DiscordDispatcher(this.session) {
    onReady = onReadyController.stream;
    onGuildJoin = onGuildJoinController.stream;
    onGuildUpdate = onGuildUpdateController.stream;
    onGuildLeave = onGuildLeaveController.stream;

    _eventHandlers = {
      'READY': (data) async {
        if (data['guilds'] != null) {
          for (var lazyJsonGuild in data['guilds']) {
            var lazyGuild = new DiscordGuild(session);
            await lazyGuild._update(lazyJsonGuild);
            session.guildCache[lazyGuild.id] = lazyGuild;
          }
        }
      },
      'GUILD_CREATE': (data) async {
        var guildId = data['id'];
        if (session.guildCache.containsKey(guildId)) {
          // Lazy loading guild from READY or a guild becomes available again to client
          var guild = session.guildCache[guildId];
          await guild._update(data);
          session.guildCache[guildId] = guild;
        } else {
          var guild = new DiscordGuild(session);
          await guild._update(data);
          session.guildCache[guildId] = guild;
          onGuildJoinController.add(guild);
        }
      },
      'GUILD_UPDATE': (data) async {
        var guild = session.guildCache[data['id']];
        await guild._update(data);
        session.guildCache[guild.id] = guild;
        onGuildUpdateController.add(guild);
      },
      'GUILD_DELETE': (data) async {
        var guild = session.guildCache[data['id']];
        if (data['unavailable'] == null) {
          // Removed or left guild
          onGuildLeaveController.add(guild);
          session.guildCache.remove(data['id']);
        } else {
          // Guild has gone offline
          await guild._update(data);
          session.guildCache[guild.id] = guild;
        }
      }
    };
  }

  /// Handles a raw Discord event from Discord.
  Future _handle(String eventName, Map<String, dynamic> data) async {
    var handler = _eventHandlers[eventName];
    if (handler != null) await handler(data);
  }
}
