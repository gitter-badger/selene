part of selene;

/// An event dispatcher, which consumes and emits Discord entity events.
class DiscordDispatcher {
  /// A map of all event handlers.
  static Map<String, Future Function(Map<String, dynamic> data)>
      _eventHandlers = {
    'READY': (data) async {
    }
  };

  // EVENTS

  /// Emitted when the client is ready.
  Stream onReady = null;
  StreamController onReadyController = new StreamController.broadcast();

  /// Creates a new dispatcher, and attaches events.
  DiscordDispatcher() {
    onReady = onReadyController.stream;
  }

  /// Handles a raw Discord event from Discord.
  Future _handle(String eventName, Map<String, dynamic> data) async {
    var handler = _eventHandlers[eventName];
    if (handler != null) await handler(data);
  }
}
