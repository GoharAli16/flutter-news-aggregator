import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SourcesPage extends ConsumerStatefulWidget {
  const SourcesPage({super.key});

  @override
  ConsumerState<SourcesPage> createState() => _SourcesPageState();
}

class _SourcesPageState extends ConsumerState<SourcesPage> {
  final List<Map<String, dynamic>> _newsSources = [
    {
      'id': '1',
      'name': 'BBC News',
      'description': 'British Broadcasting Corporation',
      'category': 'General',
      'country': 'UK',
      'language': 'English',
      'isEnabled': true,
      'credibilityScore': 9.5,
      'logo': 'https://example.com/bbc-logo.png',
      'website': 'https://www.bbc.com',
    },
    {
      'id': '2',
      'name': 'CNN',
      'description': 'Cable News Network',
      'category': 'General',
      'country': 'USA',
      'language': 'English',
      'isEnabled': true,
      'credibilityScore': 8.8,
      'logo': 'https://example.com/cnn-logo.png',
      'website': 'https://www.cnn.com',
    },
    {
      'id': '3',
      'name': 'Reuters',
      'description': 'International news agency',
      'category': 'General',
      'country': 'UK',
      'language': 'English',
      'isEnabled': true,
      'credibilityScore': 9.2,
      'logo': 'https://example.com/reuters-logo.png',
      'website': 'https://www.reuters.com',
    },
    {
      'id': '4',
      'name': 'TechCrunch',
      'description': 'Technology news and startup coverage',
      'category': 'Technology',
      'country': 'USA',
      'language': 'English',
      'isEnabled': false,
      'credibilityScore': 8.5,
      'logo': 'https://example.com/techcrunch-logo.png',
      'website': 'https://www.techcrunch.com',
    },
    {
      'id': '5',
      'name': 'The Guardian',
      'description': 'British daily newspaper',
      'category': 'General',
      'country': 'UK',
      'language': 'English',
      'isEnabled': true,
      'credibilityScore': 9.0,
      'logo': 'https://example.com/guardian-logo.png',
      'website': 'https://www.theguardian.com',
    },
  ];

  String _selectedCategory = 'All';
  String _selectedCountry = 'All';
  String _searchQuery = '';

  final List<String> _categories = ['All', 'General', 'Technology', 'Business', 'Science', 'Sports', 'Politics'];
  final List<String> _countries = ['All', 'USA', 'UK', 'Canada', 'Australia', 'Germany', 'France'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Sources'),
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
      ),
      body: Column(
        children: [
          // Search Bar
          if (_searchQuery.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search sources...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          
          // Sources List
          Expanded(
            child: _buildSourcesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSourcesList() {
    final filteredSources = _getFilteredSources();
    
    if (filteredSources.isEmpty) {
      return _buildEmptyState();
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredSources.length,
      itemBuilder: (context, index) {
        final source = filteredSources[index];
        return _buildSourceItem(source);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.source_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No sources found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceItem(Map<String, dynamic> source) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Logo
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.newspaper, size: 24),
            ),
            const SizedBox(width: 16),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        source['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getCredibilityColor(source['credibilityScore']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${source['credibilityScore']}/10',
                          style: TextStyle(
                            color: _getCredibilityColor(source['credibilityScore']),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    source['description'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          source['category'],
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          source['country'],
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Toggle Switch
            Switch(
              value: source['isEnabled'],
              onChanged: (value) => _toggleSource(source),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCredibilityColor(double score) {
    if (score >= 9.0) return Colors.green;
    if (score >= 7.0) return Colors.orange;
    return Colors.red;
  }

  List<Map<String, dynamic>> _getFilteredSources() {
    return _newsSources.where((source) {
      // Category filter
      if (_selectedCategory != 'All' && source['category'] != _selectedCategory) {
        return false;
      }
      
      // Country filter
      if (_selectedCountry != 'All' && source['country'] != _selectedCountry) {
        return false;
      }
      
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return source['name'].toLowerCase().contains(query) ||
               source['description'].toLowerCase().contains(query);
      }
      
      return true;
    }).toList();
  }

  void _openSearch() {
    setState(() {
      _searchQuery = _searchQuery.isEmpty ? ' ' : '';
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
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
              'Filter Sources',
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
              title: const Text('Country'),
              trailing: DropdownButton<String>(
                value: _selectedCountry,
                items: _countries.map((country) {
                  return DropdownMenuItem(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value!;
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

  void _toggleSource(Map<String, dynamic> source) {
    setState(() {
      source['isEnabled'] = !source['isEnabled'];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          source['isEnabled'] 
              ? '${source['name']} enabled' 
              : '${source['name']} disabled'
        ),
      ),
    );
  }
}
