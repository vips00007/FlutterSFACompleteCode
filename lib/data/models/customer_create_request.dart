class CustomerCreateRequest {
  final String customerType;
  final String shopName;
  final String contactPerson;
  final String mobile;
  final String? alternateMobile;
  final String? email;
  final String addressLine1;
  final String? addressLine2;
  final String? landmark;
  final String? city;
  final String? state;
  final String pincode;
  final double latitude;
  final double longitude;
  final String? gstRegistrationType;
  final String? pan;
  final String? gst;
  final String subTypeUuid;
  final String channelUuid;
  final String segmentUuid;
  final String categoryUuid;
  final String classUuid;
  final String source;
  final String territoryUuid;
  final String? beatUuid;
  final int version;
  final String clientRequestId;
  final String? shopSizeCode;
  final String? monthlyPotentialCode;
  final String? businessTypeCode;
  final String? groupUuid;
  final String? preferredLanguageCode;
  final String? kycDocTypeUuid;
  final String? regNumber;
  final String? estYear;
  final List<String>? brandsStocked;
  final String? shopTimings;
  final String? workshopType;
  final String? experience;
  final String? specialization;
  final String? mechanicsCount;
  final String? bankName;
  final String? accHolder;
  final String? accNumber;
  final String? ifsc;

  CustomerCreateRequest({
    required this.customerType,
    required this.shopName,
    required this.contactPerson,
    required this.mobile,
    this.alternateMobile,
    this.email,
    required this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.city,
    this.state,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    this.gstRegistrationType,
    this.pan,
    this.gst,
    required this.subTypeUuid,
    required this.channelUuid,
    required this.segmentUuid,
    required this.categoryUuid,
    required this.classUuid,
    required this.source,
    required this.territoryUuid,
    this.beatUuid,
    this.version = 0,
    required this.clientRequestId,
    this.shopSizeCode,
    this.monthlyPotentialCode,
    this.businessTypeCode,
    this.groupUuid,
    this.preferredLanguageCode,
    this.kycDocTypeUuid,
    this.regNumber,
    this.estYear,
    this.brandsStocked,
    this.shopTimings,
    this.workshopType,
    this.experience,
    this.specialization,
    this.mechanicsCount,
    this.bankName,
    this.accHolder,
    this.accNumber,
    this.ifsc,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'customerType': customerType,
      'shopName': shopName,
      'contactPerson': contactPerson,
      'mobile': mobile,
      'alternateMobile': alternateMobile,
      'email': email,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'gstRegistrationType': gstRegistrationType,
      'pan': pan,
      'gstin': gst,
      'subTypeUuid': subTypeUuid,
      'channelUuid': channelUuid,
      'segmentUuid': segmentUuid,
      'categoryUuid': categoryUuid,
      'classUuid': classUuid,
      'source': source,
      'territoryUuid': territoryUuid,
      'beatUuid': beatUuid,
      'version': version,
      'clientRequestId': clientRequestId,
      'shopSizeCode': shopSizeCode,
      'monthlyPotentialCode': monthlyPotentialCode,
      'businessTypeCode': businessTypeCode,
      'groupUuid': groupUuid,
      'preferredLanguageCode': preferredLanguageCode,
      'kycDocTypeUuid': kycDocTypeUuid,
      'regNumber': regNumber,
      'estYear': estYear,
      'brandsStocked': brandsStocked,
      'shopTimings': shopTimings,
      'workshopType': workshopType,
      'experience': experience,
      'specialization': specialization,
      'mechanicsCount': mechanicsCount,
      'bankName': bankName,
      'accHolder': accHolder,
      'accNumber': accNumber,
      'ifsc': ifsc,
    };
    data.removeWhere((key, value) => value == null || (value is String && value.isEmpty));
    return data;
  }
}