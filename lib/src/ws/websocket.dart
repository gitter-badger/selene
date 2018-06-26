part of selene;

/// The default implementation of [WSBase].
class DiscordWebSocket extends WSBase {
  /// Creates a new [DiscordWebSocket].
  DiscordWebSocket(this.token, this.restClient, this.transportPlatform) {
    _payloadHandlers = {
      0: (WSFrame frame) async {},
      1: (WSFrame frame) async {},
      7: (WSFrame frame) async {},
      8: (WSFrame frame) async {},
      9: (WSFrame frame) async {
        // OP 9 Invalid Session
        print('Invalid Session');
      },
      10: (WSFrame frame) async {
        // OP 10 Hello
        heartbeatInterval = frame.data['heartbeat_interval'];
        heartbeater = new Timer.periodic(
            new Duration(seconds: heartbeatInterval), (timer) async {
          await heartbeat();
        });
        // TODO: Resuming
        sendIdentify();
      },
      11: (WSFrame frame) async {},
    };
  }

  /// The current heartbeat timer.
  Timer heartbeater;

  /// The current heartbeat interval.
  int heartbeatInterval;

  /// The current JSON encoder.
  JsonEncoder _encoder = new JsonEncoder();

  /// The current JSON decoder.
  JsonDecoder _decoder = new JsonDecoder();

  /// The transport platform to use.
  transport.TransportPlatform transportPlatform;

  /// The current WebSocket event subscription.
  StreamSubscription<dynamic> _wsSubscription;

  /// The REST client to use.
  RestApiBase restClient;

  /// The internal [WebSocket].
  transport.WebSocket _ws;

  /// A cached URI for the Discord gateway.
  Uri gatewayUri;

  /// Whether the gateway URI has been cached.
  bool get gatewayUriCached =>
      (gatewayUri != null) && gatewayUri.toString().isNotEmpty;

  /// Whether the gateway URI has not been cached.
  bool get gatewayUriNotCached => !gatewayUriCached;

  /// The last sequence number this client received.
  int _lastSequence;

  /// The recommended shard count.
  ///
  /// Will be null unless [requestGatewayUri] with `shards = true` has been executed.
  int recommendedShardCount;

  /// Whether this WebSocket is using sharding.
  bool isSharding;

  /// Whether this WebSocket is not using sharding.
  bool get isNotSharding => !isSharding;

  /// (If sharding) This shard ID.
  int shardId;

  /// (If sharding) The total amount of shards in this client.
  int shardTotal;

  /// A list of all payload handlers.
  Map<int, PayloadHandler> _payloadHandlers;

  /// The token to authenticate with.
  String token;

  /// Requests a new gateway URI (and sets [recommendedShardCount] if `shards = true`) from Discord.
  Future<Uri> requestGatewayUri(bool shards) async {
    if (shards) {
      var shardResponse = await restClient.getGatewayWithShards();
      var shardBody = shardResponse.body.asJson();
      recommendedShardCount = shardBody['shards'];
      return Uri.parse(shardBody['url']);
    } else {
      var response = await restClient.getGateway();
      var body = response.body.asJson();
      recommendedShardCount = null;
      return Uri.parse(body['url']);
    }
  }

  /// Sends an identify payload over the WebSocket.
  void sendIdentify() {
    var frame = new WSFrame();
    frame.data = <String, dynamic>{
      'token': token,
      'properties': <String, dynamic>{
        "\$os": Platform.operatingSystem,
        '\$browser': 'Selene',
        '\$device': 'Selene'
      }
    };
    frame.opCode = 2; // OP 2 - Identify
    if (isSharding) {
      frame.data['shard'] = [shardId, shardTotal];
    }
    sendFrame(frame);
  }

  /// Sends a heartbeat payload over the WebSocket.
  Future heartbeat() async {
    var frame = new WSFrame();
    frame.data = _lastSequence;
    frame.opCode = 1; // OP 1 - Heartbeat
    sendFrame(frame);
  }

  /// Sends a [WSFrame] over the WebSocket.
  void sendFrame(WSFrame frame) {
    _ws.add(_encoder.convert(frame.build()));
  }

  @override
  Future start([bool reconnecting = false]) async {
    if (gatewayUriNotCached) {
      var reqUri = await requestGatewayUri(isSharding);
      gatewayUri = Uri.parse(reqUri.toString() + "?v=6&encoding=json");
    }
    _ws = await transport.WebSocket
        .connect(gatewayUri, transportPlatform: transportPlatform);

    _wsSubscription = _ws.listen(handleWSMessage,
        onError: handleWSError, onDone: handleWSClose);
  }

  /// Handles a message received from the WebSocket.
  Future handleWSMessage(dynamic message) async {
    var frame = new WSFrame.fromJson(_decoder.convert(message));
    var handler = _payloadHandlers[frame.opCode];
    if (handler == null) {
      print(
          '[Selene WebSocket] Warning: Received an OP code that doesn\'t have a handler, library version may be out-of-date.');
      return;
    }
    await handler(frame);
  }

  /// Handles an error received from the WebSocket.
  Future handleWSError(dynamic error) async {}

  /// Handles the WebSocket in the event that it is closed.
  Future handleWSClose() async {}

  @override
  Future stop() async {
    await _wsSubscription.cancel();
    await _ws.close();
  }
}
