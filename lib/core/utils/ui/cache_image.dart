import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CacheImage extends StatelessWidget {
  const CacheImage({
    super.key,
    required this.imageUrl,
    required this.loadingWidth,
    required this.loadingHeight,
  });

  final String imageUrl;

  final double loadingWidth;
  final double loadingHeight;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade400,
          child: Container(
            width: loadingWidth,
            height: loadingHeight,
            color: Colors.white,
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          width: loadingWidth,
          height: loadingHeight,
          color: Colors.grey.shade300,
        );
      },
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
    );
  }
}
