class PaginatedResult<T> {
  const PaginatedResult({
    required this.items,
    required this.totalCount,
    required this.offset,
    required this.limit,
  });

  final List<T> items;
  final int? totalCount;
  final int offset;
  final int limit;

  bool get isLastPage {
    final total = totalCount;
    if (total != null) {
      return offset + items.length >= total;
    }

    return items.length < limit;
  }
}

Future<List<T>> drainAllPages<T>({
  required Future<PaginatedResult<T>> Function({
    required int offset,
    required int limit,
  }) loadPage,
  required int offset,
  required int limit,
}) async {
  final items = <T>[];
  var currentOffset = offset;

  while (true) {
    final page = await loadPage(offset: currentOffset, limit: limit);
    items.addAll(page.items);

    if (page.items.isEmpty || page.isLastPage) {
      break;
    }

    currentOffset += page.items.length;
  }

  return items;
}
