import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Shows image of URL
class PreviewImage extends StatelessWidget {
  final String _image;
  final Color _imageLoaderColor;

  PreviewImage(this._image, this._imageLoaderColor);

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: CachedNetworkImage(
          imageUrl: _image,
          fit: BoxFit.cover,
          height: (MediaQuery.of(context).size.width -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom) *
              0.25,
          errorWidget: (context, url, error) => Icon(
            Icons.error,
            color: _imageLoaderColor,
          ),
          progressIndicatorBuilder: (context, url, downloadProgress) => Icon(
            Icons.more_horiz,
            color: _imageLoaderColor,
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
