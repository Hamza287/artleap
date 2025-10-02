import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/home_screen_provider.dart';
import 'comment_section.dart';
import 'post_actions.dart';
import 'post_description.dart';
import 'post_header.dart';
import 'post_image.dart';

class PostCard extends ConsumerStatefulWidget {
  final dynamic image;
  final int index;
  final HomeScreenProvider homeProvider;

  const PostCard({
    super.key,
    required this.image,
    required this.index,
    required this.homeProvider,
  });

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(image: widget.image),
          PostImage(
            image: widget.image,
            homeProvider: widget.homeProvider,
            index: widget.index,
          ),
          PostActions(image: widget.image),
          PostDescription(image: widget.image),
          CommentsSection(image: widget.image),
        ],
      ),
    );
  }
}