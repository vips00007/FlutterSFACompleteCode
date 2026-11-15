import 'outlet.dart';

class PaginatedOutlets {
  final List<Outlet> outlets;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;

  PaginatedOutlets({
    required this.outlets,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });
}
