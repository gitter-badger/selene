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

  var bucket = new RequestBucket.getOrCreate(
      Uri.parse('https://discordapp.com/api/v6/channels/460274841715605516'),
      client.restClient);

  var channel = await client.restClient.getChannel('460274841715605516');
  print(channel.body.asJson());

  printRatelimits(bucket);
}

void printRatelimits(RequestBucket bucket) {
  print('== Bucket Info ==');
  print('URL: ${bucket.endpoint.toString()}');
  print('Remaining requests: ${bucket.remaining}');
  print('Request limit: ${bucket.limit}');
  print('Resets at (ISO-8601): ${bucket.resetTime.toIso8601String()}');
  print('=================');
}
