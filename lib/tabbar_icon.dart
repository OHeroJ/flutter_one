import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RootTabBarIcon extends StatelessWidget {
  final String iconPath;
  final Image placeholderImage;
  final int count;
  RootTabBarIcon({this.iconPath, this.placeholderImage, this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 2),
      child: CachedNetworkImage(
        fadeOutDuration: Duration.zero,
        fadeInDuration: Duration.zero,
        imageUrl: iconPath,
        width: 24,
        height: 24,
      ),
    );
  }
}
