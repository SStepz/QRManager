import 'package:flutter/material.dart';

import 'package:qr_manager/src/common/components/custom_text.dart';

class DisplayDialog {
  static void showDialogWithMessage(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: CustomText.titleLarge(
          context: context,
          text: title,
          weight: FontWeight.bold,
        ),
        content: CustomText.bodyLarge(
          context: context,
          text: message,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: CustomText.bodyLarge(
              context: context,
              text: 'Okay',
              weight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
