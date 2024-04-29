import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/utils/cache/hive_manager.dart';
import 'package:qr_manager/src/common/theme/theme.dart';
import 'package:qr_manager/src/modules/groups/group_list/group_list_view.dart';

void main() async {
  await HiveManager.init();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Manager',
      theme: theme,
      home: const GroupListView(),
    );
  }
}