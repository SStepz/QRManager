import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/data/services/group/group_services_interface.dart';

class GroupServicesMock implements GroupServicesInterface {
  List<Group> mockGroup = [
    Group(
      id: '1',
      name: 'Group 1',
      memberIds: ['1', '2', '3'],
    ),
    Group(
      id: '2',
      name: 'Group 2',
      memberIds: ['4', '5', '6'],
    ),
    Group(
      id: '3',
      name: 'Group 3',
      memberIds: ['7', '8', '9'],
    ),
    Group(
      id: '4',
      name: 'Group 4',
      memberIds: ['10', '11', '12'],
    ),
    Group(
      id: '5',
      name: 'Group 5',
      memberIds: ['13', '14', '15'],
    ),
  ];
  
  @override
  Future<List<Group>> loadGroups() async {
    return mockGroup;
  }

  @override
  Future<List<Group>> addGroup(String name) async {
    return mockGroup;
  }

  @override
  Future<List<Group>> addMember(String groupId, String memberId) async {
    return mockGroup;
  }

  @override
  Future<List<String>> getMemberIds(String groupId) async {
    return mockGroup.firstWhere((group) => group.id == groupId).memberIds;
  }
  
  @override
  Future<List<Group>> removeGroup(String groupId) async {
    return mockGroup;
  }
  
  @override
  Future<List<Group>> removeMember(String groupId, String memberId) async {
    return mockGroup;
  }

  @override
  Future<List<Group>> editGroupName(String groupId, String newName) async {
    return mockGroup;
  }
}
