import 'dart:async';

import 'package:selene/selene.dart';
import 'package:test/test.dart';

import 'package:w_transport/vm.dart' show vmTransportPlatform;

void main() {
  devBot().then((obj) {
    print('Developer bot process finished.');
  });
}

Future devBot() async {
  var client = new DiscordSession(new SessionOptions(vmTransportPlatform, 'Bot',
      'NDU4NDgzMzY0NTU5NTg1Mjgw.DhNofA.grKVLX01XhHuAXXfNKARYnVhIiE'));

  var channel = await client.restClient.getChannel('460274841715605516');
  print(channel.body.asJson());
}
