import 'dart:convert';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    super.key,
    required this.photoString,
    this.imageSize = 0,
  });

  final String photoString;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    double size = imageSize == 0 ? MediaQuery.sizeOf(context).height * 0.1 : imageSize;
    ImageProvider provider = MemoryImage(base64Decode(photoString));

    return Container(
        decoration: BoxDecoration(
          // color: Theme.of(context).colorScheme.background,
          border: Border.all(
            width: 3,
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.circular(200),
        ),
        width: size,
        height: size,
        child: ClipOval(
          child: SizedBox.fromSize(
            size: const Size.fromRadius(50),
            child: Image(image: provider, fit: BoxFit.cover),
          ),
        ));
  }
}
