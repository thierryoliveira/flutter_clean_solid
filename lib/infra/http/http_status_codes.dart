enum HttpStatusCodes {
  noContent(code: 204);

  /// Represents the HTTP status code related to each enum value.
  final int code;

  const HttpStatusCodes({required this.code});
}
