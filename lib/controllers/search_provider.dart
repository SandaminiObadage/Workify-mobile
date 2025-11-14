import 'package:flutter/material.dart';
import 'package:jobhubv2_0/models/response/jobs/jobs_response.dart';
import 'package:jobhubv2_0/services/helpers/jobs_helper.dart';

class SearchNotifier extends ChangeNotifier {
  bool _isSearching = false;
  List<JobsResponse> _searchResults = [];
  String _searchQuery = '';
  String _errorMessage = '';

  // Getters
  bool get isSearching => _isSearching;
  List<JobsResponse> get searchResults => _searchResults;
  String get searchQuery => _searchQuery;
  String get errorMessage => _errorMessage;

  // Simple search function
  Future<void> searchJobs(String query) async {
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    _isSearching = true;
    _searchQuery = query;
    _errorMessage = '';
    notifyListeners();

    try {
      _searchResults = await JobsHelper.searchJobs(query);
    } catch (e) {
      _errorMessage = 'Search failed: ${e.toString()}';
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  // Advanced search function
  Future<void> advancedSearch({
    String? searchTerm,
    String? location,
    String? contract,
    String? period,
  }) async {
    _isSearching = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _searchResults = await JobsHelper.advancedSearchJobs(
        searchTerm: searchTerm,
        location: location,
        contract: contract,
        period: period,
      );
      _searchQuery = searchTerm ?? '';
    } catch (e) {
      _errorMessage = 'Advanced search failed: ${e.toString()}';
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  // Clear search results
  void clearSearch() {
    _searchResults = [];
    _searchQuery = '';
    _errorMessage = '';
    _isSearching = false;
    notifyListeners();
  }

  // Get search suggestions based on popular searches
  List<String> getSearchSuggestions() {
    return [
      'Software Developer',
      'Frontend Developer',
      'Backend Developer',
      'Full Stack Developer',
      'Mobile Developer',
      'UI/UX Designer',
      'Data Scientist',
      'DevOps Engineer',
      'Product Manager',
      'Marketing Manager',
      'Sales Representative',
      'Customer Service',
      'Accountant',
      'HR Manager',
      'Business Analyst',
    ];
  }

  // Filter search results by contract type
  List<JobsResponse> filterByContract(String contract) {
    if (contract.isEmpty) return _searchResults;
    return _searchResults.where((job) => 
      job.contract.toLowerCase().contains(contract.toLowerCase())
    ).toList();
  }

  // Filter search results by location
  List<JobsResponse> filterByLocation(String location) {
    if (location.isEmpty) return _searchResults;
    return _searchResults.where((job) => 
      job.location.toLowerCase().contains(location.toLowerCase())
    ).toList();
  }

  // Filter search results by period
  List<JobsResponse> filterByPeriod(String period) {
    if (period.isEmpty) return _searchResults;
    return _searchResults.where((job) => 
      job.period.toLowerCase().contains(period.toLowerCase())
    ).toList();
  }
}