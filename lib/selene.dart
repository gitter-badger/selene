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
part 'src/models/guild.dart';
part 'src/models/channel.dart';
part 'src/models/dm_channel.dart';
part 'src/models/guild_channel.dart';
part 'src/models/guild_text_channel.dart';
part 'src/models/text_channel.dart';
part 'src/models/guild_category_channel.dart';
part 'src/models/guild_voice_channel.dart';
part 'src/models/message.dart';
part 'src/models/permission_overwrite.dart';
part 'src/models/guild_role.dart';

/// The version number of this Selene version.
String versionNumber = '0.1.0';

/// Represents a WebSocket OP Code frame handler.
typedef PayloadHandler = Future Function(WSFrame frame);
