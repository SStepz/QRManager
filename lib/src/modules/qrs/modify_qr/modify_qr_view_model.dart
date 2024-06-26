import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/member/member.dart';

class ModifyQRViewModel {
  static Future<void> saveQR(
    WidgetRef ref,
    String memberId,
    String qrName,
    String qrAccountName,
    File? image,
    QRCode? qrCode,
  ) async {
    image ??= File('');
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
  }
}
