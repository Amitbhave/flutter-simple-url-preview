import 'package:flutter/material.dart';
import 'package:simple_url_preview/widgets/empty_container.dart';

/// Shows site name of URL
class PreviewSiteName extends StatelessWidget {
  final String _siteName;
  final Color _textColor;

  PreviewSiteName(this._siteName, this._textColor);

  @override
  Widget build(BuildContext context) {
    if (_siteName != null) {
      return Text(
        _siteName,
        textAlign: TextAlign.left,
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
