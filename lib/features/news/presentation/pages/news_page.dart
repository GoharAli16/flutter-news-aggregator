import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsPage extends ConsumerStatefulWidget {
  const NewsPage({super.key});

  @override
  ConsumerState<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends ConsumerState<NewsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  String _sortBy = 'Latest';

  final List<Map<String, dynamic>> _newsArticles = [
    {
      'id': '1',
      'title': 'Tech Giants Report Strong Q4 Earnings',
      'summary': 'Major technology companies including Apple, Google, and Microsoft report record-breaking quarterly earnings...',
      'content': 'Major technology companies including Apple, Google, and Microsoft report record-breaking quarterly earnings, driven by strong demand for cloud services and digital products...',
      'author': 'John Smith',
      'source': 'Tech News',
      'publishedAt': '2024-01-15T10:30:00Z',
      'category': 'Technology',
      'imageUrl': 'https://example.com/tech-news.jpg',
      'url': 'https://example.com/tech-news-article',
      'isBookmarked': false,
      'isRead': false,
    },
    {
      'id': '2',
      'title': 'New Climate Change Initiative Launched',
      'summary': 'Global leaders announce ambitious new climate change initiative to reduce carbon emissions by 50% by 2030...',
      'content': 'Global leaders announce ambitious new climate change initiative to reduce carbon emissions by 50% by 2030, with significant investments in renewable energy...',
      'author': 'Sarah Johnson',
      'source': 'Environmental News',
      'publishedAt': '2024-01-15T09:15:00Z',
      'category': 'Environment',
      'imageUrl': 'https://example.com/climate-news.jpg',
      'url': 'https://example.com/climate-news-article',
      'isBookmarked': true,
      'isRead': false,
    },
    {
      'id': '3',
      'title': 'Stock Market Reaches New All-Time High',
      'summary': 'The stock market closed at a new all-time high today, with the S&P 500 gaining 2.5%...',
      'content': 'The stock market closed at a new all-time high today, with the S&P 500 gaining 2.5% and the Dow Jones Industrial Average rising 1.8%...',
      'author': 'Mike Wilson',
      'source': 'Financial Times',
      'publishedAt': '2024-01-15T08:45:00Z',
      'category': 'Business',
      'imageUrl': 'https://example.com/stock-news.jpg',
      'url': 'https://example.com/stock-news-article',
      'isBookmarked': false,
      'isRead': true,
    },
    {
      'id': '4',
      'title': 'Breakthrough in Quantum Computing',
      'summary': 'Scientists achieve major breakthrough in quantum computing, bringing us closer to practical quantum computers...',
      'content': 'Scientists achieve major breakthrough in quantum computing, bringing us closer to practical quantum computers that could revolutionize computing...',
      'author': 'Dr. Emily Chen',
      'source': 'Science Daily',
      'publishedAt': '2024-01-15T07:20:00Z',
      'category': 'Science',
      'imageUrl': 'https://example.com/quantum-news.jpg',
      'url': 'https://example.com/quantum-news-article',
      'isBookmarked': false,
      'isRead': false,
    },
  ];

  final List<String> _categories = ['All', 'Technology', 'Business', 'Science', 'Environment', 'Sports', 'Politics'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _openSearch,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'For You'),
            Tab(text: 'Trending'),
            Tab(text: 'Bookmarks'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNewsList(_getFilteredNews()),
          _buildNewsList(_getTrendingNews()),
          _buildNewsList(_getBookmarkedNews()),
        ],
      ),
    );
  }

  Widget _buildNewsList(List<Map<String, dynamic>> articles) {
    if (articles.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return _buildNewsArticle(article);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No news articles found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or check back later',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsArticle(Map<String, dynamic> article) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _openArticle(article),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(article['category']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      article['category'],
                      style: TextStyle(
                        color: _getCategoryColor(article['category']),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Bookmark
                  IconButton(
                    icon: Icon(
                      article['isBookmarked'] ? Icons.bookmark : Icons.bookmark_border,
                      color: article['isBookmarked'] ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () => _toggleBookmark(article),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Title
              Text(
                article['title'],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // Summary
              Text(
                article['summary'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              
              // Image
              if (article['imageUrl'] != null)
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(height: 12),
              
              // Footer
              Row(
                children: [
                  // Author and Source
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article['author'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          article['source'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Timestamp
                  Text(
                    _formatTimestamp(article['publishedAt']),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Technology':
        return Colors.blue;
      case 'Business':
        return Colors.green;
      case 'Science':
        return Colors.purple;
      case 'Environment':
        return Colors.teal;
      case 'Sports':
        return Colors.orange;
      case 'Politics':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatTimestamp(String timestamp) {
    final date = DateTime.parse(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  List<Map<String, dynamic>> _getFilteredNews() {
    var filtered = _newsArticles.where((article) {
      if (_selectedCategory != 'All' && article['category'] != _selectedCategory) {
        return false;
      }
      return true;
    }).toList();
    
    // Sort by selected criteria
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'Latest':
          return DateTime.parse(b['publishedAt']).compareTo(DateTime.parse(a['publishedAt']));
        case 'Popular':
          return b['views'].compareTo(a['views']);
        case 'Relevant':
          return b['relevanceScore'].compareTo(a['relevanceScore']);
        default:
          return 0;
      }
    });
    
    return filtered;
  }

  List<Map<String, dynamic>> _getTrendingNews() {
    return _newsArticles.where((article) => article['isTrending'] == true).toList();
  }

  List<Map<String, dynamic>> _getBookmarkedNews() {
    return _newsArticles.where((article) => article['isBookmarked'] == true).toList();
  }

  void _openSearch() {
    showSearch(
      context: context,
      delegate: NewsSearchDelegate(_newsArticles),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Category'),
              trailing: DropdownButton<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Sort By'),
              trailing: DropdownButton<String>(
                value: _sortBy,
                items: const [
                  DropdownMenuItem(value: 'Latest', child: Text('Latest')),
                  DropdownMenuItem(value: 'Popular', child: Text('Popular')),
                  DropdownMenuItem(value: 'Relevant', child: Text('Relevant')),
                ],
                onChanged: (value) {
                  setState(() {
                    _sortBy = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openArticle(Map<String, dynamic> article) {
    // Implement article opening
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${article['title']}...')),
    );
  }

  void _toggleBookmark(Map<String, dynamic> article) {
    setState(() {
      article['isBookmarked'] = !article['isBookmarked'];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          article['isBookmarked'] 
              ? 'Article bookmarked' 
              : 'Article removed from bookmarks'
        ),
      ),
    );
  }
}

class NewsSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> articles;

  NewsSearchDelegate(this.articles);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = articles.where((article) {
      return article['title'].toLowerCase().contains(query.toLowerCase()) ||
             article['summary'].toLowerCase().contains(query.toLowerCase()) ||
             article['content'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final article = results[index];
        return ListTile(
          title: Text(article['title']),
          subtitle: Text(article['summary']),
          onTap: () {
            close(context, article);
          },
        );
      },
    );
  }
}
