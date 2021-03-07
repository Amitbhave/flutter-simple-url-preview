import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Shows image of URL
class PreviewImage extends StatelessWidget {
  PreviewImage(
    this._image,
    this._totalHeight,
    this._imageLoaderColor,
  );

  final String? _image;
  final double? _totalHeight;
  final Color? _imageLoaderColor;

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: CachedNetworkImage(
          imageUrl: _image!,
          fit: BoxFit.fill,
          height: _totalHeight! * 0.85,
          errorWidget: (context, url, error) => Icon(Icons.error),
          progressIndicatorBuilder: (context, url, downloadProgress) => Icon(
            Icons.more_horiz,
            color: _imageLoaderColor,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
