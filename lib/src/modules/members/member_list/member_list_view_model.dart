import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/modules/members/modify_member/modify_member_view.dart';
import 'package:qr_manager/src/modules/qrs/qr_list/qr_list_view.dart';

class MemberListViewModel {
  static void navigateToModifyMember({
    required BuildContext context,
    required String groupId,
    String? memberId,
  }) {
    if (memberId == null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ModifyMemberView(groupId: groupId),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ModifyMemberView(
            groupId: groupId,
            memberId: memberId,
          ),
        ),
      );
    }
  }

  static void navigateToQRList(
    BuildContext context,
    String groupId,
    String memberId,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => QRListView(
          groupId: groupId,
          memberId: memberId,
        ),
      ),
    );
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
