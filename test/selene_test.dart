import 'dart:async';
import 'dart:io';

import 'package:selene/selene.dart';
import 'package:test/test.dart';

import 'package:w_transport/vm.dart' show vmTransportPlatform;

void main() {
  devBot().then((obj) {
    print('Developer bot process finished.');
  });
}

Future devBot() async {
  var client = new DiscordSession(new SessionOptions(
      vmTransportPlatform, 'Bot', Platform.environment['SELENE_TOKEN']));

  var msgid0 = '461064791809851392';
  var msgid1 = '461064798923128833';

  await client.restClient.deleteMessage('460274841715605516', msgid0);
  await client.restClient.deleteMessage('460274841715605516', msgid1);

  var bucket = new RequestBucket.getOrCreate(
      Uri.parse(
          'https://discordapp.com/api/v6/channels/460274841715605516/messages/$msgid0'),
      client.restClient);

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
