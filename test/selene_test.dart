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
    if (msg.content == '!cache') {
      if (msg.channel is DiscordGuildChannel) {
        var guildChannel = msg.channel as DiscordGuildTextChannel;
        print('Getting cache for guild ' + guildChannel.guild.id);
        var guild = guildChannel.guild;
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
    if (msg.content == '!guild') {
      var message = msg.channel as DiscordGuildTextChannel;
      var guild = message.guild;

      var embed = <String, dynamic>{
        'title': 'Info for guild ${guild.name}',
        'description': 'Discord guild information',
        'fields': [
          {'name': 'Member Count', 'value': guild.memberCount, 'inline': true}
        ]
      };

      await msg.channel.sendMessage(embed: embed);
    }
    if (msg.content == '!channel') {
      if (msg.channel.type == ChannelType.DM) return;

      var channel = msg.channel as DiscordGuildTextChannel;
      var embed = <String, dynamic>{
        'title': 'Info for channel ${channel.name}',
        'description': 'Discord channel information',
        'fields': [
          {
            'name': 'Topic',
            'value': channel.topic ?? 'No topic',
            'inline': true
          }
        ]
      };

      if (channel.category != null) {
        embed['fields'].add(<String, dynamic>{
          'name': 'Category',
          'value': channel.category.name,
          'inline': true
        });
      }

      await channel.sendMessage(embed: embed);
    }
  });
  client.dispatcher.onReady.listen((_) {
    print('Ready');
  });

  await client.start();
}
