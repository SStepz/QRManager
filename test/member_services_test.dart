import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/data/services/member/member_services.dart';

class MockMemberServices extends Mock implements MemberServices {}

void main() {
  late MemberServices memberServices;

  setUp(() {
    memberServices = MockMemberServices();
  });

  group('MemberServices', () {
    final mockMembers = [
      Member(id: '1', name: 'Test 1', qrCodes: [
        QRCode(
          id: '1',
          name: 'QR1',
          accountName: 'Test1QR',
          imagePath: 'imagePath',
        )
      ]),
      Member(id: '2', name: 'Test 2', qrCodes: []),
      Member(id: '3', name: 'Test 3', qrCodes: [
        QRCode(
          id: '2',
          name: 'QR2',
          accountName: 'Test2QR',
          imagePath: 'imagePath',
        )
      ]),
    ];

    test('loadMembers return a list of members', () async {
      when(() => memberServices.loadMembers())
          .thenAnswer((_) async => mockMembers);

      final members = await memberServices.loadMembers();

      expect(members, isA<List<Member>>());
      verify(() => memberServices.loadMembers()).called(1);
    });

    test('getMemberId returns a member id', () async {
      when(() => memberServices.getMemberId('Test 1'))
          .thenAnswer((_) async => '1');

      final memberId = await memberServices.getMemberId('Test 1');

      expect(memberId, equals('1'));
      verify(() => memberServices.getMemberId('Test 1')).called(1);
    });

    test('addMember adds a member and returns updated list', () async {
      final updatedMembers = List<Member>.from(mockMembers);
      updatedMembers.add(Member(name: 'Test 4'));
      when(() => memberServices.addMember('Test 4'))
          .thenAnswer((_) async => updatedMembers);

      final members = await memberServices.addMember('Test 4');

      expect(members, anyElement((member) => member.name == 'Test 4'));
      verify(() => memberServices.addMember('Test 4')).called(1);
    });

    test('addQR adds a QR code to a member and returns updated list', () async {
      final updatedMembers = List<Member>.from(mockMembers);
      final newQR = QRCode(
        id: '3',
        name: 'QR3',
        accountName: 'Test3QR',
        imagePath: 'imagePath',
      );
      updatedMembers
          .firstWhere((member) => member.id == '1')
          .qrCodes
          .add(newQR);
      when(() => memberServices.addQR('1', newQR))
          .thenAnswer((_) async => updatedMembers);

      final members = await memberServices.addQR('1', newQR);

      expect(members.firstWhere((member) => member.id == '1').qrCodes,
          contains(newQR));
      verify(() => memberServices.addQR('1', newQR)).called(1);
    });

    test('removeMember removes a member and returns updated list', () async {
      final updatedMembers = List<Member>.from(mockMembers);
      updatedMembers.removeWhere((member) => member.id == '2');
      when(() => memberServices.removeMember('2'))
          .thenAnswer((_) async => updatedMembers);

      final members = await memberServices.removeMember('2');

      expect(
          members,
          isNot(
              contains(mockMembers.firstWhere((member) => member.id == '2'))));
      verify(() => memberServices.removeMember('2')).called(1);
    });

    test('removeQR removes a QR code from a member and returns updated list',
        () async {
      final updatedMembers = List<Member>.from(mockMembers);
      final qrToRemove = updatedMembers
          .firstWhere((member) => member.id == '1')
          .qrCodes
          .firstWhere((qr) => qr.id == '3');
      updatedMembers
          .firstWhere((member) => member.id == '1')
          .qrCodes
          .remove(qrToRemove);
      when(() => memberServices.removeQR('1', '3'))
          .thenAnswer((_) async => updatedMembers);

      final members = await memberServices.removeQR('1', '3');

      expect(members.firstWhere((member) => member.id == '1').qrCodes,
          isNot(contains(qrToRemove)));
      verify(() => memberServices.removeQR('1', '3')).called(1);
    });

    test('editMemberName edits a member name and returns updated list',
        () async {
      final updatedMembers = List<Member>.from(mockMembers);
      final oldMember = updatedMembers.firstWhere((member) => member.id == '3');
      final newMember =
          Member(id: oldMember.id, name: 'Test 5', qrCodes: oldMember.qrCodes);
      updatedMembers[updatedMembers.indexWhere((member) => member.id == '3')] =
          newMember;
      when(() => memberServices.editMemberName('3', 'Test 5'))
          .thenAnswer((_) async => updatedMembers);

      final members = await memberServices.editMemberName('3', 'Test 5');

      expect(members.firstWhere((member) => member.id == '3').name,
          equals('Test 5'));
      verify(() => memberServices.editMemberName('3', 'Test 5')).called(1);
    });

    test('editQR edits a QR code and returns updated list', () async {
      final updatedMembers = List<Member>.from(mockMembers);
      final oldQR = updatedMembers
          .firstWhere((member) => member.id == '1')
          .qrCodes
          .firstWhere((qrCode) => qrCode.id == '1');
      final newQR = QRCode(
          id: oldQR.id,
          name: 'QR4',
          accountName: 'Test4QR',
          imagePath: 'imagePath');
      updatedMembers.firstWhere((member) => member.id == '1').qrCodes[
          updatedMembers
              .firstWhere((member) => member.id == '1')
              .qrCodes
              .indexWhere((qrCode) => qrCode.id == '1')] = newQR;
      when(() => memberServices.editQR('1', '1', newQR))
          .thenAnswer((_) async => updatedMembers);

      final members = await memberServices.editQR('1', '1', newQR);

      expect(
          members
              .firstWhere((member) => member.id == '1')
              .qrCodes
              .firstWhere((qrCode) => qrCode.id == '1'),
          equals(newQR));
      verify(() => memberServices.editQR('1', '1', newQR)).called(1);
    });

    test('addMember does not add a member that already exists', () async {
      final updatedMembers = List<Member>.from(mockMembers);
      when(() => memberServices.addMember('Test 1'))
          .thenAnswer((_) async => updatedMembers);

      final members = await memberServices.addMember('Test 1');

      expect(members, hasLength(mockMembers.length));
      verify(() => memberServices.addMember('Test 1')).called(1);
    });
  });
}
