part of selene;

class DiscordGuildRole extends DiscordEntity {
  /// Creates a blank [DiscordGuildRole].
  DiscordGuildRole(DiscordSession session) : super(session);

  /// The name of this role.
  String name;

  /// The hexadecimal colour code of this role.
  int hexColour;

  /// Whether this role is hoisted (pinned) in the user listing.
  bool isHoisted;

  /// Whether this role is not hoisted (pinned) in the user listing.
  bool get isNotHoisted => !isHoisted;

  /// The position of this role in the role list.
  int position;

  /// The permission bit set of this role.
  int permissions;

  /// Whether this role is managed by an integration.
  bool isManaged;

  /// Whether this role is not managed by an integration.
  bool get isNotManaged => !isManaged;

  /// Whether this role is mentionable.
  bool isMentionable;

  /// Whether this role is not mentionable.
  bool get isNotMentionable => !isMentionable;

  @override
  Future _update(Map<String, dynamic> model) async {
    name = model['name'];
    hexColour = model['color'];
    isHoisted = model['hoist'];
    position = model['position'];
    permissions = model['permissions'];
    isManaged = model['managed'];
    isMentionable = model['mentionable'];
  }
}
