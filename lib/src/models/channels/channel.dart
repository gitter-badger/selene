part of selene;

/// A generic channel in Discord.
abstract class DiscordChannel extends DiscordEntity {
  /// Creates a new [DiscordChannel].
  DiscordChannel(DiscordSession session) : super(session);

  /// The type of this channel.
  ChannelType type;

  @override
  _update(Map<String, dynamic> model) {
    super._update(model);

    switch (model['type']) {
      case 0:
        type = ChannelType.GuildText;
        break;
      case 1:
        type = ChannelType.DM;
        break;
      case 2:
        type = ChannelType.GuildVoice;
        break;
      case 3:
        type = ChannelType.GroupDM;
        break;
      case 4:
        type = ChannelType.GuildCategory;
        break;
      default:
        throw new ModelUpdateException(
            this, 'Received invalid channel type from Discord.');
    }
  }

  /// Generates a [DiscordChannel] based off of the supplied data.
  static DiscordChannel fromJson(
      Map<String, dynamic> model, DiscordSession session) {
    switch (model['type']) {
      case 0:
        return new DiscordGuildTextChannel(session);
      case 1:
        return new DiscordDMChannel(session);
      case 2:
        return new DiscordGuildVoiceChannel(session);
      case 4:
        return new DiscordGuildCategoryChannel(session);
      default:
        return null;
    }
  }
}

/// A type of channel.
enum ChannelType { GuildText, GuildVoice, GuildCategory, DM, GroupDM }
