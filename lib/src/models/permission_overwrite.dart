part of selene;

class PermissionOverwrite extends DiscordEntity {
  /// Creates a new [PermissionOverwrite].
  PermissionOverwrite(DiscordSession session) : super(session);

  /// The type of this overwrite.
  OverwriteType type;

  /// The permission bit set which this overwrite allows.
  int allowed;

  /// The permission bit set which this overwrite denies.
  int denied;

  @override
  _update(Map<String, dynamic> model) {
    super._update(model);
    switch (model['type']) {
      case 'role':
        type = OverwriteType.Role;
        break;
      case 'member':
        type = OverwriteType.Member;
        break;
      default:
        throw new ModelUpdateException(
            this, 'Permission overwrite is of invalid type.');
    }
    allowed = model['allow'];
    denied = model['deny'];
  }
}

enum OverwriteType { Role, Member }
