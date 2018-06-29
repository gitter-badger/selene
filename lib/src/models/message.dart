part of selene;

/// A message sent in a channel in Discord.
class DiscordMessage extends DiscordEntity {
  /// Creates a new [DiscordMessage].
  DiscordMessage(DiscordSession session) : super(session);

  /// The ID of the channel this message belongs to.
  String channelId;

  /// The author of this message.
  ///
  /// Will be null if it sent by a webhook. (Use `webhook` instead)
  DiscordUser author;

  // TODO: Webhooks

  /// The [DiscordTextChannel] to which this message was sent.
  DiscordTextChannel channel;

  /// Whether this message was sent in a [DiscordGuildTextChannel].
  bool get isInGuild => (channel is DiscordGuildTextChannel);

  /// Whether this message was not sent in a [DiscordGuildTextChannel].
  bool get isNotInGuild => !isInGuild;

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

  /// A list of all users mentioned in this message.
  List<DiscordUser> mentions = [];

  // TODO: Roles mentioned

  // TODO: Attachments

  // TODO: Embeds

  /// Reactions that have been applied to this message.
  List<DiscordReaction> reactions = [];

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
  _update(Map<String, dynamic> model) {
    super._update(model);

    channelId = model['channel_id'] ?? channelId;
    content = model['content'] ?? content;

    if (model['author'] != null) {
      if (model['webhook_id'] == null) {
        // Not a webhook
        author = new DiscordUser(session);
        author._update(model['author']);
      } else {}
    }

    if (model['timestamp'] != null) {
      timestamp = DateTime.parse(model['timestamp']);
    }
    if (model['edited_timestamp'] != null) {
      editedTimestamp = DateTime.parse(model['edited_timestamp']);
    }

    if (channel == null) {
      channel = session.getChannel(channelId) as DiscordTextChannel;
    }

    isTTS = model['tts'] ?? isTTS;
    mentionsEveryone = model['mention_everyone'] ?? mentionsEveryone;

    for (var jsonMentionee in model['mentions'] ?? []) {
      var mentionee = new DiscordUser(session);
      mentionee._update(jsonMentionee);
      mentions.add(mentionee);
    }

    for (var jsonReaction in model['reactions'] ?? []) {
      var reaction = new DiscordReaction(session);
      reaction._update(jsonReaction);
      reactions.add(reaction);
    }

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
