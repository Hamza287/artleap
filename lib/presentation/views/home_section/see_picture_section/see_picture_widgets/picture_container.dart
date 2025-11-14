import 'package:cached_network_image/cached_network_image.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class PictureWidget extends ConsumerWidget {
  final String? image;
  const PictureWidget({super.key, this.image});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 370,
      margin: const EdgeInsets.only(left: 12, right: 12),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InteractiveViewer(
        // Set the desired transformation properties
        boundaryMargin: EdgeInsets.all(double.infinity),
        minScale: 0.1,
        maxScale: 5.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CachedNetworkImage(
            imageUrl: image!,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
