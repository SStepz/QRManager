import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/modules/qrs/modify_qr/modify_qr_view.dart';
import 'package:qr_manager/src/modules/qrs/qr_detail/qr_detail_view.dart';

class QRListViewModel {
  static void navigateToModifyQR({
    required BuildContext context,
    required String memberId,
    QRCode? qrCode,
  }) {
    if (qrCode == null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ModifyQRView(memberId: memberId),
        ),
      );
    } else {
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

  static void navigateToQRDetail(
    BuildContext context,
    String groupId,
    String memberId,
    String qrId,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => QRDetailView(
          groupId: groupId,
          memberId: memberId,
          qrId: qrId,
        ),
      ),
    );
  }

  static Future<void> removeQR(
    WidgetRef ref,
    String memberId,
    String qrId,
  ) async {
    await ref.read(Member.memberListProvider.notifier).removeQR(memberId, qrId);
  }
}
