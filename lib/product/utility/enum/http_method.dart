/// HTTP methods enum
enum HttpMethod {
  /// [get] method
  get('GET'),

  /// [post] method
  post('POST'),

  /// [put] method
  put('PUT'),

  /// [delete] method
  delete('DELETE'),

  /// [patch] method
  patch('PATCH');

  const HttpMethod(this.value);

  /// Create an HTTP method from a string
  final String value;
}
