import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class PaginationService {
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _hasNextPage = false;
  bool _hasPrevPage = false;
  List<String> _items = [];

  final Function(bool isLoading, List<String> items, int currentPage,
      int totalPages, bool hasNextPage, bool hasPrevPage) onChange;

  PaginationService({required this.onChange});

  void updatePaginationInfo(int currentPage, int totalPages) {
    _currentPage = currentPage;
    _totalPages = totalPages;

    if (_currentPage < _totalPages) {
      _hasNextPage = true;
    } else {
      _hasNextPage = false;
    }

    if (_currentPage > 1) {
      _hasPrevPage = true;
    } else {
      _hasPrevPage = false;
    }
  }

  Future<List<String>> fetchPage(
      String url, String Function(dynamic) mapper) async {
    try {
      onChange(true, [], _currentPage, _totalPages, _hasNextPage, _hasPrevPage);

      final response = await http.get(Uri.parse('$url?page=$_currentPage'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        print('responseData $responseData');
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data')) {
          print('Status code: ${response.statusCode}');
          final data = responseData['data'] as Map<String, dynamic>;
          final currentPage = data['current_page'] as int;
          final totalPages = data['last_page'] as int;
          final hasNextPage = data['next_page_url'] != null;
          final hasPrevPage = data['prev_page_url'] != null;

          final itemsData = data['data'] as List<dynamic>;
          final items = itemsData.map((item) => item.toString()).toList();
          onChange(
              false, items, currentPage, totalPages, hasNextPage, hasPrevPage);

          _items = items;

          _currentPage = currentPage;
          _totalPages = totalPages;
          _hasNextPage = hasNextPage;
          _hasPrevPage = hasPrevPage;
          return items;
        } else {
          throw Exception('Invalid response data type');
        }
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      onChange(
          false, [], _currentPage, _totalPages, _hasNextPage, _hasPrevPage);
      print('Error fetching items: $e');
      return [];
    }
  }

  void goToPreviousPage(String url, String Function(dynamic) mapper) {
    if (_currentPage > 1) {
      _currentPage--;
      print('Current page: $_currentPage'); // print the current page number
      fetchPage(url, mapper); // Pass in the url and mapper arguments
    }
  }

  void goToNextPage(String url, String Function(dynamic) mapper) {
    if (_currentPage < _totalPages) {
      _currentPage++;
      print('Current page: $_currentPage'); // print the current page number
      fetchPage(url, mapper); // Pass in the url and mapper arguments
    }
  }

  List<String> get items => _items;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get isLoading => _isLoading;
  bool get hasNextPage => _hasNextPage;
  bool get hasPrevPage => _currentPage > 1;
}
