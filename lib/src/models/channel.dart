part of selene;

/// A generic channel in Discord.
abstract class DiscordChannel extends DiscordEntity {
  /// Creates a new [DiscordChannel].
  DiscordChannel(DiscordSession session) : super(session);

  /// The type of this channel.
  ChannelType type;

  @override
  Future _update(Map<String, dynamic> model) async {
    await super._update(model);

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
}

/// A type of channel.
enum ChannelType { GuildText, GuildVoice, GuildCategory, DM, GroupDM }
