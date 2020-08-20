import 'package:flutter/material.dart';

/// Shows description of URL
class PreviewDescription extends StatelessWidget {
  final String _description;
  final Color _textColor;
  final int _descriptionLines;

  PreviewDescription(
      this._description, this._textColor, this._descriptionLines);

  @override
  Widget build(BuildContext context) {
    if (_description != null) {
      return Text(
        _description,
        textAlign: TextAlign.left,
        maxLines: _descriptionLines,
        style: TextStyle(
          fontSize: 14,
          color: _textColor,
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
