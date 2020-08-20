import 'package:flutter/material.dart';

/// Shows title of URL
class PreviewTitle extends StatelessWidget {
  final String _title;
  final Color _textColor;
  final int _titleLines;

  PreviewTitle(this._title, this._textColor, this._titleLines);

  @override
  Widget build(BuildContext context) {
    if (_title != null) {
      return Text(
        _title,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        maxLines: _titleLines,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: _textColor,
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
