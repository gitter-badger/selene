part of selene;

/// An exception thrown when a model fails to update.
class ModelUpdateException implements Exception {
  final DiscordEntity entity;
  final String message;

  const ModelUpdateException(this.entity, this.message);

  String toString() =>
      'ModelUpdateException: Model with ID ${entity.id} failed to update with message: ${message}';
}
