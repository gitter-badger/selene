part of selene;

/// A guild channel with messaging capability.
class DiscordGuildTextChannel extends DiscordGuildChannel {
  /// Creates a new [DiscordGuildTextChannel].
  DiscordGuildTextChannel(DiscordSession session) : super(session);

  /// The current topic of this channel.
  String topic;

  /// The ID of the last message sent to this channel.
  String lastMessageId;

  /// The date and time the last pinned message was pinned.
  DateTime lastPin;

  @override
  Future _update(Map<String, dynamic> model) async {
    await super._update(model);

    topic = model['topic'] ?? null;
    lastMessageId = model['last_message_id'] ?? lastMessageId;
    if (model['last_pin_timestamp'] != null) {
      lastPin = DateTime.parse(model['last_pin_timestamp']);
    }
  }
}
