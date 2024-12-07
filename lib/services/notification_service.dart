import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  final String _apiKey =
      '5629fefe1b694e07b1599b9ce5b2cd92'; // Your provided API key
  final String _baseUrl = 'https://newsapi.org/v2';

  /// Fetch breaking news as notifications with images
  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    final url = Uri.parse(
        '$_baseUrl/everything?q=breaking-news&apiKey=$_apiKey'); // Adjust query as needed

    print('Fetching notifications from: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Ensure the response structure is valid
        if (data['articles'] != null && data['articles'] is List) {
          return (data['articles'] as List)
              .map((article) => {
                    'title': article['title'] ?? 'No Title',
                    'description': article['description'] ?? 'No Description',
                    'imageUrl':
                        article['urlToImage'], // Include image URL
                    'publishedAt': article['publishedAt'],
                  })
              .toList();
        } else {
          throw Exception('Invalid response structure: ${response.body}');
        }
      } else {
        throw Exception(
            'Failed to load notifications: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      throw Exception('Error fetching notifications: $e');
    }
  }
}
