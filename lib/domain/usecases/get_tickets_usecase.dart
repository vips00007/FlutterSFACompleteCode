import '../entities/outlet.dart';
import '../repositories/ticket_repository.dart';

enum TicketType { planned, unplanned }

class GetTicketsUseCase {
  final TicketRepository repository;

  GetTicketsUseCase(this.repository);

  Future<List<Outlet>> execute(TicketType type) {
    if (type == TicketType.planned) {
      return repository.getPlannedTickets();
    } else {
      return repository.getUnplannedTickets();
    }
  }
}
