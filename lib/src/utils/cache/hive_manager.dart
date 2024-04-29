import 'package:hive_flutter/hive_flutter.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/data/models/member/member.dart';

class HiveManager {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(GroupAdapter());
    Hive.registerAdapter(MemberAdapter());
    Hive.registerAdapter(QRCodeAdapter());
  }
}