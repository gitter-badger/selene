part of selene;

/// A guild channel that can have child channels.
class DiscordGuildCategoryChannel extends DiscordGuildChannel {
  /// A list of all child channels to this category.
  List<DiscordGuildChannel> get channels {
    return this
        .guild
        .channels
        .values
        .where((kv) => (kv._parentId ?? '') == id)
        .toList();
  }

  /// Creates a new [DiscordGuildCategoryChannel].
  DiscordGuildCategoryChannel(DiscordSession session) : super(session);
}
