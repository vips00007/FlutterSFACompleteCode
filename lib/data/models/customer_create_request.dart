class CustomerFile {
  final String fileRef;
  final String documentType;

  CustomerFile({required this.fileRef, required this.documentType});

  Map<String, dynamic> toJson() {
    return {'fileRef': fileRef, 'documentType': documentType};
  }
}

class KycDocument {
  final String documentType;
  final String documentNumber;
  final String firstName;
  final String lastName;
  final String? verificationRef;
  final String documentFileId;

  KycDocument({
    required this.documentType,
    required this.documentNumber,
    required this.firstName,
    required this.lastName,
    this.verificationRef,
    required this.documentFileId,
  });

  Map<String, dynamic> toJson() {
    return {
      'document_type': documentType,
      'document_number': documentNumber,
      'first_name': firstName,
      'last_name': lastName,
      if (verificationRef != null) 'verificationRef': verificationRef,
      'document_file_id': documentFileId,
    };
  }
}

class ShopTimings {
  final String? openTime;
  final String? closeTime;

  ShopTimings({this.openTime, this.closeTime});

  Map<String, dynamic> toJson() {
    return {
      if (openTime != null) 'openTime': openTime,
      if (closeTime != null) 'closeTime': closeTime,
    };
  }
}

class BankDetails {
  final String? accountHolder;
  final String? bankName;
  final String? accountNumber;
  final String? ifsc;
  final String? branch;
  final String? upiId;
  final String? accountType;
  final String? proofClientRef;

  BankDetails({
    this.accountHolder,
    this.bankName,
    this.accountNumber,
    this.ifsc,
    this.branch,
    this.upiId,
    this.accountType,
    this.proofClientRef,
  });

  Map<String, dynamic> toJson() {
    return {
      if (accountHolder != null) 'accountHolder': accountHolder,
      if (bankName != null) 'bankName': bankName,
      if (accountNumber != null) 'accountNumber': accountNumber,
      if (ifsc != null) 'ifsc': ifsc,
      if (branch != null) 'branch': branch,
      if (upiId != null) 'upiId': upiId,
      if (accountType != null) 'accountType': accountType,
      if (proofClientRef != null) 'proofClientRef': proofClientRef,
    };
  }
}

class CreditDetails {
  final double? creditLimit;
  final int? creditDays;
  final double? openingBalance;

  CreditDetails({this.creditLimit, this.creditDays, this.openingBalance});

  Map<String, dynamic> toJson() {
    return {
      if (creditLimit != null) 'creditLimit': creditLimit,
      if (creditDays != null) 'creditDays': creditDays,
      if (openingBalance != null) 'openingBalance': openingBalance,
    };
  }
}

class CustomerCreateRequest {
  final String? customerType;
  final String shopName;
  final String? shopImageFileRef;
  final String contactPerson;
  final String mobile;
  final String? alternateMobile;
  final String? email;
  final String? whatsappNumber;
  final String? addressLine1;
  final String? addressLine2;
  final String? landmark;
  final String? state;
  final String? city;
  final String? pincode;
  final double? latitude;
  final double? longitude;
  final String? territoryUuid;
  final String? beatUuid;
  final String? subTypeUuid;
  final String? channelUuid;
  final String? segmentUuid;
  final String? categoryUuid;
  final String? classUuid;
  final String? businessTypeCode;
  final String? registrationNumber;
  final int? establishedYear;
  final String? dateOfBirth;
  final String? anniversaryDate;
  final int? shopSizeSqFt;
  final int? monthlyPotential;
  final List<String>? brandsStocked;
  final ShopTimings? shopTimings;
  final String? workshopType;
  final int? experienceYears;
  final String? engineSpecialty;
  final int? mechanicCount;
  final String? gstRegistrationType;
  final String? gstNumber;
  final String? gstCategory;
  final String? pan;
  final BankDetails? bank;
  final List<KycDocument>? kyc;
  final List<CustomerFile>? attachments;
  final String? source;
  final CreditDetails? credit;
  final String? version;
  final String? clientRequestId;

  CustomerCreateRequest({
    this.customerType,
    required this.shopName,
    this.shopImageFileRef,
    required this.contactPerson,
    required this.mobile,
    this.alternateMobile,
    this.email,
    this.whatsappNumber,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.state,
    this.city,
    this.pincode,
    this.latitude,
    this.longitude,
    this.territoryUuid,
    this.beatUuid,
    this.subTypeUuid,
    this.channelUuid,
    this.segmentUuid,
    this.categoryUuid,
    this.classUuid,
    this.businessTypeCode,
    this.registrationNumber,
    this.establishedYear,
    this.dateOfBirth,
    this.anniversaryDate,
    this.shopSizeSqFt,
    this.monthlyPotential,
    this.brandsStocked,
    this.shopTimings,
    this.workshopType,
    this.experienceYears,
    this.engineSpecialty,
    this.mechanicCount,
    this.gstRegistrationType,
    this.gstNumber,
    this.gstCategory,
    this.pan,
    this.bank,
    this.kyc,
    this.attachments,
    this.source,
    this.credit,
    this.version,
    this.clientRequestId,
  });

  Map<String, dynamic> toJson() {
    return {
      if (customerType != null) 'customerType': customerType,
      'shopName': shopName,
      if (shopImageFileRef != null) 'shopImageFileRef': shopImageFileRef,
      'contactPerson': contactPerson,
      'mobile': mobile,
      if (alternateMobile != null) 'alternateMobile': alternateMobile,
      if (email != null) 'email': email,
      if (whatsappNumber != null) 'whatsappNumber': whatsappNumber,
      if (addressLine1 != null) 'addressLine1': addressLine1,
      if (addressLine2 != null) 'addressLine2': addressLine2,
      if (landmark != null) 'landmark': landmark,
      if (state != null) 'state': state,
      if (city != null) 'city': city,
      if (pincode != null) 'pincode': pincode,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (territoryUuid != null) 'territoryUuid': territoryUuid,
      if (beatUuid != null) 'beatUuid': beatUuid,
      if (subTypeUuid != null) 'subTypeUuid': subTypeUuid,
      if (channelUuid != null) 'channelUuid': channelUuid,
      if (segmentUuid != null) 'segmentUuid': segmentUuid,
      if (categoryUuid != null) 'categoryUuid': categoryUuid,
      if (classUuid != null) 'classUuid': classUuid,
      if (businessTypeCode != null) 'businessTypeCode': businessTypeCode,
      if (registrationNumber != null) 'registrationNumber': registrationNumber,
      if (establishedYear != null) 'establishedYear': establishedYear,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      if (anniversaryDate != null) 'anniversaryDate': anniversaryDate,
      if (shopSizeSqFt != null) 'shopSizeSqFt': shopSizeSqFt,
      if (monthlyPotential != null) 'monthlyPotential': monthlyPotential,
      if (brandsStocked != null) 'brandsStocked': brandsStocked,
      if (shopTimings != null) 'shopTimings': shopTimings?.toJson(),
      if (workshopType != null) 'workshopType': workshopType,
      if (experienceYears != null) 'experienceYears': experienceYears,
      if (engineSpecialty != null) 'engineSpecialty': engineSpecialty,
      if (mechanicCount != null) 'mechanicCount': mechanicCount,
      if (gstRegistrationType != null) 'gstRegistrationType': gstRegistrationType,
      if (gstNumber != null) 'gstNumber': gstNumber,
      if (gstCategory != null) 'gstCategory': gstCategory,
      if (pan != null) 'pan': pan,
      if (bank != null) 'bank': bank?.toJson(),
      if (kyc != null) 'kyc': kyc?.map((k) => k.toJson()).toList(),
      if (attachments != null) 'attachments': attachments?.map((f) => f.toJson()).toList(),
      if (source != null) 'source': source,
      if (credit != null) 'credit': credit?.toJson(),
      if (version != null) 'version': version,
      if (clientRequestId != null) 'clientRequestId': clientRequestId,
    };
  }
}