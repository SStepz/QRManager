import 'package:flutter/material.dart';

class CustomIcon {
  static Widget colorIcon({
    required BuildContext context,
    required IconData icon,
    Color? color,
  }) {
    return Icon(
      icon,
      color: color ?? Theme.of(context).colorScheme.onBackground,
    );
  }
}
