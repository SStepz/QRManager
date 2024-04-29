import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/data/services/member/member_services_interface.dart';

class MemberServicesMock implements MemberServicesInterface {
  List<Member> mockMember = [
    Member(
      id: '1',
      name: 'Member 1',
      qrCodes: [
        QRCode(
          id: '1',
          name: 'QR Code 1',
          accountName: 'Account 1',
          imagePath: 'assets/images/qr_code_1.png',
        ),
        QRCode(
          id: '2',
          name: 'QR Code 2',
          accountName: 'Account 2',
          imagePath: 'assets/images/qr_code_2.png',
        ),
        QRCode(
          id: '3',
          name: 'QR Code 3',
          accountName: 'Account 3',
          imagePath: 'assets/images/qr_code_3.png',
        ),
      ],
    ),
    Member(
      id: '2',
      name: 'Member 2',
      qrCodes: [
        QRCode(
          id: '4',
          name: 'QR Code 4',
          accountName: 'Account 4',
          imagePath: 'assets/images/qr_code_4.png',
        ),
        QRCode(
          id: '5',
          name: 'QR Code 5',
          accountName: 'Account 5',
          imagePath: 'assets/images/qr_code_5.png',
        ),
        QRCode(
          id: '6',
          name: 'QR Code 6',
          accountName: 'Account 6',
          imagePath: 'assets/images/qr_code_6.png',
        ),
      ],
    ),
    Member(
      id: '3',
      name: 'Member 3',
      qrCodes: [
        QRCode(
          id: '7',
          name: 'QR Code 7',
          accountName: 'Account 7',
          imagePath: 'assets/images/qr_code_7.png',
        ),
        QRCode(
          id: '8',
          name: 'QR Code 8',
          accountName: 'Account 8',
          imagePath: 'assets/images/qr_code_8.png',
        ),
        QRCode(
          id: '9',
          name: 'QR Code 9',
          accountName: 'Account 9',
          imagePath: 'assets/images/qr_code_9.png',
        ),
      ],
    ),
  ];

  @override
  Future<List<Member>> loadMembers() async {
    return mockMember;
  }

  @override
  Future<String> getMemberId(String name) async {
    return mockMember.firstWhere((member) => member.name == name).id;
  }

  @override
  Future<List<Member>> addMember(String name) async {
    return mockMember;
  }

  @override
  Future<List<Member>> addQR(String memberId, QRCode qrCode) async {
    return mockMember;
  }

  @override
  Future<List<Member>> removeMember(String memberId) async {
    return mockMember;
  }

  @override
  Future<List<Member>> removeQR(String memberId, String qrCodeId) async {
    return mockMember;
  }

  @override
  Future<List<Member>> editMemberName(String memberId, String newMemberName) async {
    return mockMember;
  }

  @override
  Future<List<Member>> editQR(String memberId, String qrId, QRCode qrCode) async {
    return mockMember;
  }
}
