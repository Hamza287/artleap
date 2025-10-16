import 'package:flutter/material.dart';

class HomeScreenSearchBar extends StatelessWidget {
  const HomeScreenSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search AI Creations",
          hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurface.withOpacity(0.6)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.outline),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
        ),
      ),
    );
  }
}