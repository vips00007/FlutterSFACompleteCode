import '../../domain/entities/outlet.dart';
import '../../domain/entities/paginated_outlets.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../datasource/remote/visit_plans_api_service.dart';

class TicketRepositoryImpl implements TicketRepository {
  final VisitPlansApiService apiService;

  TicketRepositoryImpl(this.apiService);

  @override
  Future<List<Outlet>> getPlannedTickets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  @override
  Future<PaginatedOutlets> getUnplannedTickets({
    required String date,
    int page = 0,
    int size = 20,
    String planType = 'LOCAL',
    String? searchQuery,
  }) async {
    final response = await apiService.getVisitPlanCustomers(
      planType: planType,
      type: 'ALL',
      date: date,
      page: page,
      size: size,
      search: searchQuery,
    );

    if (response.data == null) {
      return PaginatedOutlets(
        outlets: [],
        page: 0,
        size: size,
        totalElements: 0,
        totalPages: 0,
      );
    }

    final customers = response.data!.content;

    final outlets = customers.map((c) {
      return Outlet(
        id: c.uuid,
        customerType: 'Retailer',
        firstName: c.shopName ?? 'Unknown',
        lastName: '',
        firmName: c.shopName ?? 'Unknown',
        mobileNumber: c.customerCode ?? '',
        email: '',
        address: '',
        state: '',
        district: '',
        city: c.city ?? '',
        pinCode: '',
        photos: [],
        area: c.area,
      );
    }).toList();

    return PaginatedOutlets(
      outlets: outlets,
      page: response.data!.page,
      size: response.data!.size,
      totalElements: response.data!.totalElements,
      totalPages: response.data!.totalPages,
    );
  }
}
