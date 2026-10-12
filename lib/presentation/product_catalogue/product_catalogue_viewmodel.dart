import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/datasource/remote/product_api_service.dart';
import '../../data/models/product_catalog_response.dart';

class ProductCatalogueViewModel extends GetxController {
  final ProductApiService _apiService = ProductApiService();

  final products = <ProductItemModel>[].obs;
  final isLoading = false.obs;
  final isFetchingMore = false.obs;
  final searchQuery = ''.obs;
  final errorMessage = ''.obs;

  int _currentPage = 0;
  final int _pageSize = 20;
  bool _hasMoreData = true;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchProducts();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoading.value &&
        !isFetchingMore.value &&
        _hasMoreData) {
      fetchProducts(loadMore: true);
    }
  }

  Future<void> fetchProducts({bool loadMore = false}) async {
    if (loadMore) {
      isFetchingMore.value = true;
    } else {
      isLoading.value = true;
      _currentPage = 0;
      _hasMoreData = true;
      products.clear();
    }

    errorMessage.value = '';

    try {
      final response = await _apiService.getProducts(
        page: _currentPage,
        size: _pageSize,
      );
      if (response.data != null) {
        if (loadMore) {
          products.addAll(response.data!.content);
        } else {
          products.value = response.data!.content;
        }

        _currentPage++;
        if (_currentPage >= response.data!.totalPages ||
            response.data!.content.isEmpty) {
          _hasMoreData = false;
        }
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll("Exception: ", "");
    } finally {
      isLoading.value = false;
      isFetchingMore.value = false;
    }
  }

  Future<void> refreshProducts() async {
    await fetchProducts();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  // Local filtering if needed
  List<ProductItemModel> get filteredProducts {
    if (searchQuery.value.isEmpty) {
      return products;
    }
    final query = searchQuery.value.toLowerCase();
    return products
        .where(
          (p) =>
              p.name.toLowerCase().contains(query) ||
              p.code.toLowerCase().contains(query),
        )
        .toList();
  }
}
