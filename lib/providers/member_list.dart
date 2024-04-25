import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:qr_manager/models/group.dart';
import 'package:uuid/uuid.dart';

class MemberListNotifier extends StateNotifier<List<Member>> {
  MemberListNotifier() : super(const []) {
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    final box = await Hive.openBox<Member>('members');
    state = box.values.toList();
  }

  Future<String> addMember(String name) async {
    final box = await Hive.openBox<Member>('members');
    final memberId = const Uuid().v4();
    final newMember = Member(id: memberId, name: name);
    await box.put(memberId, newMember);
    state = box.values.toList();
    return memberId;
  }

  Future<void> addQR(String memberId, QRCode qrCode) async {
    final box = await Hive.openBox<Member>('members');
    final memberIndex = box.values.toList().indexWhere((n) => n.id == memberId);
    if (memberIndex != -1) {
      final member = box.getAt(memberIndex);
      member!.qrCodes.add(qrCode);
      await box.putAt(memberIndex, member);
      state = box.values.toList();
    }
  }

  Future<void> removeMember(String memberId) async {
    final box = await Hive.openBox<Member>('members');
    final memberIndex = box.values.toList().indexWhere((n) => n.id == memberId);
    if (memberIndex != -1) {
      final member = box.getAt(memberIndex);
      member!.qrCodes.clear();
      await box.putAt(memberIndex, member);
      await box.deleteAt(memberIndex);
      state = box.values.toList();
    }
  }

  Future<void> removeQR(String memberId, String qrCodeId) async {
    final box = await Hive.openBox<Member>('members');
    final memberIndex = box.values.toList().indexWhere((n) => n.id == memberId);
    if (memberIndex != -1) {
      final member = box.getAt(memberIndex);
      final qrIndex = member!.qrCodes.indexWhere((n) => n.id == qrCodeId);
      if (qrIndex != -1) {
        member.qrCodes.removeAt(qrIndex);
        await box.putAt(memberIndex, member);
        state = box.values.toList();
      }
    }
  }

  Future<void> editMemberName(String memberId, String newMemberName) async {
    final box = await Hive.openBox<Member>('members');
    final memberIndex = box.values.toList().indexWhere((n) => n.id == memberId);
    if (memberIndex != -1) {
      final oldMember = box.getAt(memberIndex);
      final newMember = Member(id: memberId, name: newMemberName, qrCodes: oldMember!.qrCodes);
      await box.putAt(memberIndex, newMember);
      state = box.values.toList();
    }
  }

  Future<void> editQR(String memberId, String qrId, QRCode qrCode) async {
    final box = await Hive.openBox<Member>('members');
    final memberIndex = box.values.toList().indexWhere((n) => n.id == memberId);
    if (memberIndex != -1) {
      final member = box.getAt(memberIndex);
      final qrIndex = member!.qrCodes.indexWhere((n) => n.id == qrId);
      if (qrIndex != -1) {
        member.qrCodes[qrIndex] = qrCode;
        await box.putAt(memberIndex, member);
        state = box.values.toList();
      }
    }
  }
}

final memberListProvider = StateNotifierProvider<MemberListNotifier, List<Member>>(
  (ref) => MemberListNotifier(),
);
