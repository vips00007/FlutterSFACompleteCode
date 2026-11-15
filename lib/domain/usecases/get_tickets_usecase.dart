import '../entities/outlet.dart';
import '../entities/paginated_outlets.dart';
import '../repositories/ticket_repository.dart';

enum TicketType { planned, unplanned }

class GetTicketsUseCase {
  final TicketRepository repository;

  GetTicketsUseCase(this.repository);

  Future<List<Outlet>> executePlanned() {
    return repository.getPlannedTickets();
  }

  Future<PaginatedOutlets> executeUnplanned({
    required String date,
    int page = 0,
    int size = 20,
    String? searchQuery,
  }) {
    return repository.getUnplannedTickets(
      date: date,
      page: page,
      size: size,
      searchQuery: searchQuery,
    );
  }
}
