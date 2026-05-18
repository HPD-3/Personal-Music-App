import 'package:flutter/material.dart';

class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({super.key});

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search albums...',
              hintStyle: const TextStyle(color: Color(0xFF79797D)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFFB3B3B3)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFF282828),
            ),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Albums - Coming Soon',
              style: TextStyle(color: Color(0xFFB3B3B3)),
            ),
          ),
        ),
      ],
    );
  }
}
