import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/providers/data_list.dart';
import 'package:qr_manager/screens/edit_qr.dart';

class QRDetailScreen extends ConsumerStatefulWidget {
  const QRDetailScreen({
    super.key,
    required this.groupId,
    required this.memberId,
    required this.qrId,
  });

  final String groupId;
  final String memberId;
  final String qrId;

  @override
  ConsumerState<QRDetailScreen> createState() {
    return _QRDetailScreenState();
  }
}

class _QRDetailScreenState extends ConsumerState<QRDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(dataListProvider);
    final group = data.firstWhere((group) => group.id == widget.groupId);
    final member =
        group.members.firstWhere((member) => member.id == widget.memberId);
    final qrCodes = member.qrCodes;
    final qr = qrCodes.firstWhere((qr) => qr.id == widget.qrId);

    return Scaffold(
      appBar: AppBar(
        title: Text(qr.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => EditQRScreen(
                    groupId: group.id,
                    memberId: member.id,
                    qrCode: qr,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.file(
                qr.image,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Text(
                qr.accountName,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
