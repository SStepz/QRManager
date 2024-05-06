import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/modules/qrs/modify_qr/modify_qr_view_model.dart';
import 'package:qr_manager/src/modules/qrs/qr_detail/qr_detail_view_model.dart';
import 'package:qr_manager/src/modules/qrs/qr_list/qr_list_view_model.dart';

class MockWidgetRef extends Mock implements WidgetRef {}

class MockGroupNotifier extends Mock implements GroupListNotifier {}

class MockMemberNotifier extends Mock implements MemberListNotifier {}

void main() {
  group('QRsViewModel', () {
    group('QRListViewModel', () {
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

        final group = QRListViewModel.getGroup(mockRef, '1');

        expect(group, equals(mockGroups[0]));
      });

      test('getMember returns the correct member', () {
        final mockMembers = [
          Member(id: '1', name: 'Member 1'),
          Member(id: '2', name: 'Member 2'),
          Member(id: '3', name: 'Member 3'),
          Member(id: '4', name: 'Member 4'),
        ];
        when(() => mockRef.watch(Member.memberListProvider))
            .thenReturn(mockMembers);

        final member = QRListViewModel.getMember(mockRef, '1');

        expect(member, equals(mockMembers[0]));
      });

      test('removeQR correctly removes a QR from a member', () async {
        when(() => mockMemberNotifier.removeQR(any(), any()))
            .thenAnswer((_) async => {});

        await QRListViewModel.removeQR(mockRef, '1', '1');

        verify(() => mockMemberNotifier.removeQR('1', '1')).called(1);
      });
    });

    group('ModifyQRViewModel', () {
      late MockWidgetRef mockRef;
      late MockMemberNotifier mockMemberNotifier;

      setUp(() {
        mockRef = MockWidgetRef();
        mockMemberNotifier = MockMemberNotifier();

        registerFallbackValue(QRCode(
            id: '1', name: 'QR 1', accountName: 'Account 1', imagePath: ''));

        when(() => mockRef.read(Member.memberListProvider.notifier))
            .thenReturn(mockMemberNotifier);
      });

      test('saveQR correctly adds or edits a QR', () async {
        when(() => mockMemberNotifier.addQR(any(), any()))
            .thenAnswer((_) async => {});
        when(() => mockMemberNotifier.editQR(any(), any(), any()))
            .thenAnswer((_) async => {});

        await ModifyQRViewModel.saveQR(
            mockRef, '1', 'QR 1', 'Account 1', null, null);
        await ModifyQRViewModel.saveQR(
            mockRef,
            '1',
            'QR 2',
            'Account 2',
            null,
            QRCode(
                id: '1',
                name: 'QR 1',
                accountName: 'Account 1',
                imagePath: ''));

        verify(() => mockMemberNotifier.addQR('1', any())).called(1);
        verify(() => mockMemberNotifier.editQR('1', '1', any())).called(1);
      });
    });

    group('QRDetailViewModel', () {
      late MockWidgetRef mockRef;

      setUp(() {
        mockRef = MockWidgetRef();
      });

      test('getMember correctly retrieves a member', () {
        final members = [
          Member(id: '1', name: 'Member 1', qrCodes: []),
          Member(id: '2', name: 'Member 2', qrCodes: []),
        ];
        when(() => mockRef.watch(Member.memberListProvider)).thenReturn(members);

        final member = QRDetailViewModel.getMember(mockRef, '1');

        expect(member, equals(members[0]));
      });

      test('getQRCode correctly retrieves a QR code', () {
        final qrCodes = [
          QRCode(
              id: '1', name: 'QR 1', accountName: 'Account 1', imagePath: ''),
          QRCode(
              id: '2', name: 'QR 2', accountName: 'Account 2', imagePath: ''),
        ];
        final member = Member(id: '1', name: 'Member 1', qrCodes: qrCodes);

        final qr = QRDetailViewModel.getQRCode(member, '1');

        expect(qr, equals(qrCodes[0]));
      });
    });
  });
}
