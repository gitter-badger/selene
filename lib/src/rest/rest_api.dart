part of selene;

/// The default implementation of the Discord REST API.
class RestApi implements RestApiBase {
  DiscordSession _session;
  transport.HttpClient client;

  String _token;

  String get token => _token;

  void set token(String newToken) {
    _token = newToken;
    client.headers['Authorization'] = newToken;
  }

  Uri baseUri = Uri.parse('https://discordapp.com/api/v6');

  RestApi(this._session) {
    client =
        new transport.HttpClient(transportPlatform: _session.transportPlatform);
    token = _session.token;
  }

  @override
  Future<transport.Response> makeRequest(
      transport.JsonRequest request, String method) {
    return request.send(method);
  }

  @override
  Future<transport.Response> makeNewRequest(String uriReference, String method,
      [Map<String, dynamic> params]) async {
    var request = client.newJsonRequest();
    request.uri = baseUri.resolve(uriReference);
    if (params != null) request.body = params;
    return await request.send(method);
  }

  @override
  Future<transport.Response> addPinnedChannelMessage(
          String channelId, String messageId) =>
      makeNewRequest('/channels/$channelId/pins/$messageId', 'PUT');

  @override
  Future<transport.Response> addRecipientToGroupDm(
          String channelId, String userId, Map<String, dynamic> params) =>
      makeNewRequest('/channels/$channelId/recipients/$userId', 'PUT', params);

  @override
  Future<transport.Response> createChannelInvite(
          String channelId, Map<String, dynamic> params) =>
      makeNewRequest('/channels/$channelId/invites', 'POST', params);

  @override
  Future<transport.Response> createMessage(
          String channelId, Map<String, dynamic> params) =>
      makeNewRequest('/channels/$channelId/messages', 'POST', params);

  @override
  Future<transport.Response> createReaction(
          String channelId, String messageId, String emojiFormat) =>
      makeNewRequest(
          '/channels/$channelId/messages/$messageId/reactions/$emojiFormat/@me',
          'PUT');

  @override
  Future<transport.Response> deleteAllReactions(
          String channelId, String messageId) =>
      makeNewRequest(
          '/channels/$channelId/messages/$messageId/reactions', 'DELETE');

  @override
  Future<transport.Response> deleteChannel(String id) =>
      makeNewRequest('/channels/$id', 'DELETE');

  @override
  Future<transport.Response> deleteChannelPermission(
          String channelId, String overwriteId) =>
      makeNewRequest('/channels/$channelId/permissions/$overwriteId', 'DELETE');

  @override
  Future<transport.Response> deleteMessage(
          String channelId, String messageId) =>
      makeNewRequest('/channels/$channelId/messages/$messageId', 'DELETE');

  @override
  Future<transport.Response> deleteMessagesBulk(
          String channelId, Map<String, dynamic> params) =>
      makeNewRequest(
          '/channels/$channelId/messages/bulk-delete', 'DELETE', params);

  @override
  Future<transport.Response> deleteOwnReaction(
          String channelId, String messageId, String emojiFormat) =>
      makeNewRequest(
          '/channels/$channelId/messages/$messageId/reactions/$emojiFormat/@me',
          'DELETE');

  @override
  Future<transport.Response> deletePinnedChannelMessage(
          String channelId, String messageId) =>
      makeNewRequest('/channels/$channelId/pins/$messageId', 'DELETE');

  @override
  Future<transport.Response> deleteUserReaction(String channelId,
          String messageId, String emojiFormat, String userId) =>
      makeNewRequest(
          '/channels/$channelId/messages/$messageId/reactions/$emojiFormat/$userId',
          'DELETE');

  @override
  Future<transport.Response> editChannelPermissions(
          String channelId, String overwriteId, Map<String, dynamic> params) =>
      makeNewRequest('/channels/$channelId/permissions/$overwriteId', 'PUT');

  @override
  Future<transport.Response> editMessage(String channelId, String messageId,
          [Map<String, dynamic> params]) =>
      makeNewRequest('/channels/$channelId/messages/$messageId', 'PATCH');

  @override
  Future<transport.Response> getChannel(String id,
      [Map<String, dynamic> params])

  @override
  Future<transport.Response> getChannelInvites(String channelId) {
    // TODO: implement getChannelInvites
  }

  @override
  Future<transport.Response> getChannelMessage(
      String channelId, String messageId) {
    // TODO: implement getChannelMessage
  }

  @override
  Future<transport.Response> getChannelMessages(String channelId,
      [Map<String, dynamic> params]) {
    // TODO: implement getChannelMessages
  }

  @override
  Future<transport.Response> getPinnedMessages(String channelId) {
    // TODO: implement getPinnedMessages
  }

  @override
  Future<transport.Response> getReactions(
      String channelId, String messageId, String emojiFormat,
      [Map<String, dynamic> params]) {
    // TODO: implement getReactions
  }

  @override
  Future<transport.Response> modifyChannel(String id, String method,
      [Map<String, dynamic> params]) {
    // TODO: implement modifyChannel
  }

  @override
  Future<transport.Response> removeRecipientFromGroupDm(
      String channelId, String userId) {
    // TODO: implement removeRecipientFromGroupDm
  }

  @override
  Future<transport.Response> triggerTypingIndicator(String channelId) {
    // TODO: implement triggerTypingIndicator
  }
}
