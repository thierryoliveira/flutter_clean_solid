enum HttpMethods {
  get(value: 'GET'),
  post(value: 'POST'),
  put(value: 'PUT'),
  delete(value: 'DELETE');

  final String value;

  const HttpMethods({required this.value});
}
