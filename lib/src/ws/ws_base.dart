part of selene;

/// A generic abstract class for WebSocket wrappers.
abstract class WSBase {
  /// Opens the WebSocket connection and begins exchanging data.
  Future start([bool reconnecting = false]);

  /// Closes the WebSocket connection and stops heartbeats.
  Future stop();
}
