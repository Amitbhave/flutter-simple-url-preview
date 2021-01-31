import 'package:flutter/material.dart';

/// Shows title of URL
class PreviewTitle extends StatelessWidget {
  final String _title;
  final int _titleLines;
  final TextStyle _titleStyle;

  PreviewTitle(this._title, this._titleStyle, this._titleLines);

  @override
  Widget build(BuildContext context) {
    if (_title == null) {
      return SizedBox();
    }

    return Text(
      _title,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      maxLines: _titleLines,
      style: _titleStyle,
    );
  }
}
