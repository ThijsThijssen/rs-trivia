extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }

  String toSnakeCase() {
    String result = '${this.replaceAll(RegExp(' '), '_')}';
    return '${result[0].toLowerCase()}${result.substring(1)}';
  }
}
