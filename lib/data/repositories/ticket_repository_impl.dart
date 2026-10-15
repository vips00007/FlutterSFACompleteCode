import '../../domain/entities/outlet.dart';
import '../../domain/repositories/ticket_repository.dart';

class TicketRepositoryImpl implements TicketRepository {
  @override
  Future<List<Outlet>> getPlannedTickets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Returning empty list to show empty state as per design screenshot 1
    return [];
  }

  @override
  Future<List<Outlet>> getUnplannedTickets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Outlet(
        id: '1',
        customerType: 'Retailer',
        firstName: 'Suresh',
        lastName: 'K k',
        firmName: 'Suresh Store',
        mobileNumber: '9847973183',
        email: 'suresh@example.com',
        address: 'Ernakulam, Kerala',
        state: 'Kerala',
        district: 'Ernakulam',
        city: 'Kochi',
        pinCode: '682001',
        photos: [],
      ),
      Outlet(
        id: '2',
        customerType: 'Mechanic',
        firstName: 'Karthik.b',
        lastName: '',
        firmName: 'Karthik Garage',
        mobileNumber: '9715140460',
        email: 'karthik@example.com',
        address: 'Avinashi, Tamilnadu',
        state: 'Tamilnadu',
        district: 'Tiruppur',
        city: 'Avinashi',
        pinCode: '641654',
        photos: [],
      ),
      Outlet(
        id: '3',
        customerType: 'Distributor',
        firstName: 'Rahul',
        lastName: 'Sharma',
        firmName: 'Sharma Distributors',
        mobileNumber: '9876543210',
        email: 'rahul@example.com',
        address: 'MG Road, Bangalore',
        state: 'Karnataka',
        district: 'Bangalore Urban',
        city: 'Bangalore',
        pinCode: '560001',
        photos: [],
      ),
    ];
  }
}
