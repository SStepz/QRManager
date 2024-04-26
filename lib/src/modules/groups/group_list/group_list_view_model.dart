import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/modules/groups/modify_group/modify_group_view.dart';
import 'package:qr_manager/src/modules/members/member_list/member_list_view.dart';

class GroupListViewModel {
  static void navigateToModifyGroup({
    required BuildContext context,
    String? groupId,
  }) {
    if (groupId == null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const ModifyGroupView(),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ModifyGroupView(groupId: groupId),
        ),
      );
    }
  }

  static void navigateToMemberList(BuildContext context, String groupId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MemberListView(groupId: groupId),
      ),
    );
  }

  static Future<void> removeGroup(WidgetRef ref, String groupId) async {
    List<String> memberIds =
        await ref.read(Group.groupListProvider.notifier).getMemberIds(groupId);
    await ref.read(Group.groupListProvider.notifier).removeGroup(groupId);
    for (var memberId in memberIds) {
      await ref.read(Member.memberListProvider.notifier).removeMember(memberId);
    }
  }
}
