class ProductCatalogResponse {
  final bool success;
  final String code;
  final String message;
  final String correlationId;
  final ProductData? data;

  ProductCatalogResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.correlationId,
    this.data,
  });

  factory ProductCatalogResponse.fromJson(Map<String, dynamic> json) {
    return ProductCatalogResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      correlationId: json['correlationId'] ?? '',
      data: json['data'] != null ? ProductData.fromJson(json['data']) : null,
    );
  }
}

class ProductData {
  final List<ProductItemModel> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;

  ProductData({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    var list = json['content'] as List? ?? [];
    List<ProductItemModel> contentList = list
        .map((i) => ProductItemModel.fromJson(i))
        .toList();
    return ProductData(
      content: contentList,
      page: json['page'] ?? 0,
      size: json['size'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}

class ProductItemModel {
  final String productUuid;
  final String code;
  final String name;
  final String? size;
  final double rate;
  final double mrp;
  final bool sfaCatalogReady;
  final String categoryUuid;
  final String categoryName;
  final String brandUuid;
  final String brandName;

  ProductItemModel({
    required this.productUuid,
    required this.code,
    required this.name,
    this.size,
    required this.rate,
    required this.mrp,
    required this.sfaCatalogReady,
    required this.categoryUuid,
    required this.categoryName,
    required this.brandUuid,
    required this.brandName,
  });

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(
      productUuid: json['productUuid'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      size: json['size']?.toString(),
      rate: (json['rate'] ?? 0).toDouble(),
      mrp: (json['mrp'] ?? 0).toDouble(),
      sfaCatalogReady: json['sfaCatalogReady'] ?? false,
      categoryUuid: json['categoryUuid'] ?? '',
      categoryName: json['categoryName'] ?? '',
      brandUuid: json['brandUuid'] ?? '',
      brandName: json['brandName'] ?? '',
    );
  }
}
