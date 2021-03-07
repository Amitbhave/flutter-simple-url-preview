import 'package:flutter/material.dart';

/// Shows site name of URL
class PreviewSiteName extends StatelessWidget {
  PreviewSiteName(this._siteName, this._textColor);

  final String? _siteName;
  final Color? _textColor;

  @override
  Widget build(BuildContext context) {
    if (_siteName != null) {
      return Text(
        _siteName!,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 14,
          color: _textColor,
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
