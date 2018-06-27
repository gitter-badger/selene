part of selene;

class DiscordUser extends DiscordEntity {
  /// Creates a new [DiscordUser].
  DiscordUser(DiscordSession session) : super(session);

  /// This user's username.
  ///
  /// Not unique across the Discord platform.
  String username;

  /// This user's 4-digit Discord Tag.
  String discriminator;

  /// This user's 4-digit Discord Tag parsed to an integer.
  int get discriminatorValue => int.parse(discriminator);

  /// The avatar hash of this user.
  String avatarHash;

  /// Whether this user is a bot.
  bool isBot;

  /// Whether this user is not a bot.
  bool get isNotBot => !isBot;

  /// Whether this user has MFA enabled.
  bool hasMFAEnabled;

  /// Whether this user does not have MFA enabled.
  bool get doesNotHaveMFAEnabled => !hasMFAEnabled;

  @override
  Future _update(Map<String, dynamic> model) async {
    username = model['username'] ?? username;
    discriminator = model['discriminator'] ?? discriminator;
    avatarHash = model['avatar'] ?? avatarHash;
    isBot = model['isBot'] ?? isBot;
    if (model['isBot'] == null || model['isBot'] == false) {
      isBot = false;
    } else {
      isBot = true;
    }
    hasMFAEnabled = model['mfa_enabled'] ?? hasMFAEnabled;
  }
}
