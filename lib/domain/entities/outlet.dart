class Outlet {
  final String? id;
  final String customerType;
  final String firstName;
  final String lastName;
  final String firmName;
  final String mobileNumber;
  final String email;
  final String address;
  final String state;
  final String district;
  final String city;
  final String pinCode;
  final List<String> photos;

  Outlet({
    this.id,
    required this.customerType,
    required this.firstName,
    required this.lastName,
    required this.firmName,
    required this.mobileNumber,
    required this.email,
    required this.address,
    required this.state,
    required this.district,
    required this.city,
    required this.pinCode,
    required this.photos,
  });
}
