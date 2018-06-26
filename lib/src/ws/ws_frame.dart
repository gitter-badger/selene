part of selene;

/// A message received or being sent to the WebSocket.
class WSFrame {
  /// The data of this frame (the `d` property)
  ///
  /// This can either be a number, a string or a [Map<String, dynamic>] JSON map.
  dynamic data;

  /// The sequence number of this frame (the `s` property)
  ///
  /// Can only be received, and only on OP Code 0 - Dispatch.
  int sequenceNumber;

  /// The name of the event in this payload.
  ///
  /// Can only be received, and only on OP Code 0 - Dispatch.
  String eventName;

  /// The operation code (OP Code) of this payload.
  int opCode;

  /// Converts a JSON map to a [WSFrame].
  WSFrame.fromJson(Map<String, dynamic> model) {
    data = model['d'];
    sequenceNumber = model['s'];
    eventName = model['t'];
    opCode = model['op'];
  }

  /// Converts a [WSFrame] to a JSON map that can be sent.
  Map<String, dynamic> build() {
    var map = <String, dynamic>{};
    map['d'] = data;
    map['op'] = opCode;
    // eventName and sequenceNumber can only be received
    return map;
  }
}
