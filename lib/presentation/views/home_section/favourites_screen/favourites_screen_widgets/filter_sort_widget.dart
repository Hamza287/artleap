import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class FilterSortWidget extends ConsumerStatefulWidget {
  const FilterSortWidget({super.key});

  @override
  ConsumerState<FilterSortWidget> createState() => _FilterSortWidgetState();
}

class _FilterSortWidgetState extends ConsumerState<FilterSortWidget> {
  String _selectedSort = 'newest';
  String _selectedFilter = 'all';

  final List<String> sortOptions = ['newest', 'oldest', 'most_liked'];
  final List<String> filterOptions = ['all', 'public', 'private', 'unlisted'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSort,
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down_rounded,
                    color: theme.colorScheme.onSurface,
                  ),
                  style: AppTextstyle.interMedium(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSort = newValue!;
                    });
                    // TODO: Implement sort
                  },
                  items: sortOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        _getSortLabel(value),
                        style: AppTextstyle.interMedium(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedFilter,
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down_rounded,
                    color: theme.colorScheme.onSurface,
                  ),
                  style: AppTextstyle.interMedium(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilter = newValue!;
                    });
                    // TODO: Implement filter
                  },
                  items: filterOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        _getFilterLabel(value),
                        style: AppTextstyle.interMedium(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSortLabel(String value) {
    switch (value) {
      case 'newest':
        return 'Newest First';
      case 'oldest':
        return 'Oldest First';
      case 'most_liked':
        return 'Most Liked';
      default:
        return value;
    }
  }

  String _getFilterLabel(String value) {
    switch (value) {
      case 'all':
        return 'All Items';
      case 'public':
        return 'Public Only';
      case 'private':
        return 'Private Only';
      case 'unlisted':
        return 'Unlisted Only';
      default:
        return value;
    }
  }
}