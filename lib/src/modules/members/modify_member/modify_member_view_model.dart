import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/data/models/member/member.dart';

class ModifyMemberViewModel {
  static String getMemberName(WidgetRef ref, String? memberId) {
    final memberData = ref.watch(Member.memberListProvider);
    final member = memberData.firstWhere((member) => member.id == memberId);
    return member.name;
  }

  static Member? getExistingMember(
    WidgetRef ref,
    String memberName,
    String? memberId,
  ) {
    final memberData = ref.watch(Member.memberListProvider);
    final member = memberData.firstWhereOrNull(
        (member) => member.name == memberName && member.id != memberId);
    return member;
  }

  static Future<void> saveMember(
    WidgetRef ref,
    String groupId,
    String memberName,
    String? memberId,
  ) async {
    if (memberId == null) {
      await ref.read(Member.memberListProvider.notifier).addMember(memberName);
      final memberId = await ref
          .read(Member.memberListProvider.notifier)
          .getMemberId(memberName);
      await ref
          .read(Group.groupListProvider.notifier)
          .addMember(groupId, memberId);
    } else {
      await ref
          .read(Member.memberListProvider.notifier)
          .editMemberName(memberId, memberName);
    }
  }
}
