import '../entities/outlet.dart';
import '../entities/paginated_outlets.dart';

abstract class TicketRepository {
  Future<List<Outlet>> getPlannedTickets();
  Future<PaginatedOutlets> getUnplannedTickets({
    required String date,
    int page = 0,
    int size = 20,
    String planType = 'LOCAL',
    String? searchQuery,
  });
}
