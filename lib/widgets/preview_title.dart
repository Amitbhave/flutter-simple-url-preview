import 'package:flutter/material.dart';
import 'package:simple_url_preview/widgets/empty_container.dart';

class PreviewTitle extends StatelessWidget {
  final String _title;
  final Color _textColor;

  PreviewTitle(this._title, this._textColor);

  @override
  Widget build(BuildContext context) {
    if (_title != null) {
      return Text(
        _title,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: _textColor,
        ),
      );
    } else {
      return EmptyContainer();
    }
  }
}
