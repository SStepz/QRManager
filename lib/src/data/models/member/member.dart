import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'package:qr_manager/src/data/services/member/member_services_interface.dart';
import 'package:qr_manager/src/data/services/member/member_services.dart';
// import 'package:qr_manager/src/data/services/member/member_services_mock.dart';

part 'member.g.dart';

const uuid = Uuid();

@HiveType(typeId: 1)
class Member {
  Member({
    required this.name,
    List<QRCode>? qrCodes,
    String? id,
  })  : id = id ?? uuid.v4(),
        qrCodes = qrCodes ?? [];

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  List<QRCode> qrCodes;

  static final memberListProvider =
      StateNotifierProvider<MemberListNotifier, List<Member>>(
    (ref) => MemberListNotifier(),
  );
}

@HiveType(typeId: 2)
class QRCode {
  QRCode({
    required this.name,
    required this.accountName,
    required this.imagePath,
    String? id,
  }) : id = id ?? uuid.v4();

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String accountName;

  @HiveField(3)
  final String imagePath;

  File get image => File(imagePath);
}

class MemberListNotifier extends StateNotifier<List<Member>> {
  MemberListNotifier({MemberServicesInterface? memberServices})
      : _memberServices = memberServices ?? MemberServices(),
        super(const []) {
    _loadMembers();
  }

  final MemberServicesInterface _memberServices;

  Future<void> _loadMembers() async {
    state = await _memberServices.loadMembers();
  }

  Future<String> getMemberId(String name) async {
    return await _memberServices.getMemberId(name);
  }

  Future<void> addMember(String name) async {
    state = await _memberServices.addMember(name);
  }

  Future<void> addQR(String memberId, QRCode qrCode) async {
    state = await _memberServices.addQR(memberId, qrCode);
  }

  Future<void> removeMember(String memberId) async {
    state = await _memberServices.removeMember(memberId);
  }

  Future<void> removeQR(String memberId, String qrCodeId) async {
    state = await _memberServices.removeQR(memberId, qrCodeId);
  }

  Future<void> editMemberName(String memberId, String newMemberName) async {
    state = await _memberServices.editMemberName(memberId, newMemberName);
  }

  Future<void> editQR(String memberId, String qrId, QRCode qrCode) async {
    state = await _memberServices.editQR(memberId, qrId, qrCode);
  }
}
