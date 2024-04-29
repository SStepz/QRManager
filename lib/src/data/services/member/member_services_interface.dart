import 'package:qr_manager/src/data/models/member/member.dart';

abstract class MemberServicesInterface {
  Future<List<Member>> loadMembers();
  Future<String> getMemberId(String name);
  Future<List<Member>> addMember(String name);
  Future<List<Member>> addQR(String memberId, QRCode qrCode);
  Future<List<Member>> removeMember(String memberId);
  Future<List<Member>> removeQR(String memberId, String qrCodeId);
  Future<List<Member>> editMemberName(String memberId, String newMemberName);
  Future<List<Member>> editQR(String memberId, String qrId, QRCode qrCode);
}