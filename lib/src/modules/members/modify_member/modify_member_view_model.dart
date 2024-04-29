import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/common/components/display_dialog.dart';

class ModifyMemberViewModel {
  static Future<void> saveMember(
    WidgetRef ref,
    BuildContext context,
    String groupId,
    String memberName,
    String? memberId,
    Function onOperationComplete,
  ) async {
    final memberData = ref.watch(Member.memberListProvider);
    final existingMember =
        memberData.firstWhereOrNull((member) => member.name == memberName && member.id != memberId);

    if (memberName.isEmpty) {
      DisplayDialog.showDialogWithMessage(context, 'Invalid Input', 'Please make sure a valid name was entered.');
      return;
    }

    if (existingMember != null) {
      DisplayDialog.showDialogWithMessage(context, 'Invalid Input', 'A member with the same name already exists.');
      return;
    }

    if (memberId == null) {
      await ref.read(Member.memberListProvider.notifier).addMember(memberName);
      final memberId = await ref.read(Member.memberListProvider.notifier).getMemberId(memberName);
      await ref
          .read(Group.groupListProvider.notifier)
          .addMember(groupId, memberId);
    } else {
      await ref
          .read(Member.memberListProvider.notifier)
          .editMemberName(memberId, memberName);
    }

    onOperationComplete();
  }
}