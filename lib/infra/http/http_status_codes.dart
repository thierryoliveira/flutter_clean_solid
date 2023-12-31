enum HttpStatusCodes {
  ok(code: 200),
  noContent(code: 204),
  badRequest(code: 400),
  unauthorized(code: 401),
  forbidden(code: 403),
  notFound(code: 404);

  /// Represents the HTTP status code related to each enum value.
  final int code;

  const HttpStatusCodes({required this.code});
}
