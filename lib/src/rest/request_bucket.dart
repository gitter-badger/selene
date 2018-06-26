part of selene;

/// A bucketing utility to handle ratelimits.
///
/// Based off of https://github.com/abalabahaha/eris/blob/master/lib/util/SequentialBucket.js
///
/// and https://github.com/CharlotteDunois/Yasmin/blob/master/src/HTTP/RatelimitBucket.php
class RequestBucket {
  /// The URI to access for this endpoint.
  Uri endpoint;

  /// The internal queue.
  List<transport.Request> _queue = null;

  /// The Epoch time (seconds since 00:00:00 UTC on January 1st, 1970) at which the ratelimit resets.
  DateTime resetTime = null;

  /// Whether this bucket's current status is on a global endpoint.
  bool isGlobalBucket = false;

  /// The amount of available requests remaining.
  int remaining = null;

  /// The total limit of requests.
  int limit = null;

  /// The REST API to execute requests with.
  RestApiBase restClient;

  /// Creates a new [RequestBucket].
  RequestBucket(this.restClient) {
    _queue = <transport.Request>[];
  }

  /// Queues a [Function] in this bucket.
  Future queueRequest(transport.Request request) async {
    _queue.add(request);
  }

  /// Attempts to run the first [Request] in the queue.
  Future<transport.Response> executeQueue(String method) {
    var request = getFirstRequest();
    if (request == null) return null;

    var completer = new Completer<transport.Response>();

    if (remaining == null) {
      request.send(method).then((resp) {
        parseRatelimitHeaders(resp);

        completer.complete(resp);
      });
      return completer.future;
    }

    if (remaining > 0) {
      request.send(method).then((resp) {
        parseRatelimitHeaders(resp);

        completer.complete(resp);
      }).catchError((err) {
        completer.completeError(err);
      });
      return completer.future;
    }

    var timeDifference = (new DateTime.now()).difference(resetTime);

    if (timeDifference.inSeconds < 0) {
      // Ratelimit would've reset by now, run request now
      request.send(method).then((resp) {
        parseRatelimitHeaders(resp);

        completer.complete(resp);
      }).catchError((err) {
        completer.completeError(err);
      });
    } else {
      new Timer(timeDifference, () {
        request.send(method).then((resp) {
          parseRatelimitHeaders(resp);

          completer.complete(resp);
        }).catchError((err) {
          completer.completeError(err);
        });
      });
    }

    return completer.future;
  }

  /// Returns a [Request] from the front of the queue, or null if there is none.
  transport.Request getFirstRequest() {
    try {
      return _queue.first;
    } on StateError {
      // No element at first index.
      return null;
    }
  }

  /// Parses the ratelimit headers from a response.
  void parseRatelimitHeaders(transport.Response response) {
    if (response.headers['X-RateLimit-Remaining'] != null) {
      remaining = int.parse(response.headers['X-RateLimit-Remaining']);
    }

    if (response.headers['X-RateLimit-Limit'] != null) {
      limit = int.parse(response.headers['X-RateLimit-Limit']);
    }

    if (response.headers['X-RateLimit-Reset'] != null) {
      resetTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(response.headers['X-RateLimit-Reset']) ~/
              60, // Convert seconds (from Discord) to milliseconds
          isUtc: true);
    }

    if (response.headers['X-RateLimit-Global'] != null) {
      isGlobalBucket = true;
    } else
      isGlobalBucket = false;
  }
}
