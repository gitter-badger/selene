import 'dart:async';
import 'dart:io';

import 'package:selene/selene.dart';
import 'package:test/test.dart';

import 'package:w_transport/vm.dart' show vmTransportPlatform;

void main() {
  devBot();
}

Future devBot() async {
  var client = new DiscordSession(
      Platform.environment['SELENE_TOKEN'], vmTransportPlatform);
  await client.start();
}
