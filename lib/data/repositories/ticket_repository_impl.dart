import 'package:intl/intl.dart';
import '../../domain/entities/outlet.dart';
import '../../domain/entities/paginated_outlets.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../datasource/remote/visit_plans_api_service.dart';

class TicketRepositoryImpl implements TicketRepository {
  final VisitPlansApiService apiService;

  TicketRepositoryImpl(this.apiService);

  @override
  Future<List<Outlet>> getPlannedTickets() async {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final response = await apiService.getCustomers(
        planType: 'LOCAL',
        planned: true,
        date: dateStr,
        page: 0,
        size: 50,
      );

      if (response.data == null) return [];

      return response.data!.content.map((c) {
        final name = c.shopName?.isNotEmpty == true ? c.shopName! : 'Not Available';
        return Outlet(
          id: c.uuid,
          customerType: c.customerType ?? 'Retailer',
          firstName: name,
          lastName: '',
          firmName: name,
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
    } catch (_) {
      return [];
    }
  }

  @override
  Future<PaginatedOutlets> getUnplannedTickets({
    required String date,
    int page = 0,
    int size = 20,
    String planType = 'LOCAL',
    String? searchQuery,
  }) async {
    final response = await apiService.getCustomers(
      planType: planType,
      planned: false,
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
      final name = c.shopName?.isNotEmpty == true ? c.shopName! : 'Not Available';
      return Outlet(
        id: c.uuid,
        customerType: c.customerType ?? 'Retailer',
        firstName: name,
        lastName: '',
        firmName: name,
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
