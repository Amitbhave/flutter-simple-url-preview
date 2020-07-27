import 'package:flutter/material.dart';
import 'package:simple_url_preview/widgets/empty_container.dart';

class PreviewImage extends StatelessWidget {
  final String _image;
  final double _totalHeight;

  PreviewImage(this._image, this._totalHeight);

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return Padding(
          padding: EdgeInsets.all(10),
          child: Image.network(
            _image,
            fit: BoxFit.fill,
            height: _totalHeight * 0.85,
          ));
    } else {
      return EmptyContainer();
    }
  }
}
