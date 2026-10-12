import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/colors/app_colors.dart';
import '../../data/models/product_catalog_response.dart';
import 'product_catalogue_viewmodel.dart';

class ProductCatalogueScreen extends StatelessWidget {
  const ProductCatalogueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<ProductCatalogueViewModel>();
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Product Catalog',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.sfaBlue, height: 2.0),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                onChanged: viewModel.updateSearch,
                decoration: InputDecoration(
                  hintText: 'Search by name or code...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          // Product List
          Expanded(
            child: Obx(() {
              if (viewModel.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          viewModel.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => viewModel.fetchProducts(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.sfaBlue,
                        ),
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final products = viewModel.filteredProducts;

              if (products.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.grey,
                        size: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No Products Found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: viewModel.refreshProducts,
                child: ListView.builder(
                  controller: viewModel.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 20,
                  ),
                  itemCount:
                      products.length +
                      (viewModel.isFetchingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == products.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final product = products[index];
                    return _buildProductCard(product, currencyFormatter);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    ProductItemModel product,
    NumberFormat currencyFormatter,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Box
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.sfaLightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.sfaBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Title and Code
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.code,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (product.brandName.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.sfaLightBlue.withValues(
                                  alpha: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                product.brandName,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.sfaBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Detail Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildDetailItem(
                  'Size',
                  (product.size != null && product.size!.isNotEmpty)
                      ? product.size!
                      : '-',
                ),
                _buildVerticalDivider(),
                _buildDetailItem(
                  'Rate',
                  currencyFormatter.format(product.rate),
                ),
                _buildVerticalDivider(),
                _buildDetailItem(
                  'MRP',
                  currencyFormatter.format(product.mrp),
                  isSecondary: true,
                ),
                _buildVerticalDivider(),
                _buildDetailItem(
                  'Category',
                  product.categoryName.isNotEmpty ? product.categoryName : '-',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value, {
    bool isSecondary = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSecondary ? 13 : 14,
                fontWeight: isSecondary ? FontWeight.normal : FontWeight.bold,
                color: isSecondary
                    ? Colors.grey.shade600
                    : AppColors.textPrimary,
                decoration: isSecondary ? TextDecoration.lineThrough : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 24, width: 1, color: Colors.grey.shade300);
  }
}
