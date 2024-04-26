import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/common/components/display_dialog.dart';

class ModifyQRViewModel {
  static Future<void> saveQR(
    WidgetRef ref,
    BuildContext context,
    String memberId,
    String qrName,
    String qrAccountName,
    File? image,
    QRCode? qrCode,
    Function onOperationComplete,
  ) async {
    if (qrName.isEmpty || qrAccountName.isEmpty || image == null) {
      DisplayDialog.showDialogWithMessage(
          context, 'Invalid Input', 'Please make sure every field is valid.');
      return;
    }

    if (qrCode == null) {
      await ref.read(Member.memberListProvider.notifier).addQR(
          memberId,
          QRCode(
            name: qrName,
            accountName: qrAccountName,
            imagePath: image.path,
          ));
    } else {
      await ref.read(Member.memberListProvider.notifier).editQR(
          memberId,
          qrCode.id,
          QRCode(
              id: qrCode.id,
              name: qrName,
              accountName: qrAccountName,
              imagePath: image.path));
    }

    onOperationComplete();
  }
}
