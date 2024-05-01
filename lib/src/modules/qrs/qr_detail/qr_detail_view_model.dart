import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/member/member.dart';

class QRDetailViewModel {
  static Member getMember(WidgetRef ref, String memberId) {
    final memberData = ref.watch(Member.memberListProvider);
    final member = memberData.firstWhere((member) => member.id == memberId);
    return member;
  }

  static QRCode getQRCode(Member member, String qrId) {
    final qrCodes = member.qrCodes;
    final qr = qrCodes.firstWhere((qr) => qr.id == qrId);
    return qr;
  }
}
