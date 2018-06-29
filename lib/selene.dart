/// Predictable Dart bindings for the Discord API.
library selene;

import 'dart:async';

import 'dart:core';

import 'dart:convert';
import 'dart:io';

import 'package:w_transport/w_transport.dart' as transport;

// Core
part 'src/core/session.dart';
part 'src/core/dispatcher.dart';

// REST
part 'src/rest/rest_api_base.dart';
part 'src/rest/rest_api.dart';
part 'src/rest/request_bucket.dart';
part 'src/rest/ratelimited_exception.dart';

// WebSocket
part 'src/ws/ws_base.dart';
part 'src/ws/ws_frame.dart';
part 'src/ws/websocket.dart';

// Models
part 'src/models/entity.dart';
part 'src/models/user.dart';
part 'src/models/model_exception.dart';
part 'src/models/message.dart';
part 'src/models/permission_overwrite.dart';
part 'src/models/guild_role.dart';
part 'src/models/emote.dart';
part 'src/models/reaction.dart';

// Models - Guilds
part 'src/models/guilds/guild.dart';

// Models - Channels
part 'src/models/channels/channel.dart';
part 'src/models/channels/dm_channel.dart';
part 'src/models/channels/guild_channel.dart';
part 'src/models/channels/guild_text_channel.dart';
part 'src/models/channels/text_channel.dart';
part 'src/models/channels/guild_category_channel.dart';
part 'src/models/channels/guild_voice_channel.dart';

/// The version number of this Selene version.
String versionNumber = '0.1.0';

/// Represents a WebSocket OP Code frame handler.
typedef PayloadHandler = Future Function(WSFrame frame);
