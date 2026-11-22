import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/outlet.dart';
import '../../domain/usecases/get_tickets_usecase.dart';

enum TicketsState { loading, success, error }

class TicketsViewModel extends GetxController {
  final GetTicketsUseCase getTicketsUseCase;

  TicketsViewModel(this.getTicketsUseCase);

  final selectedTabIndex = 1.obs; // 0 for Planned, 1 for Unplanned
  final plannedTickets = <Outlet>[].obs;
  
  // Filter Chips State: 'All', 'FR', 'A-Z', 'L3M', 'MTD', 'Beat'
  final selectedChip = 'All'.obs;
  final filterChips = ['All', 'FR', 'A-Z', 'L3M', 'MTD', 'Beat'];
  
  // Accumulated all unplanned tickets from all pages
  final _allUnplannedTickets = <Outlet>[];
  // Filtered tickets to show on UI
  final unplannedTickets = <Outlet>[].obs;
  
  final state = TicketsState.loading.obs;
  bool _hasFetched = false;

  // Pagination for unplanned tickets
  int _currentPage = 0;
  final int _pageSize = 20;
  bool _hasMore = true;
  final isLoadingMore = false.obs;

  // Search
  final searchQuery = ''.obs;
  final searchController = TextEditingController();

  // Scroll Controller
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    debounce(searchQuery, (_) => _onSearchChanged(),
        time: const Duration(milliseconds: 300));
        
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        if (selectedTabIndex.value == 1) {
          loadMoreUnplannedTickets();
        }
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void fetchTicketsIfNotFetched() {
    if (!_hasFetched) {
      fetchTickets();
    }
  }

  Future<void> fetchTickets() async {
    _hasFetched = true;
    state.value = TicketsState.loading;
    try {
      _currentPage = 0;
      _hasMore = true;
      _allUnplannedTickets.clear();
      final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final planned = await getTicketsUseCase.executePlanned();
      final unplanned = await getTicketsUseCase.executeUnplanned(
        date: dateStr,
        page: _currentPage,
        size: _pageSize,
      );

      plannedTickets.assignAll(planned);
      _allUnplannedTickets.addAll(unplanned.outlets);
      
      if (unplanned.outlets.length < _pageSize || _currentPage >= unplanned.totalPages - 1) {
        _hasMore = false;
      }
      
      _applyFilterAndSearch();
      state.value = TicketsState.success;
    } catch (e) {
      state.value = TicketsState.error;
    }
  }

  Future<void> loadMoreUnplannedTickets() async {
    if (isLoadingMore.value || !_hasMore) return;

    isLoadingMore.value = true;
    _currentPage++;
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final unplanned = await getTicketsUseCase.executeUnplanned(
        date: dateStr,
        page: _currentPage,
        size: _pageSize,
      );

      _allUnplannedTickets.addAll(unplanned.outlets);
      
      if (unplanned.outlets.length < _pageSize || _currentPage >= unplanned.totalPages - 1) {
        _hasMore = false;
      }
      
      _applyFilterAndSearch();
    } catch (e) {
      _currentPage--;
    } finally {
      isLoadingMore.value = false;
    }
  }

  void _onSearchChanged() {
    _applyFilterAndSearch();
  }

  void selectChip(String chip) {
    selectedChip.value = chip;
    _applyFilterAndSearch();
  }
  
  void _applyFilterAndSearch() {
    final query = searchQuery.value.toLowerCase().trim();
    List<Outlet> result = List.from(_allUnplannedTickets);

    // Apply search query filter
    if (query.isNotEmpty) {
      result = result.where((outlet) {
        final name = outlet.firstName.toLowerCase();
        final code = outlet.mobileNumber.toLowerCase();
        final city = outlet.city.toLowerCase();
        return name.contains(query) || code.contains(query) || city.contains(query);
      }).toList();
    }

    // Apply chip selection behavior
    switch (selectedChip.value) {
      case 'A-Z':
        result.sort((a, b) => a.firstName.compareTo(b.firstName));
        break;
      case 'FR':
      case 'L3M':
      case 'MTD':
      case 'Beat':
      case 'All':
      default:
        // Default ordering / all items
        break;
    }

    unplannedTickets.assignAll(result);
  }

  void onSearchQueryChanged(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    _applyFilterAndSearch();
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
