import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news_viewmodel.dart';
import 'bookmarks_screen.dart';
import 'news_detail_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedButton = 'All News'; // Track the active button
  @override
  Widget build(BuildContext context) {
    final newsViewModel =
        Provider.of<NewsViewModel>(context); // Access the ViewModel

    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.bookmark),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookmarksScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()),
                  );
                },
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(200.0),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (query) {
                    newsViewModel.filterArticles(
                        query); // Call filter logic from ViewModel
                  },
                  decoration: InputDecoration(
                    hintText: 'Search news...',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Buttons for All News and Trending News
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // All News Button
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedButton = 'All News';
                        });
                        // Call the fetchArticles logic for All News
                        final newsViewModel =
                            Provider.of<NewsViewModel>(context, listen: false);
                        newsViewModel.fetchArticles(); // Fetch all news
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: _selectedButton == 'All News'
                            ? Colors.white
                            : Colors.black,
                        backgroundColor: _selectedButton == 'All News'
                            ? Colors.blue
                            : Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        elevation: 5,
                      ),
                      child: const Text(
                        'All News',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Trending News Button
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedButton = 'Trending News';
                        });
                        // Call the fetchTrendingArticles logic for Trending News
                        final newsViewModel =
                            Provider.of<NewsViewModel>(context, listen: false);
                        newsViewModel
                            .fetchTrendingArticles(); // Fetch trending news
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: _selectedButton == 'Trending News'
                            ? Colors.white
                            : Colors.black,
                        backgroundColor: _selectedButton == 'Trending News'
                            ? Colors.blue
                            : Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Trending News',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              // Categories List
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: newsViewModel.categories.length,
                  itemBuilder: (context, index) {
                    final category = newsViewModel.categories[index];
                    return GestureDetector(
                      onTap: () {
                        newsViewModel
                            .updateCategory(category); // Update category
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: newsViewModel.selectedCategory == category
                              ? Colors.blue
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            category.toUpperCase(),
                            style: TextStyle(
                              color: newsViewModel.selectedCategory == category
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: newsViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : newsViewModel.filteredArticles.isEmpty
              ? const Center(child: Text('No articles found.'))
              : Column(
                  children: [
                    // Sorting Dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 12.0),
                      child: DropdownButton<String>(
                        value: newsViewModel.sortOption,
                        items: const [
                          DropdownMenuItem(
                            value: 'Newest First',
                            child: Text('Newest First'),
                          ),
                          DropdownMenuItem(
                            value: 'Oldest First',
                            child: Text('Oldest First'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            newsViewModel.sortArticles(value); // Sort articles
                          }
                        },
                        isExpanded: true,
                        icon: const Icon(Icons.sort),
                        underline: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // Articles List
                    Expanded(
                      child: ListView.builder(
                        itemCount: newsViewModel.filteredArticles.length,
                        itemBuilder: (context, index) {
                          final article = newsViewModel.filteredArticles[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewsDetailScreen(article: article),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // News Image
                                        if (article['urlToImage'] != null &&
                                            article['urlToImage'] != '')
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              article['urlToImage'],
                                              height: 200,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        const SizedBox(height: 10),
                                        // News Title
                                        Text(
                                          article['title'] ?? 'No Title',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        // News Description
                                        Text(
                                          article['description'] ??
                                              'No Description',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Published Date
                                        Text(
                                          'Published At: ${article['publishedAt'] ?? 'Unknown'}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Bookmark Icon Positioned on Top Right
                                  Positioned(
                                      top: 10,
                                      right: 10,
                                      child: IconButton(
                                        icon: const Icon(Icons.bookmark_border),
                                        onPressed: () {
                                          newsViewModel.addBookmark(article);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Article bookmarked')),
                                          );
                                        },
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
