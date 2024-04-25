import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:qr_manager/models/group.dart';

class GroupListNotifier extends StateNotifier<List<Group>> {
  GroupListNotifier() : super(const []) {
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final box = await Hive.openBox<Group>('groups');
    state = box.values.toList();
  }

  Future<void> addGroup(String name) async {
    final box = await Hive.openBox<Group>('groups');
    final newGroup = Group(name: name);
    box.add(newGroup);
    state = box.values.toList();
  }

  Future<void> addMember(String groupId, String memberId) async {
    final box = await Hive.openBox<Group>('groups');
    final groupIndex = box.values.toList().indexWhere((n) => n.id == groupId);
    if (groupIndex != -1) {
      final group = box.getAt(groupIndex);
      group!.memberIds.add(memberId);
      await box.putAt(groupIndex, group);
      state = box.values.toList();
    }
  }

  Future<List<String>> removeGroup(String groupId) async {
    final box = await Hive.openBox<Group>('groups');
    final groupIndex = box.values.toList().indexWhere((n) => n.id == groupId);
    List<String> memberIds = [];
    if (groupIndex != -1) {
      final group = box.getAt(groupIndex);
      memberIds = List<String>.from(group!.memberIds);
      await box.deleteAt(groupIndex);
      state = box.values.toList();
    }
    return memberIds;
  }

  Future<void> removeMember(String groupId, String memberId) async {
    final box = await Hive.openBox<Group>('groups');
    final groupIndex = box.values.toList().indexWhere((n) => n.id == groupId);
    if (groupIndex != -1) {
      final group = box.getAt(groupIndex);
      group!.memberIds.remove(memberId);
      await box.putAt(groupIndex, group);
      state = box.values.toList();
    }
  }

  Future<void> editGroupName(String groupId, String newName) async {
    final box = await Hive.openBox<Group>('groups');
    final groupIndex = box.values.toList().indexWhere((n) => n.id == groupId);
    if (groupIndex != -1) {
      final oldGroup = box.getAt(groupIndex);
      final newGroup =
          Group(id: groupId, name: newName, memberIds: oldGroup!.memberIds);
      await box.putAt(groupIndex, newGroup);
      state = box.values.toList();
    }
  }
}

final groupListProvider = StateNotifierProvider<GroupListNotifier, List<Group>>(
  (ref) => GroupListNotifier(),
);
