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
  Future<transport.Response> addPinnedChannelMessage(
      String channelId, String messageId) {
    var request = client.newJsonRequest();
    return request.put(
        uri: baseUri.resolve('/channels/$channelId/pins/$messageId'));
  }

  @override
  Future<transport.Response> addRecipientToGroupDm(
      String channelId, String userId, Map<String, dynamic> params) {
    var request = client.newJsonRequest();
    return request.put(
        uri: baseUri.resolve('/channels/$channelId/recipients/$userId'),
        body: params);
  }

  @override
  Future<transport.Response> createChannelInvite(
      String channelId, Map<String, dynamic> params) {
    var request = client.newJsonRequest();
    return request.post(
        uri: baseUri.resolve('/channels/$channelId/invites'), body: params);
  }

  @override
  Future<transport.Response> createMessage(
      String channelId, Map<String, dynamic> params) {
    var request = client.newJsonRequest();
    return request.post(
        uri: baseUri.resolve('/channels/$channelId/messages'), body: params);
  }

  @override
  Future<transport.Response> createReaction(
      String channelId, String messageId, String emojiFormat) {
    var request = client.newJsonRequest();
    return request.put(
        uri: baseUri.resolve(
            '/channels/$channelId/messages/$messageId/reactions/$emojiFormat/@me'));
  }

  @override
  Future<transport.Response> deleteAllReactions(
      String channelId, String messageId) {
    var request = client.newJsonRequest();
    return request.delete(
        uri: baseUri
            .resolve('/channels/$channelId/messages/$messageId/reactions'));
  }

  @override
  Future<transport.Response> deleteChannel(String id) {
    var request = client.newJsonRequest();
    return request.delete(uri: baseUri.resolve('/channels/$id'));
  }

  @override
  Future<transport.Response> deleteChannelPermission(
      String channelId, String overwriteId) {
    var request = client.newJsonRequest();
    return request.delete(
        uri: baseUri.resolve('/channels/$channelId/permissions/$overwriteId'));
  }

  @override
  Future<transport.Response> deleteMessage(String channelId, String messageId) {
    // TODO: implement deleteMessage
  }

  @override
  Future<transport.Response> deleteMessagesBulk(
      String channelId, Map<String, dynamic> params) {
    // TODO: implement deleteMessagesBulk
  }

  @override
  Future<transport.Response> deleteOwnReaction(
      String channelId, String messageId, String emojiFormat) {
    // TODO: implement deleteOwnReaction
  }

  @override
  Future<transport.Response> deletePinnedChannelMessage(
      String channelId, String messageId) {
    // TODO: implement deletePinnedChannelMessage
  }

  @override
  Future<transport.Response> deleteUserReaction(
      String channelId, String messageId, String emojiFormat, String userId) {
    // TODO: implement deleteUserReaction
  }

  @override
  Future<transport.Response> editChannelPermissions(
      String channelId, String overwriteId, Map<String, dynamic> params) {
    // TODO: implement editChannelPermissions
  }

  @override
  Future<transport.Response> editMessage(String channelId, String messageId,
      [Map<String, dynamic> params]) {
    // TODO: implement editMessage
  }

  @override
  Future<transport.Response> getChannel(String id,
      [Map<String, dynamic> params]) {
    // TODO: implement getChannel
  }

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
