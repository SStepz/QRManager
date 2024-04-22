import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Group {
  Group({
    required this.name,
    this.members = const [],
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String name;
  List<Member> members;
}

class Member {
  Member({
    required this.name,
    this.qrCodes = const [],
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String name;
  List<QRCode> qrCodes;
}

class QRCode {
  QRCode({
    required this.name,
    required this.accountName,
    required this.image,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String name;
  final String accountName;
  final File image;
}
