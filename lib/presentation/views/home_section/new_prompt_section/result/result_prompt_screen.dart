import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_screen.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/shared.dart';
import 'package:Artleap.ai/shared/utilities/safe_network_image.dart';
import '../../../global_widgets/artleap_top_bar.dart';

class ResultScreenRedesign extends ConsumerWidget {
  const ResultScreenRedesign({super.key});
  static const String routeName = "result_screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generatedImages = ref.watch(generateImageProvider).generatedImage;
    final generatedTextToImageData =
        ref.watch(generateImageProvider).generatedTextToImageData;
    final isLoading = ref.watch(generateImageProvider).isGenerateImageLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Container(
            color: AppColors.topBar,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ArtLeapTopBar(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      ref.read(generateImageProvider).clearGeneratedData();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    'Back',
                    style: AppTextstyle.interMedium(fontSize: 20),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Main Image Container with Shimmer
            if (isLoading)
              _buildShimmerContainer(300)
            else if (generatedTextToImageData.isNotEmpty &&
                generatedTextToImageData.length == 1)
              _buildSingleImageResult(
                  context, ref, generatedTextToImageData[0]!)
            else if (generatedTextToImageData.length > 1)
                _buildMultipleImagesResult(context, ref, generatedTextToImageData)
              else if (generatedImages.isNotEmpty && generatedImages.length == 1)
                  _buildSingleGeneratedImage(context, ref, generatedImages[0]!)
                else if (generatedImages.length > 1)
                    _buildMultipleGeneratedImages(context, ref, generatedImages)
                  else
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Text("No generated images")),
                    ),

            const SizedBox(height: 16),
            // Action Buttons with Shimmer
            // if (isLoading)
            //   _buildShimmerActionButtons()
            // else
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       _comingSoonIconButton(Icons.share_outlined),
            //       _comingSoonIconButton(Icons.download_outlined),
            //       _comingSoonIconButton(Icons.delete_outline, isDelete: true),
            //     ],
            //   ),

            const SizedBox(height: 16),
            // Re-generate Button with Shimmer
            if (isLoading)
              _buildShimmerContainer(56)
            else
              _comingSoonPrimaryButton(
                icon: Icons.auto_awesome,
                label: "Re Generate",
              ),

            const SizedBox(height: 20),
            // Prompt Section with Shimmer
            if (isLoading)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmerContainer(20, width: 100),
                  const SizedBox(height: 8),
                  _buildShimmerContainer(200),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Prompt",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Text(
                            ref
                                .watch(generateImageProvider)
                                .promptTextController
                                .text
                                .isNotEmpty
                                ? ref
                                .watch(generateImageProvider)
                                .promptTextController
                                .text
                                : generatedImages.isNotEmpty
                                ? generatedImages[0]!.prompt
                                : "No prompt available",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: _comingSoonTextButton(
                            icon: Icons.edit_outlined,
                            label: "Edit Prompt",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),
            // Upscale Button with Shimmer
            if (isLoading)
              _buildShimmerContainer(56)
            else
              _comingSoonPrimaryButton(
                icon: Icons.open_in_full,
                label: "Upscale",
              ),

            const SizedBox(height: 12),
            // Edit Button with Shimmer
            if (isLoading)
              _buildShimmerContainer(56)
            else
              _comingSoonPrimaryButton(
                icon: Icons.brush_outlined,
                label: "Add/ Remove Object",
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleImageResult(
      BuildContext context, WidgetRef ref, dynamic imageData) {
    return GestureDetector(
      onTap: () {
        Navigation.pushNamed(SeePictureScreen.routeName,
            arguments: SeePictureParams(
              profileName: UserData.ins.userName,
              userId: UserData.ins.userId,
              imageId: imageData.id,
              modelName: ref.watch(generateImageProvider).selectedStyle,
              prompt:
              ref.watch(generateImageProvider).promptTextController.text,
              image: imageData.imageUrl,
            ));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SafeNetworkImage(
            imageUrl: imageData.imageUrl,
            placeholder: (_, __) => _buildShimmerContainer(300),
            errorWidget: (_, __, error) =>
            const Icon(Icons.error_outline, color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildMultipleImagesResult(
      BuildContext context, WidgetRef ref, List<dynamic> images) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigation.pushNamed(SeePictureScreen.routeName,
                    arguments: SeePictureParams(
                      profileName: UserData.ins.userName,
                      userId: UserData.ins.userId,
                      imageId: images[index]!.id,
                      modelName: ref.watch(generateImageProvider).selectedStyle,
                      prompt: ref
                          .watch(generateImageProvider)
                          .promptTextController
                          .text,
                      image: images[index]!.imageUrl,
                    ));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SafeNetworkImage(
                  imageUrl: images[index]!.imageUrl,
                  placeholder: (_, __) => _buildShimmerContainer(155),
                  errorWidget: (_, __, error) =>
                  const Icon(Icons.error_outline, color: Colors.red),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSingleGeneratedImage(
      BuildContext context, WidgetRef ref, dynamic image) {
    return GestureDetector(
      onTap: () {
        Navigation.pushNamed(SeePictureScreen.routeName,
            arguments: SeePictureParams(
              profileName: UserData.ins.userName,
              imageId: image.id,
              modelName: image.presetStyle,
              prompt: image.prompt,
              image: image.imageUrl,
            ));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SafeNetworkImage(
            imageUrl: image.imageUrl,
            placeholder: (_, __) => _buildShimmerContainer(300),
            errorWidget: (_, __, error) =>
            const Icon(Icons.error_outline, color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildMultipleGeneratedImages(
      BuildContext context, WidgetRef ref, List<dynamic> images) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigation.pushNamed(SeePictureScreen.routeName,
                    arguments: SeePictureParams(
                      profileName: UserData.ins.userName,
                      imageId: images[index]!.id,
                      modelName: images[index]!.presetStyle,
                      prompt: images[index]!.prompt,
                      image: images[index]!.imageUrl,
                    ));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SafeNetworkImage(
                  imageUrl: images[index]!.imageUrl,
                  placeholder: (_, __) => _buildShimmerContainer(155),
                  errorWidget: (_, __, error) =>
                  const Icon(Icons.error_outline, color: Colors.red),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerContainer(double height, {double? width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildShimmerActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildShimmerContainer(40, width: 40),
        _buildShimmerContainer(40, width: 40),
        _buildShimmerContainer(40, width: 40),
      ],
    );
  }

  Widget _comingSoonIconButton(IconData icon, {bool isDelete = false}) {
    return Tooltip(
      message: "Coming soon",
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: IconButton(
          icon: Icon(icon,
              color: isDelete ? Colors.grey[600] : Colors.grey[600]),
          onPressed: null,
          disabledColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _comingSoonTextButton({
    required IconData icon,
    required String label,
  }) {
    return Tooltip(
      message: "Coming soon",
      child: TextButton.icon(
        onPressed: null,
        icon: Icon(icon, size: 18, color: Colors.grey),
        label: Text(label, style: const TextStyle(color: Colors.grey)),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
      ),
    );
  }

  Widget _comingSoonPrimaryButton({
    required IconData icon,
    required String label,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Tooltip(
        message: "Coming soon",
        child: ElevatedButton.icon(
          onPressed: null,
          icon: Icon(icon, color: Colors.grey),
          label: Text(label, style: const TextStyle(color: Colors.grey)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}