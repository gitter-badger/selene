part of selene;

/// A channel belonging to a guild in Discord.
abstract class DiscordGuildChannel extends DiscordChannel {
  /// The ID of the guild this channel belongs to.
  String guildId;

  /// The ID of the parent category of this channel.
  String parentCategoryId;

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
  Future _update(Map<String, dynamic> model) async {
    await super._update(model);
    guildId = model['guild_id'] ?? guildId;
    parentCategoryId = model['parent_category_id'] ?? parentCategoryId;
    sortingPosition = model['position'] ?? sortingPosition;
    name = model['name'] ?? name;
    isNsfw = model['nsfw'] ?? isNsfw;

    if (model['permission_overwrites'] != null) {
      for (var jsonOverwrite in model['permission_overwrites']) {
        var overwrite = new PermissionOverwrite(session);
        await overwrite._update(jsonOverwrite);
        permissionOverwrites.add(overwrite);
      }
    }
  }
}
