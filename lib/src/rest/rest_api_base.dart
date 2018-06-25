part of selene;

/// A base for the Discord REST API implementation.
abstract class RestApiBase {
  /// Executes a [transport.JsonRequest] using a bucket.
  Future<transport.Response> makeRequest(
      transport.JsonRequest request, String method);

  /// Creates a new request using the paremeters, and executes it using a bucket.
  Future<transport.Response> makeNewRequest(String uriReference, String method,
      [Map<String, dynamic> params]);

  /// Gets a channel by ID. Returns a channel object.
  ///
  /// Route: `GET /channels/{id}`
  Future<transport.Response> getChannel(String id);

  /// Modifies a channel.
  ///
  /// Returns a channel object on success,
  /// and a 400 BAD REQUEST on invalid parameters.
  /// For the PATCH method, all JSON params are optional.
  ///
  /// Routes: `PUT /channels/{id}` and `PATCH /channels/{id}`
  Future<transport.Response> modifyChannel(String id, String method,
      [Map<String, dynamic> params]);

  /// Deletes a channel, or closes a private message.
  ///
  /// Requires the `MANAGE_CHANNELS` permission.
  /// Returns a channel object on success.
  ///
  /// Route: `DELETE /channels/{id}`
  Future<transport.Response> deleteChannel(String id);

  /// Returns the messages for a channel.
  ///
  /// If on a guild channel, requires the `VIEW_CHANNEL` permission.
  /// If the `READ_MESSAGE_HISTORY` permission is denied, it will return an empty array.
  /// Returns an array of message objects on success.
  ///
  /// Route: `GET /channels/{channelId}/messages`
  Future<transport.Response> getChannelMessages(String channelId,
      [Map<String, dynamic> params]);

  /// Returns a specific message in the channel.
  ///
  /// If on a guild channel, requires the `READ_MESSAGE_HISTORY` permission.
  /// Returns a message object on success.
  ///
  /// Route: `GET /channels/{channelId}/messages/{messageId}`
  Future<transport.Response> getChannelMessage(
      String channelId, String messageId);

  /// Posts a message to a guild text or DM channel.
  ///
  /// If on a guild channel, requires the `SEND_MESSAGES` permission.
  /// If `tts = true`, requires the `SEND_TTS_MESSAGES` permission.
  /// Returns a message object on success.
  ///
  /// Route: `POST /channels/{channelId}/messages`
  Future<transport.Response> createMessage(
      String channelId, Map<String, dynamic> params);

  /// Creates a reaction for the message.
  ///
  /// Requires the `READ_MESSAGE_HISTORY` permission.
  /// Requires the `ADD_REACTION` permission if this is the first reaction on this message.
  /// Returns `204 Empty Response` on success.
  ///
  /// Route: `PUT /channels/{channelId}/messages/{messageId}/reactions/{emojiFormat}/@me`
  Future<transport.Response> createReaction(
      String channelId, String messageId, String emojiFormat);

  /// Deletes a reaction the current user has made for the message.
  ///
  /// Returns `204 Empty Response` on success.
  ///
  /// Route: `DELETE /channels/{channelId}/messages/{messageId}/reactions/{emojiFormat}/@me`
  Future<transport.Response> deleteOwnReaction(
      String channelId, String messageId, String emojiFormat);

  /// Deletes another user's reaction.
  ///
  /// Requires the `MANAGE_MESSAGES` permission.
  /// Returns `204 Empty Response` on success.
  ///
  /// Route: `DELETE /channels/{channelId}/messages/{messageId}/reactions/{emojiFormat}/{userId}`
  Future<transport.Response> deleteUserReaction(
      String channelId, String messageId, String emojiFormat, String userId);

  /// Gets a list of users that have reacted with this emoji.
  ///
  /// Returns an array of user objects on success.
  ///
  /// Route: `GET /channels/{channelId}/messages/{messageId}/reactions/{emojiFormat}`
  Future<transport.Response> getReactions(
      String channelId, String messageId, String emojiFormat,
      [Map<String, dynamic> params]);

  /// Deletes all reactions on a message.
  ///
  /// Requires the `MANAGE_MESSAGES` permission.
  /// Returns(?) `204 No Response` on success.
  ///
  /// Route: `DELETE /channels/{channelId}/messages/{messageId}/reactions`
  Future<transport.Response> deleteAllReactions(
      String channelId, String messageId);

  /// Edits a previously sent messages.
  ///
  /// You can only edit messages that have been sent by the current user.
  /// Returns a message object on success.
  ///
  /// Route: `PATCH /channels/{channelId}/messages/{messageId}`
  Future<transport.Response> editMessage(String channelId, String messageId,
      [Map<String, dynamic> params]);

  /// Deletes a message.
  ///
  /// If on a guild channel and trying to delete a message not sent by the current user, this requires `MANAGE_MESSAGES`.
  /// Returns `204 Empty Response` on success.
  ///
  /// Route: `DELETE /channels/{channelId}/messages/{messageId}`
  Future<transport.Response> deleteMessage(String channelId, String messageId);

  /// Deletes multiple messages in a single request.
  ///
  /// This can only be used in guild channels.
  /// Requires the `MANAGE_MESSAGES` permission.
  /// Returns `204 Empty Response` on success.
  ///
  /// Route: `POST /channels/{channelId}/messages/bulk-delete`
  Future<transport.Response> deleteMessagesBulk(
      String channelId, Map<String, dynamic> params);

  /// Edits the channel permission overwrites for a user.
  ///
  /// Requires the `MANAGE_ROLES` permission.
  /// Only usable in guild channels.
  /// Returns `204 Empty Response` on success.
  ///
  /// Route: `PUT /channels/{channelId}/permissions/{overwriteId}`
  Future<transport.Response> editChannelPermissions(
      String channelId, String overwriteId, Map<String, dynamic> params);

  /// Returns a list of invite objects (with metadata) for the channel.
  ///
  /// Only usable in guild channels.
  /// Requires the `MANAGE_CHANNELS` permission.
  ///
  /// Route: `GET /channels/{channelId}/invites`
  Future<transport.Response> getChannelInvites(String channelId);

  /// Creates a new invite object for the channel.
  ///
  /// Only usable in guild channels.
  /// Requires the `CREATE_INSTANT_INVITE` permission.
  /// All JSON parameters are optional, however if you are not sending any fields you still must send a blank JSON object.
  /// Returns an invite object.
  ///
  /// Route: `POST /channels/{channelId}/invites`
  Future<transport.Response> createChannelInvite(
      String channelId, Map<String, dynamic> params);

  /// Deletes a channel permission overwrite for a user or role in a channel.
  ///
  /// Only usable in guild channels.
  /// Requires the `MANAGE_ROLES` permission.
  /// Returns a `204 Empty Response` on success.
  ///
  /// Route: `DELETE /channels/{channelId}/permissions/{overwriteId}`
  Future<transport.Response> deleteChannelPermission(
      String channelId, String overwriteId);

  /// Post a typing indicator for the specified indicator.
  ///
  /// Generally, bots should not implement this route. Exceptions apply if the computation may take longer than a few seconds.
  /// Returns a `204 Empty Response` on success.
  ///
  /// Route: `POST /channels/{channelId}/typing`
  Future<transport.Response> triggerTypingIndicator(String channelId);

  /// Returns all pinned messages in the channel.
  ///
  /// Returns an array of message objects.
  ///
  /// Route: `GET /channels/{channelId}/pins`
  Future<transport.Response> getPinnedMessages(String channelId);

  /// Pins a message in a channel.
  ///
  /// Requires the `MANAGE_MESSAGES` permission.
  /// Returns a `204 Empty Response` on success.
  ///
  /// Route: `PUT /channels/{channelId}/pins/{messageId}`
  Future<transport.Response> addPinnedChannelMessage(
      String channelId, String messageId);

  /// Unpins a message in a channel.
  ///
  /// Requires the `MANAGE_MESSAGES` permission.
  /// Returns a `204 Empty Response` on success.
  ///
  /// Route: `DELETE /channels/{channelId}/pins/{messageId}`
  Future<transport.Response> deletePinnedChannelMessage(
      String channelId, String messageId);

  /// Adds a recipient to a Group DM using their access token.
  ///
  /// Returns(?) a `204 Empty Response` on success.
  ///
  /// Route: `PUT /channels/{channelId}/recipients/{userId}`
  Future<transport.Response> addRecipientToGroupDm(
      String channelId, String userId, Map<String, dynamic> params);

  /// Removes a recipient from a Group DM.
  ///
  /// Returns(?) a `204 Empty Response` on success.
  ///
  /// Route: `DELETE /channels/{channelId}/recipients/{userId}`
  Future<transport.Response> removeRecipientFromGroupDm(
      String channelId, String userId);
}
