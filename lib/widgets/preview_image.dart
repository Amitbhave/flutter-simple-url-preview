import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_url_preview/widgets/empty_container.dart';

class PreviewImage extends StatelessWidget {
  final String _image;
  final double _totalHeight;
  final Color _imageLoaderColor;

  PreviewImage(this._image, this._totalHeight, this._imageLoaderColor);

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: CachedNetworkImage(
          imageUrl: _image,
          fit: BoxFit.fill,
          height: _totalHeight * 0.85,
          errorWidget: (context, url, error) => Icon(Icons.error),
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              SpinKitFadingCircle(color: _imageLoaderColor),
        ),
      );
    } else {
      return EmptyContainer();
    }
  }
}
