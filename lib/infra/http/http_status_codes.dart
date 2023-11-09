enum HttpStatusCodes {
  ok(code: 200),
  noContent(code: 204),
  badRequest(code: 400),
  unauthorized(code: 401);

  /// Represents the HTTP status code related to each enum value.
  final int code;

  const HttpStatusCodes({required this.code});
}
