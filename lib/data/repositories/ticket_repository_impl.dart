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
    // Returning empty list to show empty state as per design screenshot 1
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
    final response = await apiService.getUnplannedCustomers(
      date: date,
      page: page,
      size: size,
      planType: planType,
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

    var customers = response.data!.content;

    // Apply local search filtering across fields (API doesn't have search)
    // Note: Actually, filtering in ViewModel over all loaded pages is better for user experience,
    // but if the API returns a massive list, doing some pre-filter could be okay.
    // Since ViewModel does filtering, we skip it here.
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      customers = customers.where((c) {
        final name = c.shopName?.toLowerCase() ?? '';
        final code = c.customerCode?.toLowerCase() ?? '';
        return name.contains(query) || code.contains(query);
      }).toList();
    }

    final outlets = customers.map((c) {
      return Outlet(
        id: c.uuid,
        customerType: 'Retailer', // Default value
        firstName: c.shopName ?? 'Unknown',
        lastName: '',
        firmName: c.shopName ?? 'Unknown',
        mobileNumber: c.customerCode ?? '',
        email: '',
        address: '',
        state: '',
        district: '',
        city: '',
        pinCode: '',
        photos: [],
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
