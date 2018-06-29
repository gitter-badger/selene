part of selene;

/// A reaction to a message on Discord.
class DiscordReaction extends DiscordEntity {
  /// Creates a new [DiscordReaction].
  DiscordReaction(DiscordSession session) : super(session);

  /// The amount of times this emoji has been used to react.
  int count;

  /// Whether the current user has reacted.
  bool haveReacted;

  /// Whether the current user has not reacted.
  bool get hasNotReacted => !haveReacted;

  /// The emoji that was used to react.
  DiscordEmoji emoji;

  @override
  void _update(Map<String, dynamic> model) {
    super._update(model);

    count = model['count'];
    haveReacted = model['me'];

    if (model['emoji']['id'] == null) {
      emoji = new DiscordStandardEmoji(session);
      emoji._update(model['emoji']);
    } else {
      emoji = session._emojiCache[model['emoji']['id']];
    }
  }
}
