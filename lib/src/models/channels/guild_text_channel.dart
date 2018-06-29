part of selene;

/// A guild channel with messaging capability.
class DiscordGuildTextChannel extends DiscordGuildChannel
    with DiscordTextChannel {
  /// Creates a new [DiscordGuildTextChannel].
  DiscordGuildTextChannel(DiscordSession session) : super(session);

  /// The current topic of this channel.
  String topic;

  /// The date and time the last pinned message was pinned.
  DateTime lastPin;

  @override
  _update(Map<String, dynamic> model) {
    super._update(model);

    if (model['topic'] != null && model['topic'].isNotEmpty) {
      topic = model['topic'];
    }

    lastMessageId = model['last_message_id'] ?? lastMessageId;
    if (model['last_pin_timestamp'] != null) {
      lastPin = DateTime.parse(model['last_pin_timestamp']);
    }
  }

  @override
  Future sendMessage(
      {String content, Map<String, dynamic> embed, bool isTTS = false}) async {
    if (content == null && embed == null) {
      throw new ArgumentError(
          'sendMessage: Content and/or embed must be provided.');
    }

    var requestParams = <String, dynamic>{'tts': isTTS};
    if (content != null) requestParams['content'] = content;
    if (embed != null) requestParams['embed'] = embed;

    await session.restClient.createMessage(id, requestParams);
  }
}
