import 'package:flutter/material.dart';

/// Shows site name of URL
class PreviewSiteName extends StatelessWidget {
  final String? _siteName;
  final TextStyle? _textStyle;

  PreviewSiteName(this._siteName, this._textStyle);

  @override
  Widget build(BuildContext context) {
    if (_siteName == null) {
      return SizedBox();
    }

    return Text(
      _siteName!,
      textAlign: TextAlign.left,
      style: _textStyle,
    );
  }
}
