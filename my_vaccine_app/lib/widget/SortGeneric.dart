void genericSort<T>(
    List<T> items, Comparable Function(T item) getField, bool ascending) {
  items.sort((a, b) {
    final valueA = getField(a);
    final valueB = getField(b);
    return ascending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
  });
}
