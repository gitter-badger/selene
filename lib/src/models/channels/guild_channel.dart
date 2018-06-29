part of selene;

/// A channel belonging to a guild in Discord.
abstract class DiscordGuildChannel extends DiscordChannel {
  /// The [DiscordGuild] this channel belongs to.
  DiscordGuild guild;

  /// `Internal`: The guild_id parameter (for resolving Guild)
  String _guildId;

  /// `Internal`: The parent_id parameter (for resolving category)
  String _parentId;

  /// The parent category of this channel.
  ///
  /// Null if it does not have a parent.
  DiscordGuildCategoryChannel get category {
    if (_parentId == null) return null;
    return session.getChannel(_parentId) as DiscordGuildCategoryChannel;
  }

  /// The sorting position of this channel in the channel listing.
  int sortingPosition;

  /// The name of this channel.
  String name;

  /// The permission overwrites in this channel.
  List<PermissionOverwrite> permissionOverwrites = [];

  /// Whether this channel is NSFW.
  bool isNsfw;

  /// Whether this channel is not NSFW.
  bool get isNotNsfw => !isNsfw;

  /// Creates a new [DiscordGuildChannel].
  DiscordGuildChannel(DiscordSession session) : super(session);

  @override
  _update(Map<String, dynamic> model) {
    super._update(model);
    if (model['guild_id'] != null) {
      guild = session.getGuild(model['guild_id']);
    }
    _guildId = model['guild_id'] ?? _guildId;
    if (model['parent_id'] != null) {
      _parentId = model['parent_id'];
    } else {
      _parentId = null;
    }
    sortingPosition = model['position'] ?? sortingPosition;
    name = model['name'] ?? name;
    isNsfw = model['nsfw'] ?? isNsfw;

    if (model['permission_overwrites'] != null) {
      for (var jsonOverwrite in model['permission_overwrites']) {
        var overwrite = new PermissionOverwrite(session);
        overwrite._update(jsonOverwrite);
        permissionOverwrites.add(overwrite);
      }
    }
  }
}
