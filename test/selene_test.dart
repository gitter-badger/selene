import 'dart:async';
import 'dart:io';

import 'dart:convert';

import 'package:selene/selene.dart';
import 'package:test/test.dart';

import 'package:w_transport/vm.dart' show vmTransportPlatform;

void main() {
  devBot();
}

Future devBot() async {
  var client = new DiscordSession(
      Platform.environment['SELENE_TOKEN'], vmTransportPlatform);

  client.dispatcher.onMessageCreate.listen((DiscordMessage msg) async {
    print('Received message with content {${msg.content}}');
    print('From {${msg.author.username}}');
    if (msg.content == '!cache') {
      if (msg.channel is DiscordGuildChannel) {
        var guildChannel = msg.channel as DiscordGuildTextChannel;
        print('Getting cache for guild ' + guildChannel.guildId);
        var guild = client.getGuild(guildChannel.guildId);
        var sb = new StringBuffer();
        await Future.forEach(guild.channels.values,
            (DiscordGuildChannel guildChannel) async {
          sb.writeln(
              '`${guildChannel.name}` -> `${guildChannel.runtimeType.toString()}`');
        });
        await guildChannel.sendMessage(
            content: (sb.toString().isEmpty ? 'Nothing.' : sb.toString()));
      } else if (msg.channel is DiscordDMChannel) {
        await msg.channel.sendMessage(content: 'Hello DM!');
      }
    }
  });

  await client.start();
}
