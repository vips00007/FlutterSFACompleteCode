import 'package:get/get.dart';

class ProductItem {
  final String title;
  final String code;
  final String size;
  final String rate;
  final String category;

  ProductItem({
    required this.title,
    required this.code,
    required this.size,
    required this.rate,
    required this.category,
  });
}

class ProductCatalogueViewModel extends GetxController {
  final products = <ProductItem>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockProducts();
  }

  void loadMockProducts() {
    products.value = [
      ProductItem(
        title: '(256/051/288/289/287) SPL 90 -SYTS Assem (SDYS0090K051)',
        code: 'SDYS0090K051',
        size: '—',
        rate: '₹4905',
        category: 'Dana DS',
      ),
      ProductItem(
        title: '(256/276/288/289/287) SPL90 -SY & TS Ass (SDYS0090K276)',
        code: 'SDYS0090K276',
        size: '—',
        rate: '₹1',
        category: 'Dana DS',
      ),
      ProductItem(
        title: '(256/524/288/289/287) SPL 90 SYTS Assemb (SDYS0090K524)',
        code: 'SDYS0090K524',
        size: '—',
        rate: '₹1',
        category: 'Dana DS',
      ),
      ProductItem(
        title: '(258/147/288/289/287) SPL 90 SYTS Assemb (SDYS0090K147)',
        code: 'SDYS0090K147',
        size: '—',
        rate: '₹1',
        category: 'Dana DS',
      ),
    ];
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    // Filtering logic can be added here if needed
  }
}
