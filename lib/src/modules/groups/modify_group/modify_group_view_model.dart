import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/common/components/display_dialog.dart';

class ModifyGroupViewModel {
  static Future<void> saveGroup(
    WidgetRef ref,
    BuildContext context,
    String groupName,
    String? groupId,
    Function onOperationComplete,
  ) async {
    final groupData = ref.watch(Group.groupListProvider);
    final existingGroup = groupData.firstWhereOrNull(
        (group) => group.name == groupName && group.id != groupId);

    if (groupName.isEmpty) {
      DisplayDialog.showDialogWithMessage(context, 'Invalid Input',
          'Please make sure a valid name was entered.');
      return;
    }

    if (existingGroup != null) {
      DisplayDialog.showDialogWithMessage(context, 'Invalid Input',
          'A group with the same name already exists.');
      return;
    }

    if (groupId == null) {
      await ref.read(Group.groupListProvider.notifier).addGroup(groupName);
    } else {
      await ref
          .read(Group.groupListProvider.notifier)
          .editGroupName(groupId, groupName);
    }

    onOperationComplete();
  }
}
