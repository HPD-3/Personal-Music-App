extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String truncate(int length) {
    if (this.length <= length) return this;
    return '${substring(0, length)}...';
  }

  bool containsIgnoreCase(String other) {
    return toLowerCase().contains(other.toLowerCase());
  }
}
