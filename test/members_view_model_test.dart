import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/modules/members/member_list/member_list_view_model.dart';
import 'package:qr_manager/src/modules/members/modify_member/modify_member_view_model.dart';

class MockWidgetRef extends Mock implements WidgetRef {}

class MockGroupNotifier extends Mock implements GroupListNotifier {}

class MockMemberNotifier extends Mock implements MemberListNotifier {}

void main() {
  group('MembersViewModel', () {
    group('MemberListViewModel', () {
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

      test('getGroup returns the correct group', () {
        final mockGroups = [
          Group(id: '1', name: 'Group 1', memberIds: ['1', '2', '3']),
          Group(id: '2', name: 'Group 2', memberIds: ['4']),
          Group(id: '3', name: 'Group 3'),
        ];
        when(() => mockRef.watch(Group.groupListProvider))
            .thenReturn(mockGroups);

        final group = MemberListViewModel.getGroup(mockRef, '1');

        expect(group, equals(mockGroups[0]));
      });

      test('getMembers returns the correct members', () {
        final mockGroups = [
          Group(
            id: '1',
            name: 'Group 1',
            memberIds: ['1', '2', '3'],
          )
        ];
        final mockMembers = [
          Member(id: '1', name: 'Member 1'),
          Member(id: '2', name: 'Member 2'),
          Member(id: '3', name: 'Member 3'),
          Member(id: '4', name: 'Member 4'),
        ];
        when(() => mockRef.watch(Group.groupListProvider))
            .thenReturn(mockGroups);
        when(() => mockRef.watch(Member.memberListProvider))
            .thenReturn(mockMembers);

        final members = MemberListViewModel.getMembers(mockRef, mockGroups[0]);

        expect(members, equals(mockMembers.sublist(0, 3)));
      });

      test('removeMember correctly removes a member from a group', () async {
        when(() => mockGroupNotifier.removeMember(any(), any()))
            .thenAnswer((_) async => {});
        when(() => mockMemberNotifier.removeMember(any()))
            .thenAnswer((_) async => {});

        await MemberListViewModel.removeMember(mockRef, '1', '1');

        verify(() => mockGroupNotifier.removeMember('1', '1')).called(1);
        verify(() => mockMemberNotifier.removeMember('1')).called(1);
      });
    });
    
    group('ModifyMemberViewModel', () {
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

      test('getMemberName returns the correct member name', () {
        final mockMembers = [
          Member(id: '1', name: 'Member 1'),
          Member(id: '2', name: 'Member 2'),
          Member(id: '3', name: 'Member 3'),
        ];
        when(() => mockRef.watch(Member.memberListProvider))
            .thenReturn(mockMembers);

        final memberName = ModifyMemberViewModel.getMemberName(mockRef, '1');

        expect(memberName, equals('Member 1'));
      });

      test('getExistingMember returns the correct member', () {
        final mockMembers = [
          Member(id: '1', name: 'Member 1'),
          Member(id: '2', name: 'Member 2'),
          Member(id: '3', name: 'Member 3'),
        ];
        when(() => mockRef.watch(Member.memberListProvider))
            .thenReturn(mockMembers);

        final member =
            ModifyMemberViewModel.getExistingMember(mockRef, 'Member 1', '2');

        expect(member, equals(mockMembers[0]));
      });

      test('saveMember correctly adds or edits a member', () async {
        when(() => mockMemberNotifier.addMember(any()))
            .thenAnswer((_) async => {});
        when(() => mockMemberNotifier.getMemberId(any()))
            .thenAnswer((_) async => '1');
        when(() => mockGroupNotifier.addMember(any(), any()))
            .thenAnswer((_) async => {});
        when(() => mockMemberNotifier.editMemberName(any(), any()))
            .thenAnswer((_) async => {});

        await ModifyMemberViewModel.saveMember(mockRef, '1', 'Member 4', null);
        await ModifyMemberViewModel.saveMember(mockRef, '1', 'Member 1', '1');

        verify(() => mockMemberNotifier.addMember('Member 4')).called(1);
        verify(() => mockMemberNotifier.getMemberId('Member 4')).called(1);
        verify(() => mockGroupNotifier.addMember('1', '1')).called(1);
        verify(() => mockMemberNotifier.editMemberName('1', 'Member 1'))
            .called(1);
      });
    });
  });
}
