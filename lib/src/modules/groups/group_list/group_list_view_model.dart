import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/data/models/member/member.dart';

class GroupListViewModel {
  static Future<void> removeGroup(WidgetRef ref, String groupId) async {
    List<String> memberIds =
        await ref.read(Group.groupListProvider.notifier).getMemberIds(groupId);
    await ref.read(Group.groupListProvider.notifier).removeGroup(groupId);
    for (var memberId in memberIds) {
      await ref.read(Member.memberListProvider.notifier).removeMember(memberId);
    }
  }
}
