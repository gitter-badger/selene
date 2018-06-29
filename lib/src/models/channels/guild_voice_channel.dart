part of selene;

/// A guild channel with voice capability.
class DiscordGuildVoiceChannel extends DiscordGuildChannel {
  /// Creates a new [DiscordGuildVoiceChannel].
  DiscordGuildVoiceChannel(DiscordSession session) : super(session);

  /// The bitrate of this channel.
  int bitrate;

  /// The user limit for this channel.
  ///
  /// 0 for no limit.
  int userLimit;

  @override
  _update(Map<String, dynamic> model) {
    bitrate = model['bitrate'] ?? bitrate;
    userLimit = model['user_limit'] ?? userLimit;

    super._update(model);
  }
}
