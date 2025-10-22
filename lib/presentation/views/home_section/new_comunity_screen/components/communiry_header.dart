import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/home_screen_provider.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import '../widegts/art_style_dialog.dart';

class CommunityHeader extends ConsumerStatefulWidget {
  final Function(bool isSearching, String? searchQuery)? onSearchStateChanged;
  final Function(String? filter)? onFilterStateChanged;

  const CommunityHeader({super.key, this.onSearchStateChanged, this.onFilterStateChanged});

  @override
  ConsumerState<CommunityHeader> createState() => _CommunityHeaderState();
}

class _CommunityHeaderState extends ConsumerState<CommunityHeader> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;
  String? _currentFilter;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    final query = _searchController.text;
    ref.read(homeScreenProvider.notifier).setSearchQuery(query.isEmpty ? null : query);
    widget.onSearchStateChanged?.call(_isSearchExpanded, query.isEmpty ? null : query);
  }

  void _toggleSearch() {
    final newState = !_isSearchExpanded;
    setState(() {
      _isSearchExpanded = newState;
    });

    if (!newState) {
      _searchController.clear();
      ref.read(homeScreenProvider.notifier).clearSearch();
      widget.onSearchStateChanged?.call(false, null);
    } else {
      widget.onSearchStateChanged?.call(true, _searchController.text.isEmpty ? null : _searchController.text);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(homeScreenProvider.notifier).clearSearch();
    widget.onSearchStateChanged?.call(_isSearchExpanded, null);
  }

  void _handleFilterSelection(String filter) {
    final homeProvider = ref.read(homeScreenProvider.notifier);

    if (_currentFilter == filter) {
      _currentFilter = null;
      homeProvider.clearFilteredList();
      widget.onFilterStateChanged?.call(null);
    } else {
      _currentFilter = filter;
      homeProvider.filteredListFtn(filter);
      widget.onFilterStateChanged?.call(filter);
    }
  }

  void _clearFilter() {
    _currentFilter = null;
    ref.read(homeScreenProvider.notifier).clearFilteredList();
    widget.onFilterStateChanged?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeProvider = ref.watch(homeScreenProvider);
    final hasActiveFilter = homeProvider.selectedStyleTitle != null;
    final hasActiveSearch = homeProvider.isSearching;

    _currentFilter = homeProvider.selectedStyleTitle;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              if (!_isSearchExpanded) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Community',
                      style: AppTextstyle.interBold(
                        fontSize: 24,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Discover amazing AI art',
                      style: AppTextstyle.interRegular(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _isSearchExpanded ? MediaQuery.of(context).size.width - 100 : 40,
                height: 40,
                child: Row(
                  children: [
                    if (_isSearchExpanded)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search posts, users...',
                              hintStyle: AppTextstyle.interRegular(
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              suffixIcon: homeProvider.isSearching
                                  ? IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                  size: 20,
                                ),
                                onPressed: _clearSearch,
                              )
                                  : null,
                            ),
                            style: AppTextstyle.interMedium(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    if (_isSearchExpanded) const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _toggleSearch,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _isSearchExpanded || hasActiveSearch
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: (_isSearchExpanded || hasActiveSearch
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outline)
                                  .withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isSearchExpanded ? Icons.close_rounded : Icons.search_rounded,
                          color: _isSearchExpanded || hasActiveSearch
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!_isSearchExpanded) ...[
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ArtStyleDialog(
                        onStyleSelected: _handleFilterSelection,
                        currentFilter: _currentFilter,
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: hasActiveFilter
                              ? LinearGradient(
                            colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                              : LinearGradient(
                            colors: [
                              theme.colorScheme.surfaceContainerHighest,
                              theme.colorScheme.surfaceContainerHighest
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: (hasActiveFilter ? theme.colorScheme.primary : theme.colorScheme.outline)
                                  .withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FeatherIcons.filter,
                              color: hasActiveFilter
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurfaceVariant,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              hasActiveFilter ? homeProvider.selectedStyleTitle! : 'Filter',
                              style: AppTextstyle.interMedium(
                                fontSize: 13,
                                color: hasActiveFilter
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (hasActiveFilter)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: _clearFilter,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          if (homeProvider.isSearching)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Text(
                    '${homeProvider.searchResults.length} results found',
                    style: AppTextstyle.interRegular(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _clearSearch,
                    child: Text(
                      'Clear',
                      style: AppTextstyle.interMedium(
                        fontSize: 12,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}