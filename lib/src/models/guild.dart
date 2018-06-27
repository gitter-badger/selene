part of selene;

/// A guild in Discord, a isolated collection of users and channels.
///
/// Referred to as 'Servers' in the UI.
class DiscordGuild extends DiscordEntity {
  /// Creates a new [DiscordGuild].
  DiscordGuild(DiscordSession session) : super(session);

  /// The name of this guild (2-100 characters).
  String name;

  /// The hash of this guild's icon.
  ///
  /// Null if this server does not have an icon.
  String iconHash;

  /// The hash of this guild's splash image.
  ///
  /// Null if this server has no splash.
  String splashHash;

  /// If the requester is the owner of this guild.
  bool isOwner;

  /// If the requester is not the owner of this guild.
  bool get isNotOwner => !isOwner;

  /// The ID of the owner of this guild.
  String ownerId;

  /// The total permissions for the requester.
  ///
  /// Does not include channel overrides.
  int permissionsNumber;

  /// The voice region of this guild.
  String voiceRegion;

  /// The ID of the AFK channel for this guild.
  ///
  /// Null if it doesn't exist.
  String afkChannelId;

  /// The AFK timeout for this guild in seconds.
  int afkTimeout;

  /// Whether or not this guild has an AFK channel.
  bool get hasAfkChannel => afkChannelId != null;

  /// Whether or not this guild does not have an AFK channel.
  bool get doesNotHaveAfkChannel => !hasAfkChannel;

  /// If this guild can be embedded (i.e. in a widget)
  bool isEmbeddable;

  /// If this guild can not be embedded (i.e. in a widget)
  bool get isNotEmbeddable => !isEmbeddable;

  /// The ID of the embedded channel.
  ///
  /// Null if this is not embedded.
  int embeddedChannelId;

  /// The verification level required for this guild.
  ///
  /// See https://discordapp.com/developers/docs/resources/guild#guild-object-verification-level
  int verificationLevel;

  /// The default message notifications option set for this guild.
  ///
  /// See https://discordapp.com/developers/docs/resources/guild#guild-object-default-message-notification-level
  int defaultMessageNotificationsLevel;

  /// The level that the explicit content filter operates at.
  ///
  /// See https://discordapp.com/developers/docs/resources/guild#guild-object-explicit-content-filter-level
  int explicitContentFilterLevel;

  /// A list of roles in this guild.
  List<DiscordGuildRole> roles = [];

  // TODO: Emoji objects

  /// A list of features enabled for this guild.
  List<String> featuresEnabled = [];

  /// The required MFA level for this guild.
  ///
  /// See https://discordapp.com/developers/docs/resources/guild#guild-object-mfa-level
  int mfaLevel;

  /// The application ID of the guild creator, if it is bot-created.
  String creatorApplicationId;

  /// Whether this guild is bot-created.
  bool get isCreatedByBot => creatorApplicationId != null;

  /// Whether this guild is not bot-created.
  bool get isNotCreatedByBot => !isCreatedByBot;

  /// Whether this guild's widget is enabled.
  bool isWidgetEnabled;

  /// Whether this guild's widget is not enabled.
  bool get isNotWidgetEnabled => !isWidgetEnabled;

  /// If the widget is enabled, the channel ID for it.
  String widgetChannelId;

  /// The ID of the channel where system messages are sent.
  String systemMessageChannelId;

  /// When the requester joined this guild.
  DateTime dateJoined;

  /// Whether this guild is considered 'large'.
  bool isLarge;

  /// Whether this guild is not considered 'large'.
  bool get isNotLarge => !isLarge;

  /// Whether or not this guild is available.
  bool isAvailable;

  /// Whether or not this guild is not available (unavailable).
  bool get isNotAvailable => !isAvailable;

  /// The total count of members in this guild.
  int memberCount;

  /// The channels in this guild.
  Map<String, DiscordGuildChannel> channels = {};

  // TODO: Voice States
  // TODO: Guild Member Arra
  // TODO: Presences

  @override
  Future _update(Map<String, dynamic> model) async {
    await super._update(model);

    // Unavailable (received during Ready, or guild goes offline)
    if (model['unavailable'] != null) {
      isAvailable = !(model['unavailable']);
      if (isNotAvailable) {
        name = null;
        iconHash = null;
        splashHash = null;
        isOwner = null;
        ownerId = null;
        permissionsNumber = null;
        voiceRegion = null;
        afkChannelId = null;
        afkTimeout = null;
        isEmbeddable = null;
        embeddedChannelId = null;
        verificationLevel = null;
        defaultMessageNotificationsLevel = null;
        explicitContentFilterLevel = null;
        roles = [];
        channels = {};
        featuresEnabled = [];
        mfaLevel = null;
        creatorApplicationId = null;
        isWidgetEnabled = null;
        widgetChannelId = null;
        systemMessageChannelId = null;
        dateJoined = null;
        isLarge = null;
      }
    }

    name = model['name'] ?? name;
    iconHash = model['icon'] ?? iconHash;
    splashHash = model['splash'] ?? splashHash;
    isOwner = model['owner'] ?? isOwner;
    ownerId = model['owner_id'] ?? ownerId;
    permissionsNumber = model['permissions'] ?? permissionsNumber;
    voiceRegion = model['region'] ?? voiceRegion;
    afkChannelId = model['afk_channel_id'] ?? afkChannelId;
    afkTimeout = model['afk_timeout'] ?? afkTimeout;
    isEmbeddable = model['embed_enabled'] ?? isEmbeddable;
    embeddedChannelId = model['embed_channel_id'] ?? embeddedChannelId;
    verificationLevel = model['verification_level'] ?? verificationLevel;
    memberCount = model['member_count'] ?? memberCount;
    defaultMessageNotificationsLevel = model['default_message_notifications'] ??
        defaultMessageNotificationsLevel;
    explicitContentFilterLevel =
        model['explicit_content_filter'] ?? explicitContentFilterLevel;

    if (model['roles'] != null) {
      await Future.forEach(model['roles'], (jsonRole) async {
        var role = new DiscordGuildRole(session);
        await role._update(jsonRole);
        roles.add(role);
      });
    }

    if (model['channels'] != null) {
      await Future.forEach(model['channels'], (jsonChannel) async {
        var channel = (DiscordChannel.fromJson(jsonChannel, session))
            as DiscordGuildChannel;
        await channel._update(jsonChannel);
        channel.guild = this;
        channels[channel.id] = channel;
        session._channelGuildMap[channel.id] = id;
      });
    }

    if (model['features'] != null) {
      await Future.forEach(model['features'], (feature) {
        featuresEnabled.add(feature.toString());
      });
    }

    mfaLevel = model['mfa_level'] ?? mfaLevel;
    creatorApplicationId = model['application_id'] ?? creatorApplicationId;
    isWidgetEnabled = model['widget_enabled'] ?? isWidgetEnabled;
    widgetChannelId = model['widget_channel_id'] ?? widgetChannelId;
    systemMessageChannelId =
        model['system_channel_id'] ?? systemMessageChannelId;

    if (model['joined_at'] != null)
      dateJoined = DateTime.parse(model['joined_at']);

    isLarge = model['large'] ?? isLarge;
  }
}
