import 'package:Artleap.ai/domain/api_models/image_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class MyCreationsWidget extends StatefulWidget {
  final String? userName;
  final List<Images> listofCreations;
  final String? userId;

  const MyCreationsWidget({
    super.key,
    this.userName,
    required this.listofCreations,
    required this.userId,
  });

  @override
  State<MyCreationsWidget> createState() => _MyCreationsWidgetState();
}

class _MyCreationsWidgetState extends State<MyCreationsWidget> {
  late List<Images> filteredCreations;

  @override
  void initState() {
    super.initState();
    _updateFilteredCreations();
  }

  @override
  void didUpdateWidget(MyCreationsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId ||
        oldWidget.listofCreations != widget.listofCreations) {
      _updateFilteredCreations();
    }
  }

  void _updateFilteredCreations() {
    final filteredList = widget.userId == UserData.ins.userId!
        ? widget.listofCreations
        : widget.listofCreations.where((image) => image.privacy == 'public').toList();

    if (mounted) {
      setState(() {
        filteredCreations = filteredList.reversed.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                    width: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title Section
                    Text(
                      "Gallery",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),

                    // View Details Button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: theme.colorScheme.primary.withOpacity(0.1),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'my-posts');
                          },
                          borderRadius: BorderRadius.circular(8.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "My Posts",
                                  style: AppTextstyle.interMedium(
                                    fontSize: 14.0,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 12.0,
                                  color: theme.colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildCreationsGrid(theme),
        ],
      ),
    );
  }

  Widget _buildCreationsGrid(ThemeData theme) {
    if (filteredCreations.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_library_outlined,
                size: 48,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
              12.spaceY,
              Text(
                'No creations yet',
                style: AppTextstyle.interMedium(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              4.spaceY,
              Text(
                'Start creating amazing AI art!',
                style: AppTextstyle.interRegular(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: filteredCreations.length,
      itemBuilder: (context, index) {
        final e = filteredCreations[index];

        return GestureDetector(
          onTap: () {
            Navigation.pushNamed(
              SeePictureScreen.routeName,
              arguments: SeePictureParams(
                imageId: e.id,
                image: e.imageUrl,
                prompt: e.prompt,
                modelName: e.modelName,
                profileName: e.username,
                userId: widget.userId,
                index: index,
                creatorEmail: e.creatorEmail,
                privacy: e.privacy,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: e.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        );
      },
    );
  }
}