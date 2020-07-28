import 'package:flutter/material.dart';

/// Shows empty container. Shown when any of the information is not present.
class EmptyContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0,
      width: 0,
    );
  }
}
