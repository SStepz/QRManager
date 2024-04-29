import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/data/services/group/group_services_interface.dart';

class MockGroupServices extends Mock implements GroupServicesInterface {}

void main() {
  group('Groups', () {
    test('should create Group with default values for id and memberIds', () {
      final group = Group(name: 'Test Group');

      expect(group.id, isNotNull);
      expect(group.memberIds, isEmpty);
    });

    test('should create Group with provided values for id and memberIds', () {
      final group = Group(
        name: 'Test Group',
        id: 'test-id',
        memberIds: ['member1', 'member2'],
      );

      expect(group.id, equals('test-id'));
      expect(group.memberIds, equals(['member1', 'member2']));
    });

    group('GroupListNotifier', () {
      late MockGroupServices mockGroupServices;
      late GroupListNotifier groupListNotifier;
      late List<Group> initialState;

      setUp(() {
        mockGroupServices = MockGroupServices();
        when(() => mockGroupServices.loadGroups())
            .thenAnswer((_) async => <Group>[]);
        groupListNotifier = GroupListNotifier(groupServices: mockGroupServices);
        initialState = [
          Group(id: '1', name: 'First', memberIds: ['member1', 'member2']),
        ];
        groupListNotifier.state = initialState;
      });

      test('addGroup calls GroupServices.addGroup and updates state', () async {
        final group = Group(name: 'Test Group');
        when(() => mockGroupServices.addGroup('Test Group'))
            .thenAnswer((_) async => [group, ...initialState]);

        await groupListNotifier.addGroup('Test Group');

        verify(() => mockGroupServices.addGroup('Test Group')).called(1);
        expect(groupListNotifier.state, contains(group));
      });

      test('addMember calls GroupServices.addMember and updates state',
          () async {
        const groupId = '1';
        const memberId = 'member3';
        final group = Group(
            id: groupId,
            name: 'First',
            memberIds: ['member1', 'member2', memberId]);
        when(() => mockGroupServices.addMember(groupId, memberId)).thenAnswer(
            (_) async => [
                  group,
                  ...initialState
                      .where((group) => group.id != groupId)
                ]);

        await groupListNotifier.addMember(groupId, memberId);

        verify(() => mockGroupServices.addMember(groupId, memberId)).called(1);
        expect(groupListNotifier.state, contains(group));
      });

      test('getMemberIds calls GroupServices.getMemberIds', () async {
        const groupId = '1';
        final group = initialState.firstWhere((group) => group.id == groupId);
        when(() => mockGroupServices.getMemberIds(groupId))
            .thenAnswer((_) async => group.memberIds);

        final memberIds = await groupListNotifier.getMemberIds(groupId);

        verify(() => mockGroupServices.getMemberIds(groupId)).called(1);
        expect(memberIds, group.memberIds);
      });

      test('removeGroup calls GroupServices.removeGroup and updates state',
          () async {
        const groupId = '1';
        final group =
            initialState.firstWhere((group) => group.id == groupId);
        when(() => mockGroupServices.removeGroup(groupId)).thenAnswer(
            (_) async => initialState
                .where((group) => group.id != groupId)
                .toList());

        await groupListNotifier.removeGroup(groupId);

        verify(() => mockGroupServices.removeGroup(groupId)).called(1);
        expect(groupListNotifier.state, isNot(contains(group)));
      });

      test('removeMember calls GroupServices.removeMember and updates state',
          () async {
        const groupId = '1';
        const memberId = 'member2';
        final group = Group(id: groupId, name: 'First', memberIds: ['member1']);
        when(() => mockGroupServices.removeMember(groupId, memberId))
            .thenAnswer((_) async => [
                  group,
                  ...initialState
                      .where((group) => group.id != groupId)
                ]);

        await groupListNotifier.removeMember(groupId, memberId);

        verify(() => mockGroupServices.removeMember(groupId, memberId))
            .called(1);
        expect(groupListNotifier.state, contains(group));
      });

      test('editGroupName calls GroupServices.editGroupName and updates state',
          () async {
        const groupId = '1';
        const newName = 'New Name';
        final group = Group(id: groupId, name: newName, memberIds: ['member1', 'member2']);
        when(() => mockGroupServices.editGroupName(groupId, newName))
            .thenAnswer((_) async => [
                  group,
                  ...initialState
                      .where((group) => group.id != groupId)
                ]);

        await groupListNotifier.editGroupName(groupId, newName);

        verify(() => mockGroupServices.editGroupName(groupId, newName))
            .called(1);
        expect(groupListNotifier.state, contains(group));
      });
    });
  });
}
