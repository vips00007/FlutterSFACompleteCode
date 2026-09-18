import '../entities/outlet.dart';

abstract class TicketRepository {
  Future<List<Outlet>> getPlannedTickets();
  Future<List<Outlet>> getUnplannedTickets();
}
