import 'dart:async';
import 'dart:convert';
import 'dart:io';

class FakeHttpOverrides extends HttpOverrides {
  FakeHttpOverrides({required this.routes});

  /// Maps URL (full string) to a fake response.
  final Map<Pattern, FakeHttpResponse> routes;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _FakeHttpClient(routes);
  }
}

class FakeHttpResponse {
  FakeHttpResponse({required this.statusCode, required this.body});

  final int statusCode;
  final String body;
}

FakeHttpResponse _matchRoute(Map<Pattern, FakeHttpResponse> routes, Uri url) {
  final urlString = url.toString();
  for (final entry in routes.entries) {
    final pattern = entry.key;
    if (pattern is RegExp) {
      if (pattern.hasMatch(urlString)) return entry.value;
    } else {
      if (urlString.contains(pattern.toString())) return entry.value;
    }
  }
  return FakeHttpResponse(
    statusCode: 404,
    body: jsonEncode({'error': 'Not found'}),
  );
}

class _FakeHttpClient implements HttpClient {
  _FakeHttpClient(this._routes);

  final Map<Pattern, FakeHttpResponse> _routes;

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async {
    return _FakeHttpClientRequest(method: method, url: url, routes: _routes);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpClientRequest implements HttpClientRequest {
  _FakeHttpClientRequest({
    required this.method,
    required this.url,
    required this.routes,
  });

  final String method;

  @override
  final Uri url;

  final Map<Pattern, FakeHttpResponse> routes;

  final _FakeHttpHeaders _headers = _FakeHttpHeaders();

  final BytesBuilder _bodyBuilder = BytesBuilder();

  @override
  HttpHeaders get headers => _headers;

  @override
  void write(Object? obj) {
    final str = obj?.toString() ?? '';
    _bodyBuilder.add(utf8.encode(str));
  }

  @override
  void add(List<int> data) {
    _bodyBuilder.add(data);
  }

  @override
  Future<HttpClientResponse> close() async {
    final matched = _matchRoute(routes, url);
    return _FakeHttpClientResponse(
      statusCode: matched.statusCode,
      body: matched.body,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpClientResponse implements HttpClientResponse {
  _FakeHttpClientResponse({required this.statusCode, required this.body});

  @override
  final int statusCode;

  final String body;

  late final Stream<List<int>> _stream = Stream<List<int>>.fromIterable([
    utf8.encode(body),
  ]);

  @override
  int get contentLength => utf8.encode(body).length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpHeaders implements HttpHeaders {
  final Map<String, List<String>> _values = {};

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    _values[name.toLowerCase()] = [value.toString()];
  }

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    final key = name.toLowerCase();
    final list = _values.putIfAbsent(key, () => <String>[]);
    list.add(value.toString());
  }

  @override
  List<String>? operator [](String name) => _values[name.toLowerCase()];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
