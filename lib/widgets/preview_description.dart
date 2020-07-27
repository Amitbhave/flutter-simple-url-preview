import 'package:flutter/material.dart';
import 'package:simple_url_preview/widgets/empty_container.dart';

class PreviewDescription extends StatelessWidget {
  final String _description;
  final Color _textColor;

  PreviewDescription(this._description, this._textColor);

  @override
  Widget build(BuildContext context) {
    if (_description != null) {
      return Text(
        _description,
        textAlign: TextAlign.left,
        maxLines: 3,
        style: TextStyle(
          fontSize: 14,
          color: _textColor,
        ),
      );
    } else {
      return EmptyContainer();
    }
  }
}
