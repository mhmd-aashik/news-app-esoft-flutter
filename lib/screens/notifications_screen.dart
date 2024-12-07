import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news_viewmodel.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NewsViewModel newsViewModel;

  @override
  void initState() {
    super.initState();
    // Fetch notifications once when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      newsViewModel = Provider.of<NewsViewModel>(context, listen: false);
      newsViewModel.fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    newsViewModel = Provider.of<NewsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: newsViewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : newsViewModel.notifications.isEmpty
              ? const Center(
                  child: Text('No notifications available.'),
                )
              : ListView.builder(
                  itemCount: newsViewModel.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = newsViewModel.notifications[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading: notification['imageUrl'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  notification[
                                      'imageUrl'], // Replace with the correct image URL key
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons
                                .image_not_supported), // Fallback if no image is available
                        title: Text(
                          notification['title'] ?? 'No Title',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          notification['description'] ?? 'No Description',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          // Handle notification click
                          print(
                              'Notification clicked: ${notification['title']}');
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
