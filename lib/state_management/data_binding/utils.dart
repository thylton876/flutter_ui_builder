String getJavaScriptObjectLiteral(dynamic data, [String defaultValue = '{}']) {
  if (data == null) {
    return defaultValue;
  } else if (data is String) {
    return '"$data"'; // How to escape quotes.
  } else if (data is int || data is double) {
    return data.toString();
  } else if (data is DateTime) {
    return 'Date("${data.toIso8601String()}")';
  } else if (data is Iterable) {
    return '[${data.map(getJavaScriptObjectLiteral).join(',')}]';
  } else if (data is Map<String, dynamic>) {
    return '{${data.entries.map((e) => '${getJavaScriptObjectLiteral(e.key)}:${getJavaScriptObjectLiteral(e.value)}').join(',')}}';
  }

  throw Error();
}
