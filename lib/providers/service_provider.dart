import 'package:flutter/material.dart';
import '../data/mock/mock_services.dart';
import '../data/models/service_model.dart';
import '../services/api_service_interface.dart';
import '../services/mock_api_service.dart';

class ServiceProvider extends ChangeNotifier {
  final ApiService _apiService;

  ServiceProvider({ApiService? apiService})
      : _apiService = apiService ?? MockApiService() {
    loadCatalog();
  }

  List<ServiceCategory> _categories = List.from(mockCategories);
  List<ServiceItem> _services = List.from(mockServices);
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  List<ServiceCategory> get categories => _categories;
  List<ServiceItem> get services => _services;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<ServiceItem> get filteredServices {
    var list = _services;
    if (_selectedCategoryId != 'all') {
      list = list.where((s) => s.categoryId == _selectedCategoryId).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      list = list.where((s) {
        return s.title.toLowerCase().contains(q) ||
            s.titleHindi.toLowerCase().contains(q) ||
            s.description.toLowerCase().contains(q);
      }).toList();
    }
    return list;
  }

  List<ServiceItem> get popularServices =>
      _services.where((s) => s.isPopular).toList();

  List<ServiceItem> get emergencyServices =>
      _services.where((s) => s.isEmergency).toList();

  Future<void> loadCatalog() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cats = await _apiService.getCategories();
      final servs = await _apiService.getServices();
      _categories = cats;
      _services = servs;
    } catch (e) {
      _errorMessage = 'Failed to load services: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String categoryId) {
    if (_selectedCategoryId != categoryId) {
      _selectedCategoryId = categoryId;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}
