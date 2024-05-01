import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/data/models/member/member.dart';

class MemberListViewModel {
  static Group getGroup(WidgetRef ref, String groupId) {
    final groupData = ref.watch(Group.groupListProvider);
    final group = groupData.firstWhere((group) => group.id == groupId);
    return group;
  }

  static List<Member> getMembers(WidgetRef ref, Group group) {
    final memberData = ref.watch(Member.memberListProvider);
    final members = memberData
        .where((member) => group.memberIds.contains(member.id))
        .toList();
    return members;
  }

  static Future<void> removeMember(
    WidgetRef ref,
    String groupId,
    String memberId,
  ) async {
    await ref
        .read(Group.groupListProvider.notifier)
        .removeMember(groupId, memberId);
    await ref.read(Member.memberListProvider.notifier).removeMember(memberId);
  }
}
