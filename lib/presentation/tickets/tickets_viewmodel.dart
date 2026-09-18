import 'package:get/get.dart';
import '../../domain/entities/outlet.dart';
import '../../domain/usecases/get_tickets_usecase.dart';

enum TicketsState { loading, success, error }

class TicketsViewModel extends GetxController {
  final GetTicketsUseCase getTicketsUseCase;

  TicketsViewModel(this.getTicketsUseCase);

  final selectedTabIndex = 0.obs; // 0 for Planned, 1 for Unplanned
  final plannedTickets = <Outlet>[].obs;
  final unplannedTickets = <Outlet>[].obs;
  final state = TicketsState.loading.obs;
  bool _hasFetched = false;

  void fetchTicketsIfNotFetched() {
    if (!_hasFetched) {
      fetchTickets();
    }
  }

  Future<void> fetchTickets() async {
    _hasFetched = true;
    state.value = TicketsState.loading;
    try {
      final planned = await getTicketsUseCase.execute(TicketType.planned);
      final unplanned = await getTicketsUseCase.execute(TicketType.unplanned);

      plannedTickets.assignAll(planned);
      unplannedTickets.assignAll(unplanned);

      state.value = TicketsState.success;
    } catch (e) {
      state.value = TicketsState.error;
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
