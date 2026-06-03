import 'package:track_dev/core/models/paginated_result.dart';

extension PaginatedResultMapper<T> on PaginatedResult<T> {
  PaginatedResult<R> toDomain<R>(R Function(T) itemMapper) {
    return PaginatedResult<R>(
      items: items.map(itemMapper).toList(),
      totalCount: totalCount,
      offset: offset,
      limit: limit,
    );
  }
}
