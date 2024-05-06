import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/modules/groups/group_list/group_list_view_model.dart';
import 'package:qr_manager/src/modules/groups/modify_group/modify_group_view_model.dart';

class MockWidgetRef extends Mock implements WidgetRef {}

class MockGroupNotifier extends Mock implements GroupListNotifier {}

class MockMemberNotifier extends Mock implements MemberListNotifier {}

void main() {
  group('GroupsViewModel', () {
    group('GroupListViewModel', () {
      late MockWidgetRef mockRef;
      late MockGroupNotifier mockGroupNotifier;
      late MockMemberNotifier mockMemberNotifier;

      setUp(() {
        mockRef = MockWidgetRef();
        mockGroupNotifier = MockGroupNotifier();
        mockMemberNotifier = MockMemberNotifier();

        when(() => mockRef.read(Group.groupListProvider.notifier))
            .thenReturn(mockGroupNotifier);
        when(() => mockRef.read(Member.memberListProvider.notifier))
            .thenReturn(mockMemberNotifier);
      });

      test('removeGroup removes the group and its members', () async {
        const groupId = '1';
        final memberIds = ['1', '2', '3'];
        when(() => mockGroupNotifier.getMemberIds(groupId))
            .thenAnswer((_) async => memberIds);
        when(() => mockGroupNotifier.removeGroup(groupId))
            .thenAnswer((_) async => {});
        when<dynamic>(() => mockMemberNotifier.removeMember(any()))
            .thenAnswer((_) async => {});

        await GroupListViewModel.removeGroup(mockRef, groupId);

        verify(() => mockGroupNotifier.getMemberIds(groupId)).called(1);
        verify(() => mockGroupNotifier.removeGroup(groupId)).called(1);
        verify(() => mockMemberNotifier.removeMember(any()))
            .called(memberIds.length);
      });
    });
    
    group('ModifyGroupViewModel', () {
      late MockWidgetRef mockRef;
      late MockGroupNotifier mockGroupNotifier;

      setUp(() {
        mockRef = MockWidgetRef();
        mockGroupNotifier = MockGroupNotifier();

        when(() => mockRef.read(Group.groupListProvider.notifier))
            .thenReturn(mockGroupNotifier);
      });

      test('getGroupName returns the correct group name', () {
        final mockGroups = [
          Group(id: '1', name: 'Group 1', memberIds: ['1', '2', '3']),
          Group(id: '2', name: 'Group 2', memberIds: ['4']),
          Group(id: '3', name: 'Group 3'),
        ];
        when(() => mockRef.watch(Group.groupListProvider))
            .thenReturn(mockGroups);

        final groupName = ModifyGroupViewModel.getGroupName(mockRef, '1');

        expect(groupName, equals('Group 1'));
      });

      test('getExistingGroup returns the correct group', () {
        final mockGroups = [
          Group(id: '1', name: 'Group 1', memberIds: ['1', '2', '3']),
          Group(id: '2', name: 'Group 2', memberIds: ['4']),
          Group(id: '3', name: 'Group 3'),
        ];
        when(() => mockRef.watch(Group.groupListProvider))
            .thenReturn(mockGroups);

        final group =
            ModifyGroupViewModel.getExistingGroup(mockRef, 'Group 1', '2');

        expect(group, equals(mockGroups[0]));
      });

      test('saveGroup correctly adds or edits a group', () async {
        when(() => mockGroupNotifier.addGroup(any()))
            .thenAnswer((_) async => {});
        when(() => mockGroupNotifier.editGroupName(any(), any()))
            .thenAnswer((_) async => {});

        await ModifyGroupViewModel.saveGroup(mockRef, 'Group 4', null);
        await ModifyGroupViewModel.saveGroup(mockRef, 'Group 1', '1');

        verify(() => mockGroupNotifier.addGroup('Group 4')).called(1);
        verify(() => mockGroupNotifier.editGroupName('1', 'Group 1')).called(1);
      });
    });
  });
}
