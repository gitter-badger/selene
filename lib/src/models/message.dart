part of selene;

/// A message sent in a channel in Discord.
class DiscordMessage extends DiscordEntity {
  /// Creates a new [DiscordMessage].
  DiscordMessage(DiscordSession session) : super(session);

  /// The ID of the channel this message belongs to.
  String channelId;

  // TODO: Users

  /// The content of this message.
  String content;

  /// The timestamp of this message.
  DateTime timestamp;

  /// The timestamp of when this message was edited.
  ///
  /// Null if this message was never edited.
  DateTime editedTimestamp;

  /// Whether this message is TTS (Text-To-Speech).
  bool isTTS;

  /// Whether this message is not TTS (Text-To-Speech).
  bool get isNotTTS => !isTTS;

  /// Whether this message mentions @everyone.
  bool mentionsEveryone;

  /// Whether this message does not mention @everyone.
  bool get doesNotMentionEveryone => !mentionsEveryone;

  // TODO: Mention users

  // TODO: Roles mentioned

  // TODO: Attachments

  // TODO: Embeds

  // TODO: Reactions

  // TODO: Nonce?

  /// Whether this message was pinned.
  bool isPinned;

  /// Whether this message was not pinned.
  bool get isNotPinned => !isPinned;

  /// The type of message.
  MessageType type;

  /// The ID of the webhook, if this message was created by a webhook.
  String webhookId;

  /// Whether this message was created by a webhook.
  bool get createdByWebhook => webhookId != null;

  /// Whether this message was not created by a webhook.
  bool get notCreatedByWebhook => !createdByWebhook;

  @override
  Future _update(Map<String, dynamic> model) async {
    await super._update(model);

    channelId = model['channel_id'] ?? channelId;
    content = model['content'] ?? content;
    if (model['timestamp'] != null) {
      timestamp = DateTime.parse(model['timestamp']);
    }
    if (model['edited_timestamp'] != null) {
      editedTimestamp = DateTime.parse(model['edited_timestamp']);
    }
    isTTS = model['tts'] ?? isTTS;
    mentionsEveryone = model['mention_everyone'] ?? mentionsEveryone;
    isPinned = model['pinned'] ?? isPinned;
    webhookId = model['webhook_id'] ?? webhookId;
    switch (model['type']) {
      case 0:
        type = MessageType.Default;
        break;
      case 1:
        type = MessageType.RecipientAdd;
        break;
      case 2:
        type = MessageType.RecipientRemove;
        break;
      case 3:
        type = MessageType.Call;
        break;
      case 4:
        type = MessageType.ChannelNameChange;
        break;
      case 5:
        type = MessageType.ChannelIconChange;
        break;
      case 6:
        type = MessageType.ChannelPinnedMessage;
        break;
      case 7:
        type = MessageType.GuildMemberJoin;
        break;
    }
  }
}

/// A type of message.
enum MessageType {
  Default,
  RecipientAdd,
  RecipientRemove,
  Call,
  ChannelNameChange,
  ChannelIconChange,
  ChannelPinnedMessage,
  GuildMemberJoin
}
