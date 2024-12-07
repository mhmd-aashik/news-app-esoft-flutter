import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news_viewmodel.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newsViewModel = Provider.of<NewsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              if (newsViewModel.bookmarks.isNotEmpty) {
                newsViewModel.clearBookmarks();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All bookmarks cleared')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No bookmarks to clear')),
                );
              }
            },
          ),
        ],
      ),
      body: newsViewModel.bookmarks.isEmpty
          ? const Center(child: Text('No bookmarks found.'))
          : ListView.builder(
              itemCount: newsViewModel.bookmarks.length,
              itemBuilder: (context, index) {
                final article = newsViewModel.bookmarks[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: article['urlToImage'] != null
                        ? Image.network(article['urlToImage'],
                            width: 80, fit: BoxFit.cover)
                        : Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.image,
                              color: Colors.grey[600],
                            ),
                          ),
                    title: Text(
                      article['title'] ?? 'No Title',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      article['description'] ?? 'No Description',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        newsViewModel.removeBookmark(article);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Bookmark removed')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
