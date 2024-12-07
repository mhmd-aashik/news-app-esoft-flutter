import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final String _apiKey =
      '5629fefe1b694e07b1599b9ce5b2cd92'; // Your provided API key
  final String _baseUrl = 'https://newsapi.org/v2';

  /// Fetch top headlines based on category
  Future<List<dynamic>> fetchTopHeadlines({String category = ''}) async {
    String categoryQuery = category.isNotEmpty ? '&category=$category' : '';
    final url = Uri.parse(
        '$_baseUrl/top-headlines?country=us$categoryQuery&apiKey=$_apiKey');

    print('Fetching top headlines from: $url'); // Debugging: Log the full URL

    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        if (data['status'] == 'error') {
          throw Exception('API Error: ${data['message']}');
        }
        return data['articles'] ?? [];
      } catch (e) {
        throw Exception('Failed to parse top headlines: $e');
      }
    } else {
      throw Exception('Failed to load top headlines: ${response.body}');
    }
  }

  /// Fetch trending news
  Future<List<dynamic>> fetchTrendingNews() async {
    final url = Uri.parse(
        '$_baseUrl/everything?q=trending&sortBy=popularity&apiKey=$_apiKey');

    print('Fetching trending news from: $url'); // Debugging: Log the full URL

    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        if (data['status'] == 'error') {
          throw Exception('API Error: ${data['message']}');
        }
        return data['articles'] ?? [];
      } catch (e) {
        throw Exception('Failed to parse trending news: $e');
      }
    } else {
      throw Exception('Failed to load trending news: ${response.body}');
    }
  }
}
