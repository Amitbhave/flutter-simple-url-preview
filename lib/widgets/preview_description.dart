import 'package:flutter/material.dart';

/// Shows description of URL
class PreviewDescription extends StatelessWidget {
  final String _description;
  final TextStyle _textStyle;
  final int _descriptionLines;

  PreviewDescription(
      this._description, this._textStyle, this._descriptionLines);

  @override
  Widget build(BuildContext context) {
    if (_description == null) {
      return SizedBox();
    }

    return Flexible(
      child: Container(
        child: Text(
          _description,
          overflow: TextOverflow.clip,
          textAlign: TextAlign.left,
          maxLines: _descriptionLines,
          softWrap: true,
          style: _textStyle,
        ),
      ),
    );
  }
}
