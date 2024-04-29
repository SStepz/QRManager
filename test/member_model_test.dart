import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/data/services/member/member_services_interface.dart';

class MockMemberServices extends Mock implements MemberServicesInterface {}

void main() {
  group('Members', () {
    test('should create Member with default values for id and qrCodes', () {
      final member = Member(name: 'Test Member');

      expect(member.id, isNotNull);
      expect(member.qrCodes, isEmpty);
    });

    test('should create Member with provided values for id and qrCodes', () {
      final member = Member(
        name: 'Test Member',
        id: 'test-id',
        qrCodes: [
          QRCode(
            id: 'test-id',
            name: 'Test QR Code',
            accountName: 'Test Account',
            imagePath: 'test-image-path',
          ),
        ],
      );

      expect(member.id, equals('test-id'));
      expect(member.qrCodes, hasLength(1));
      expect(member.qrCodes.first.id, equals('test-id'));
      expect(member.qrCodes.first.name, equals('Test QR Code'));
      expect(member.qrCodes.first.accountName, equals('Test Account'));
      expect(member.qrCodes.first.imagePath, equals('test-image-path'));
    });

    group('MemberListNotifier', () {
      late MockMemberServices mockMemberServices;
      late MemberListNotifier memberListNotifier;
      late List<Member> initialState;

      setUp(() {
        mockMemberServices = MockMemberServices();
        when(() => mockMemberServices.loadMembers())
            .thenAnswer((_) async => <Member>[]);
        memberListNotifier =
            MemberListNotifier(memberServices: mockMemberServices);
        initialState = [
          Member(id: '1', name: 'First', qrCodes: [
            QRCode(
              id: '1',
              name: 'QR1',
              accountName: 'Account1',
              imagePath: 'imagePath',
            ),
          ]),
        ];
        memberListNotifier.state = initialState;
      });

      test('getMemberId calls MemberServices.getMemberId', () async {
        const name = 'First';
        final member = initialState.firstWhere((member) => member.name == name);
        when(() => mockMemberServices.getMemberId(name))
            .thenAnswer((_) async => member.id);

        final memberId = await memberListNotifier.getMemberId(name);

        verify(() => mockMemberServices.getMemberId(name)).called(1);
        expect(memberId, equals(member.id));
      });

      test('addMember calls MemberServices.addMember and updates state',
          () async {
        final member = Member(name: 'Test Member');
        when(() => mockMemberServices.addMember('Test Member'))
            .thenAnswer((_) async => [member, ...initialState]);

        await memberListNotifier.addMember('Test Member');

        verify(() => mockMemberServices.addMember('Test Member')).called(1);
        expect(memberListNotifier.state, contains(member));
      });

      test('addQR calls MemberServices.addQR and updates state', () async {
        const memberId = '1';
        final qrCode = QRCode(
          id: '2',
          name: 'QR2',
          accountName: 'Account2',
          imagePath: 'imagePath',
        );
        final member = Member(id: memberId, name: 'First', qrCodes: [
          QRCode(
            id: '1',
            name: 'QR1',
            accountName: 'Account1',
            imagePath: 'imagePath',
          ),
          qrCode,
        ]);
        when(() => mockMemberServices.addQR(memberId, qrCode)).thenAnswer(
            (_) async => [
                  member,
                  ...initialState.where((member) => member.id != memberId)
                ]);

        await memberListNotifier.addQR(memberId, qrCode);

        verify(() => mockMemberServices.addQR(memberId, qrCode)).called(1);
        expect(memberListNotifier.state, contains(member));
      });

      test('removeMember calls MemberServices.removeMember and updates state',
          () async {
        const memberId = '1';
        final member =
            initialState.firstWhere((member) => member.id == memberId);
        when(() => mockMemberServices.removeMember(memberId)).thenAnswer(
            (_) async =>
                initialState.where((member) => member.id != memberId).toList());

        await memberListNotifier.removeMember(memberId);

        verify(() => mockMemberServices.removeMember(memberId)).called(1);
        expect(memberListNotifier.state, isNot(contains(member)));
      });

      test('removeQR calls MemberServices.removeQR and updates state',
          () async {
        const memberId = '1';
        const qrCodeId = '1';
        final member = Member(id: memberId, name: 'First', qrCodes: []);
        when(() => mockMemberServices.removeQR(memberId, qrCodeId)).thenAnswer(
            (_) async => [
                  member,
                  ...initialState.where((member) => member.id != memberId)
                ]);

        await memberListNotifier.removeQR(memberId, qrCodeId);

        verify(() => mockMemberServices.removeQR(memberId, qrCodeId)).called(1);
        expect(memberListNotifier.state, contains(member));
      });

      test(
          'editMemberName calls MemberServices.editMemberName and updates state',
          () async {
        const memberId = '1';
        const newName = 'New Name';
        final member = Member(id: memberId, name: newName, qrCodes: [
          QRCode(
            id: '1',
            name: 'QR1',
            accountName: 'Account1',
            imagePath: 'imagePath',
          ),
        ]);
        when(() => mockMemberServices.editMemberName(memberId, newName))
            .thenAnswer((_) async => [
                  member,
                  ...initialState.where((member) => member.id != memberId)
                ]);

        await memberListNotifier.editMemberName(memberId, newName);

        verify(() => mockMemberServices.editMemberName(memberId, newName))
            .called(1);
        expect(memberListNotifier.state, contains(member));
      });

      test('editQR calls MemberServices.editQR and updates state', () async {
        const memberId = '1';
        const qrId = '1';
        final qrCode = QRCode(
          id: qrId,
          name: 'QR3',
          accountName: 'Account3',
          imagePath: 'imagePath',
        );
        final member = Member(id: memberId, name: 'First', qrCodes: [qrCode]);
        when(() => mockMemberServices.editQR(memberId, qrId, qrCode))
            .thenAnswer((_) async => [
                  member,
                  ...initialState.where((member) => member.id != memberId)
                ]);

        await memberListNotifier.editQR(memberId, qrId, qrCode);

        verify(() => mockMemberServices.editQR(memberId, qrId, qrCode))
            .called(1);
        expect(memberListNotifier.state, contains(member));
      });
    });
  });
}
