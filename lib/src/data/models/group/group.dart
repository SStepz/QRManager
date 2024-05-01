import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'package:qr_manager/src/data/services/group/group_services_interface.dart';
import 'package:qr_manager/src/data/services/group/group_services.dart';
// import 'package:qr_manager/src/data/services/group/group_service_mock.dart';

part 'group.g.dart';

const uuid = Uuid();

@HiveType(typeId: 0)
class Group {
  Group({
    required this.name,
    List<String>? memberIds,
    String? id,
  })  : id = id ?? uuid.v4(),
        memberIds = memberIds ?? [];

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  List<String> memberIds;

  static final groupListProvider =
      StateNotifierProvider<GroupListNotifier, List<Group>>(
    (ref) => GroupListNotifier(),
  );
}

class GroupListNotifier extends StateNotifier<List<Group>> {
  GroupListNotifier({GroupServicesInterface? groupServices})
      : _groupServices = groupServices ?? GroupServices(),
        super(const []) {
    _loadGroups();
  }

  final GroupServicesInterface _groupServices;

  Future<void> _loadGroups() async {
    state = await _groupServices.loadGroups();
  }

  Future<void> addGroup(String name) async {
    state = await _groupServices.addGroup(name);
  }

  Future<void> addMember(String groupId, String memberId) async {
    state = await _groupServices.addMember(groupId, memberId);
  }

  Future<List<String>> getMemberIds(String groupId) async {
    return await _groupServices.getMemberIds(groupId);
  }

  Future<void> removeGroup(String groupId) async {
    state = await _groupServices.removeGroup(groupId);
  }

  Future<void> removeMember(String groupId, String memberId) async {
    state = await _groupServices.removeMember(groupId, memberId);
  }

  Future<void> editGroupName(String groupId, String newName) async {
    state = await _groupServices.editGroupName(groupId, newName);
  }
}
