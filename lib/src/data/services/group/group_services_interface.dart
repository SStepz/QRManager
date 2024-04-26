import 'package:qr_manager/src/data/models/group/group.dart';

abstract class GroupServicesInterface {
  Future<List<Group>> loadGroups();
  Future<List<Group>> addGroup(String name);
  Future<List<Group>> addMember(String groupId, String memberId);
  Future<List<String>> getMemberIds(String groupId);
  Future<List<Group>> removeGroup(String groupId);
  Future<List<Group>> removeMember(String groupId, String memberId);
  Future<List<Group>> editGroupName(String groupId, String newName);
}