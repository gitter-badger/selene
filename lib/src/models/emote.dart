part of selene;

/// Represents an emoji in Discord.
///
/// This emoji can be a standard emoji or a guild emoji.
class DiscordEmoji extends DiscordEntity {
  /// Creates a new [DiscordEmoji].
  DiscordEmoji(DiscordSession session) : super(session);

  /// The name of this emoji.
  String name;

  @override
  void _update(Map<String, dynamic> model) {
    super._update(model);

    name = model['name'] ?? name;
  }

  /// Determines the type and returns a new [DiscordEmoji].
  static DiscordEmoji fromJson(
      Map<String, dynamic> model, DiscordSession session) {
    if (model['id'] == null) {
      return new DiscordStandardEmoji(session);
    }
    return new DiscordGuildEmoji(session);
  }
}

/// Represents a custom emoji on a [DiscordGuild].
class DiscordGuildEmoji extends DiscordEmoji {
  /// Creates a new [DiscordGuildEmoji].
  DiscordGuildEmoji(DiscordSession session) : super(session);

  /// A list of roles that this emoji is whitelisted to.
  List<DiscordGuildRole> roles = [];

  /// The user who created this emoji.
  DiscordUser author;

  /// Whether this emoji must be wrapped in colons.
  bool requiresColons;

  /// Whether this emoji doesn't have to be wrapped in colons.
  bool get doesNotRequireColons => !requiresColons;

  /// Whether this emoji is managed by an integration.
  bool isManaged;

  /// Whether this emoji is not managed by an integration.
  bool get isNotManaged => !isManaged;

  /// Whether this emoji is animated.
  bool isAnimated;

  /// Whether this emoji is not animated.
  bool get isNotAnimated => !isAnimated;

  @override
  void _update(Map<String, dynamic> model) {
    super._update(model);

    for (var jsonRole in model['roles'] ?? []) {
      var role = new DiscordGuildRole(session);
      role._update(jsonRole);
      roles.add(role);
    }

    if (model['user'] != null) {
      var tempAuthor = new DiscordUser(session);
      tempAuthor._update(model['user']);
      author = tempAuthor;
    }

    requiresColons = model['require_colons'] ?? requiresColons;
    isManaged = model['managed'] ?? isManaged;
    isAnimated = model['animated'] ?? isAnimated;
  }
}

/// Represents a standard Discord emoji.
class DiscordStandardEmoji extends DiscordEmoji {
  /// Creates a new [DiscordStandardEmoji].
  DiscordStandardEmoji(DiscordSession session) : super(session);
}
