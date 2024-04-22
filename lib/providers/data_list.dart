import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:qr_manager/models/group.dart';

class DataListNotifier extends StateNotifier<List<Group>> {
  DataListNotifier() : super(const []) {
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

  Future<void> addMember(String groupId, String memberName) async {
    final box = await Hive.openBox<Group>('groups');
    final groupIndex = box.values.toList().indexWhere((n) => n.id == groupId);
    if (groupIndex != -1) {
      final group = box.getAt(groupIndex);
      final newMember = Member(name: memberName);
      group!.members.add(newMember);
      await box.putAt(groupIndex, group);
      state = box.values.toList();
    }
  }

  Future<void> addQR(String groupId, String memberId, QRCode qrCode) async {
    final box = await Hive.openBox<Group>('groups');
    final groupIndex = box.values.toList().indexWhere((n) => n.id == groupId);
    if (groupIndex != -1) {
      final group = box.getAt(groupIndex);
      final memberIndex = group!.members.indexWhere((n) => n.id == memberId);
      if (memberIndex != -1) {
        final member = group.members[memberIndex];
        member.qrCodes.add(qrCode);
        await box.putAt(groupIndex, group);
        state = box.values.toList();
      }
    }
  }

  Future<void> removeGroup(String groupId) async {
    final box = await Hive.openBox<Group>('groups');
    final groupIndex = box.values.toList().indexWhere((n) => n.id == groupId);
    if (groupIndex != -1) {
      await box.deleteAt(groupIndex);
      state = box.values.toList();
    }
  }

  Future<void> removeMember(String groupId, String memberId) async {
    final box = await Hive.openBox<Group>('groups');
    final groupIndex = box.values.toList().indexWhere((n) => n.id == groupId);
    if (groupIndex != -1) {
      final group = box.getAt(groupIndex);
      final memberIndex = group!.members.indexWhere((n) => n.id == memberId);
      if (memberIndex != -1) {
        group.members.removeAt(memberIndex);
        await box.putAt(groupIndex, group);
        state = box.values.toList();
      }
    }
  }

  Future<void> removeQR(String groupId, String memberId, String qrId) async {
    final box = await Hive.openBox<Group>('groups');
    final groupIndex = box.values.toList().indexWhere((n) => n.id == groupId);
    if (groupIndex != -1) {
      final group = box.getAt(groupIndex);
      final memberIndex = group!.members.indexWhere((n) => n.id == memberId);
      if (memberIndex != -1) {
        final member = group.members[memberIndex];
        final qrIndex = member.qrCodes.indexWhere((n) => n.id == qrId);
        if (qrIndex != -1) {
          member.qrCodes.removeAt(qrIndex);
          await box.putAt(groupIndex, group);
          state = box.values.toList();
        }
      }
    }
  }

  Future<void> editGroupName(String groupId, String newName) async {
    final box = await Hive.openBox<Group>('groups');
    final groupIndex = box.values.toList().indexWhere((n) => n.id == groupId);
    if (groupIndex != -1) {
      final oldGroup = box.getAt(groupIndex);
      final newGroup =
          Group(id: groupId, name: newName, members: oldGroup!.members);
      await box.putAt(groupIndex, newGroup);
      state = box.values.toList();
    }
  }

  Future<void> editMemberName(
      String groupId, String memberId, String newMemberName) async {
    final box = await Hive.openBox<Group>('groups');
    final groupIndex = box.values.toList().indexWhere((n) => n.id == groupId);
    if (groupIndex != -1) {
      final group = box.getAt(groupIndex);
      final memberIndex = group!.members.indexWhere((n) => n.id == memberId);
      if (memberIndex != -1) {
        final oldMember = group.members[memberIndex];
        final newMember = Member(
            id: memberId, name: newMemberName, qrCodes: oldMember.qrCodes);
        group.members[memberIndex] = newMember;
        await box.putAt(groupIndex, group);
        state = box.values.toList();
      }
    }
  }

  Future<void> editQR(
    String groupId,
    String memberId,
    String qrId,
    QRCode qrCode,
  ) async {
    final box = await Hive.openBox<Group>('groups');
    final groupIndex = box.values.toList().indexWhere((n) => n.id == groupId);
    if (groupIndex != -1) {
      final group = box.getAt(groupIndex);
      final memberIndex = group!.members.indexWhere((n) => n.id == memberId);
      if (memberIndex != -1) {
        final member = group.members[memberIndex];
        final qrIndex = member.qrCodes.indexWhere((n) => n.id == qrId);
        if (qrIndex != -1) {
          member.qrCodes[qrIndex] = qrCode;
          await box.putAt(groupIndex, group);
          state = box.values.toList();
        }
      }
    }
  }
}

final dataListProvider = StateNotifierProvider<DataListNotifier, List<Group>>(
  (ref) => DataListNotifier(),
);
