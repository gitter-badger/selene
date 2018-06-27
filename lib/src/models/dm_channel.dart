part of selene;

/// A two-way channel between two Discord users.
class DiscordDMChannel extends DiscordChannel with DiscordTextChannel {
  /// Creates a new [DiscordDMChannel].
  DiscordDMChannel(DiscordSession session) : super(session);

  /// A list of all recipients of this DM.
  List<DiscordUser> recipients = [];

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

  @override
  Future _update(Map<String, dynamic> model) async {
    await super._update(model);

    if (model['recipients'] != null) {
      recipients = [];
      await Future.forEach(model['recipients'], (jsonRecipient) async {
        var recipient = new DiscordUser(session);
        await recipient._update(jsonRecipient);
        recipients.add(recipient);
      });
    }
    lastMessageId = model['last_message_id'] ?? lastMessageId;
  }
}
