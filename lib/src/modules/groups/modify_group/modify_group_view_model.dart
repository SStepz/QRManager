import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import 'package:qr_manager/src/data/models/group/group.dart';

class ModifyGroupViewModel {
  static String getGroupName(WidgetRef ref, String? groupId) {
    final groupData = ref.watch(Group.groupListProvider);
    final group = groupData.firstWhere((group) => group.id == groupId);
    return group.name;
  }

  static Group? getExistingGroup(
    WidgetRef ref,
    String groupName,
    String? groupId,
  ) {
    final groupData = ref.watch(Group.groupListProvider);
    final group = groupData.firstWhereOrNull(
        (group) => group.name == groupName && group.id != groupId);
    return group;
  }

  static Future<void> saveGroup(
    WidgetRef ref,
    String groupName,
    String? groupId,
  ) async {
    if (groupId == null) {
      await ref.read(Group.groupListProvider.notifier).addGroup(groupName);
    } else {
      await ref
          .read(Group.groupListProvider.notifier)
          .editGroupName(groupId, groupName);
    }
  }
}
