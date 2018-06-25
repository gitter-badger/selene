part of selene;

abstract class DiscordEntity {
  /// The ID of this Discord entity.
  ///
  /// This is a Snowflake entity converted to a String.
  String id;

  /// The session of this Discord entity.
  ///
  /// Usually this is the session that instantiated or retrieved this entity.
  DiscordSession session;

  /// Creates a new blank entity, automatically filling this entity's session reference.
  DiscordEntity(this.session);

  /// Updates this model, setting all properties to those available in [model].
  Future _update(Map<String, dynamic> model);
}
