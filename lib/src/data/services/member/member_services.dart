import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/common/constants/hivebox_name.dart';
import 'package:qr_manager/src/data/services/member/member_services_interface.dart';

class MemberServices implements MemberServicesInterface {
  final String _memberBox = HiveBoxName().memberBox;

  @override
  Future<List<Member>> loadMembers() async {
    final box = await Hive.openBox<Member>(_memberBox);
    return box.values.toList();
  }

  @override
  Future<String> getMemberId(String name) async {
    final box = await Hive.openBox<Member>(_memberBox);
    final memberIndex = box.values.toList().indexWhere((n) => n.name == name);
    if (memberIndex != -1) {
      final memberId = box.getAt(memberIndex)!.id;
      return memberId;
    }
    return '';
  }

  @override
  Future<List<Member>> addMember(String name) async {
    final box = await Hive.openBox<Member>(_memberBox);
    final memberId = const Uuid().v4();
    final newMember = Member(id: memberId, name: name);
    await box.put(memberId, newMember);
    return box.values.toList();
  }

  @override
  Future<List<Member>> addQR(String memberId, QRCode qrCode) async {
    final box = await Hive.openBox<Member>(_memberBox);
    final memberIndex = box.values.toList().indexWhere((n) => n.id == memberId);
    if (memberIndex != -1) {
      final member = box.getAt(memberIndex);
      member!.qrCodes.add(qrCode);
      await box.putAt(memberIndex, member);
      return box.values.toList();
    }
    return [];
  }

  @override
  Future<List<Member>> removeMember(String memberId) async {
    final box = await Hive.openBox<Member>(_memberBox);
    final memberIndex = box.values.toList().indexWhere((n) => n.id == memberId);
    if (memberIndex != -1) {
      final member = box.getAt(memberIndex);
      member!.qrCodes.clear();
      await box.putAt(memberIndex, member);
      await box.deleteAt(memberIndex);
      return box.values.toList();
    }
    return [];
  }

  @override
  Future<List<Member>> removeQR(String memberId, String qrCodeId) async {
    final box = await Hive.openBox<Member>(_memberBox);
    final memberIndex = box.values.toList().indexWhere((n) => n.id == memberId);
    if (memberIndex != -1) {
      final member = box.getAt(memberIndex);
      final qrIndex = member!.qrCodes.indexWhere((n) => n.id == qrCodeId);
      if (qrIndex != -1) {
        member.qrCodes.removeAt(qrIndex);
        await box.putAt(memberIndex, member);
        return box.values.toList();
      }
    }
    return [];
  }

  @override
  Future<List<Member>> editMemberName(String memberId, String newMemberName) async {
    final box = await Hive.openBox<Member>(_memberBox);
    final memberIndex = box.values.toList().indexWhere((n) => n.id == memberId);
    if (memberIndex != -1) {
      final oldMember = box.getAt(memberIndex);
      final newMember = Member(id: memberId, name: newMemberName, qrCodes: oldMember!.qrCodes);
      await box.putAt(memberIndex, newMember);
      return box.values.toList();
    }
    return [];
  }

  @override
  Future<List<Member>> editQR(String memberId, String qrId, QRCode qrCode) async {
    final box = await Hive.openBox<Member>(_memberBox);
    final memberIndex = box.values.toList().indexWhere((n) => n.id == memberId);
    if (memberIndex != -1) {
      final member = box.getAt(memberIndex);
      final qrIndex = member!.qrCodes.indexWhere((n) => n.id == qrId);
      if (qrIndex != -1) {
        member.qrCodes[qrIndex] = qrCode;
        await box.putAt(memberIndex, member);
        return box.values.toList();
      }
    }
    return [];
  }
}