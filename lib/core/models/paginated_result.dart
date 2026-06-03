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
}
