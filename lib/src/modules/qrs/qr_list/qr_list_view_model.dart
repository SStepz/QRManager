import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/data/models/member/member.dart';

class QRListViewModel {
  static Group getGroup(WidgetRef ref, String groupId) {
    final groupData = ref.watch(Group.groupListProvider);
    final group = groupData.firstWhere((group) => group.id == groupId);
    return group;
  }

  static Member getMember(WidgetRef ref, String memberId) {
    final memberData = ref.watch(Member.memberListProvider);
    final member = memberData.firstWhere((member) => member.id == memberId);
    return member;
  }

  static Future<void> removeQR(
    WidgetRef ref,
    String memberId,
    String qrId,
  ) async {
    await ref.read(Member.memberListProvider.notifier).removeQR(memberId, qrId);
  }
}
