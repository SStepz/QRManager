import 'package:flutter/material.dart';

class CustomText {
  static Widget bodyLarge({
    required BuildContext context,
    required String text,
    Color? color,
    FontWeight? weight,
  }) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: color ?? Theme.of(context).colorScheme.primaryContainer,
            fontWeight: weight ?? FontWeight.normal,
          ),
    );
  }

  static Widget titleMedium({
    required BuildContext context,
    required String text,
    Color? color,
    FontWeight? weight,
  }) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: color ?? Theme.of(context).colorScheme.onSecondaryContainer,
            fontWeight: weight ?? FontWeight.normal,
          ),
    );
  }

  static Widget titleLarge({
    required BuildContext context,
    required String text,
    Color? color,
    FontWeight? weight,
  }) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: color ?? Theme.of(context).colorScheme.primaryContainer,
            fontWeight: weight ?? FontWeight.normal,
          ),
    );
  }
}
