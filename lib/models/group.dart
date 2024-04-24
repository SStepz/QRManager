import 'dart:io';

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'group.g.dart';

const uuid = Uuid();

@HiveType(typeId: 0)
class Group {
  Group({
    required this.name,
    List<String>? memberIds,
    String? id,
  })  : id = id ?? uuid.v4(),
        memberIds = memberIds ?? [];

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  List<String> memberIds;
}

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
