part of selene;

abstract class DiscordTextChannel {
  Future sendMessage({String content, Map<String, dynamic> embed, bool isTTS});

  /// The ID of the last message sent to this channel.
  String lastMessageId;

  /// The type of this channel.
  ChannelType type;

  /// A message cache.
  Map<String, DiscordMessage> messages = <String, DiscordMessage>{};
}
