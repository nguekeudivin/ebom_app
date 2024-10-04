library helpers;

String truncate(String value, int length) {
  return (value.length > length) ? '${value.substring(0, length)}...' : value;
}
