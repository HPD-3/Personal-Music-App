import 'package:flutter/material.dart';

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({super.key});

  @override
  State<ArtistsScreen> createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
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
              hintText: 'Search artists...',
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
              'Artists - Coming Soon',
              style: TextStyle(color: Color(0xFFB3B3B3)),
            ),
          ),
        ),
      ],
    );
  }
}
