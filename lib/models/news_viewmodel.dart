import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/news_service.dart';
import '../services/notification_service.dart';

class NewsViewModel with ChangeNotifier {
  final NewsService _newsService = NewsService();
  final NotificationService _notificationService = NotificationService();

  // State variables
  List<dynamic> _articles = [];
  List<dynamic> _filteredArticles = [];
  List<Map<String, dynamic>> _bookmarks = [];
  List<dynamic> _notifications = []; // List of notifications
  bool _isLoading = false;
  String _selectedCategory = 'general';
  String _sortOption = 'Newest First';

  // Getters for state variables
  List<dynamic> get articles => _articles;
  List<dynamic> get filteredArticles => _filteredArticles;
  List<Map<String, dynamic>> get bookmarks => _bookmarks;
  List<dynamic> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get sortOption => _sortOption;

  // Categories for news
  List<String> get categories => [
        'business',
        'entertainment',
        'general',
        'health',
        'science',
        'sports',
        'technology',
      ];

  // Fetch top headlines based on category
  Future<void> fetchArticles({String category = ''}) async {
    _setLoadingState(true);

    try {
      final articles = await _newsService.fetchTopHeadlines(category: category);
      _articles = articles;
      _filteredArticles = articles;
    } catch (e) {
      print('Error fetching articles: $e');
      _articles = [];
      _filteredArticles = [];
    } finally {
      _setLoadingState(false);
    }
  }

  // Fetch trending articles
  Future<void> fetchTrendingArticles() async {
    _setLoadingState(true);

    try {
      final trendingArticles = await _newsService.fetchTrendingNews();
      _articles = trendingArticles;
      _filteredArticles = trendingArticles;
    } catch (e) {
      print('Error fetching trending articles: $e');
      _articles = [];
      _filteredArticles = [];
    } finally {
      _setLoadingState(false);
    }
  }

  // Fetch notifications
  Future<void> fetchNotifications() async {
    _setLoadingState(true);

    try {
      final fetchedNotifications =
          await _notificationService.fetchNotifications();
      _notifications = fetchedNotifications;
    } catch (e) {
      print('Error fetching notifications: $e');
      _notifications = [];
    } finally {
      _setLoadingState(false);
    }
  }

  // Filter articles based on query
  void filterArticles(String query) {
    _filteredArticles = _articles.where((article) {
      final title = article['title']?.toLowerCase() ?? '';
      final description = article['description']?.toLowerCase() ?? '';
      return title.contains(query.toLowerCase()) ||
          description.contains(query.toLowerCase());
    }).toList();
    notifyListeners();
  }

  // Sort articles by newest or oldest
  void sortArticles(String option) {
    _sortOption = option;
    if (option == 'Newest First') {
      _filteredArticles.sort((a, b) {
        final dateA =
            DateTime.parse(a['publishedAt'] ?? DateTime.now().toString());
        final dateB =
            DateTime.parse(b['publishedAt'] ?? DateTime.now().toString());
        return dateB.compareTo(dateA); // Newest first
      });
    } else {
      _filteredArticles.sort((a, b) {
        final dateA =
            DateTime.parse(a['publishedAt'] ?? DateTime.now().toString());
        final dateB =
            DateTime.parse(b['publishedAt'] ?? DateTime.now().toString());
        return dateA.compareTo(dateB); // Oldest first
      });
    }
    notifyListeners();
  }

  // Update selected category
  void updateCategory(String category) {
    _selectedCategory = category;
    fetchArticles(category: category);
  }

  // Load bookmarks from SharedPreferences
  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedBookmarks = prefs.getStringList('bookmarks') ?? [];
    _bookmarks = savedBookmarks
        .map((bookmark) => jsonDecode(bookmark) as Map<String, dynamic>)
        .toList();
    notifyListeners();
  }

  // Add a bookmark
  Future<void> addBookmark(Map<String, dynamic> article) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedBookmarks = prefs.getStringList('bookmarks') ?? [];
    final articleJson = jsonEncode(article);

    if (!savedBookmarks.contains(articleJson)) {
      savedBookmarks.add(articleJson);
      _bookmarks.add(article);
      await prefs.setStringList('bookmarks', savedBookmarks);
      notifyListeners();
    }
  }

  // Remove a bookmark
  Future<void> removeBookmark(Map<String, dynamic> article) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedBookmarks = prefs.getStringList('bookmarks') ?? [];
    final articleJson = jsonEncode(article);

    savedBookmarks.remove(articleJson);
    _bookmarks.remove(article);
    await prefs.setStringList('bookmarks', savedBookmarks);
    notifyListeners();
  }

  // Clear all bookmarks
  Future<void> clearBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bookmarks');
    _bookmarks = [];
    notifyListeners();
  }

  // Private method to set loading state
  void _setLoadingState(bool state) {
    _isLoading = state;
    notifyListeners();
  }
}
