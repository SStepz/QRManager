import 'package:hive/hive.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/common/constants/hivebox_name.dart';
import 'package:qr_manager/src/data/services/group/group_services_interface.dart';

class GroupServices implements GroupServicesInterface {
  final String _groupBox = HiveBoxName().groupBox;

  @override
  Future<List<Group>> loadGroups() async {
    final box = await Hive.openBox<Group>(_groupBox);
    return box.values.toList();
  }

  @override
  Future<List<Group>> addGroup(String name) async {
    final box = await Hive.openBox<Group>(_groupBox);
    final newGroup = Group(name: name);
    box.add(newGroup);
    return box.values.toList();
  }

  @override
  Future<List<Group>> addMember(String groupId, String memberId) async {
    final box = await Hive.openBox<Group>(_groupBox);
    final groupIndex = box.values.toList().indexWhere((n) => n.id == groupId);
    if (groupIndex != -1) {
      final group = box.getAt(groupIndex);
      group!.memberIds.add(memberId);
      await box.putAt(groupIndex, group);
      return box.values.toList();
    }
    return [];
  }

  @override
  Future<List<String>> getMemberIds(String groupId) async {
    final box = await Hive.openBox<Group>(_groupBox);
    final groupIndex = box.values.toList().indexWhere((n) => n.id == groupId);
    List<String> memberIds = [];
    if (groupIndex != -1) {
      final group = box.getAt(groupIndex);
      memberIds = List<String>.from(group!.memberIds);
    }
    return memberIds;
  }

  @override
  Future<List<Group>> removeGroup(String groupId) async {
    final box = await Hive.openBox<Group>(_groupBox);
    final groupIndex = box.values.toList().indexWhere((n) => n.id == groupId);
    if (groupIndex != -1) {
      await box.deleteAt(groupIndex);
      return box.values.toList();
    }
    return [];
  }

  @override
  Future<List<Group>> removeMember(String groupId, String memberId) async {
    final box = await Hive.openBox<Group>(_groupBox);
    final groupIndex = box.values.toList().indexWhere((n) => n.id == groupId);
    if (groupIndex != -1) {
      final group = box.getAt(groupIndex);
      group!.memberIds.remove(memberId);
      await box.putAt(groupIndex, group);
      return box.values.toList();
    }
    return [];
  }
  
  @override
  Future<List<Group>> editGroupName(String groupId, String newName) async {
    final box = await Hive.openBox<Group>(_groupBox);
    final groupIndex = box.values.toList().indexWhere((n) => n.id == groupId);
    if (groupIndex != -1) {
      final oldGroup = box.getAt(groupIndex);
      final newGroup =
          Group(id: groupId, name: newName, memberIds: oldGroup!.memberIds);
      await box.putAt(groupIndex, newGroup);
      return box.values.toList();
    }
    return [];
  }
}