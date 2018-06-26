/// Predictable Dart bindings for the Discord API.
library selene;

import 'dart:async';

import 'dart:core';

import 'dart:core';

import 'package:w_transport/w_transport.dart' as transport;

// Core
part 'src/core/session.dart';
part 'src/core/session_options.dart';

// REST
part 'src/rest/rest_api_base.dart';
part 'src/rest/rest_api.dart';
part 'src/rest/request_bucket.dart';
part 'src/rest/ratelimited_exception.dart';

// WebSocket
part 'src/ws/ws_base.dart';
part 'src/ws/ws_frame.dart';

// Shared models
part 'src/models/entity.dart';

/// The version number of this Selene version.
String versionNumber = '0.1.0';
