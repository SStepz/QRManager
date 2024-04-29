import 'package:flutter/material.dart';

import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/modules/qrs/modify_qr/modify_qr_view.dart';

class QRDetailViewModel {
  static void navigateToModifyQR(
    BuildContext context,
    String memberId,
    QRCode qrCode,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ModifyQRView(
          memberId: memberId,
          qrCode: qrCode,
        ),
      ),
    );
  }
}
