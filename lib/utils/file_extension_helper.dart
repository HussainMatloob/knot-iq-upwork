String getFileExtension(Map<String, dynamic> doc) {
  final name = doc['name'];
  if (name is String && name.isNotEmpty && name.contains('.')) {
    return '${name.split('.').last}';
  }
  return '';
}
