import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/modules/qrs/qr_detail/qr_detail_view_model.dart';
import 'package:qr_manager/src/common/components/custom_text.dart';

class QRDetailView extends ConsumerStatefulWidget {
  const QRDetailView({
    super.key,
    required this.groupId,
    required this.memberId,
    required this.qrId,
  });

  final String groupId;
  final String memberId;
  final String qrId;

  @override
  ConsumerState<QRDetailView> createState() {
    return _QRDetailViewState();
  }
}

class _QRDetailViewState extends ConsumerState<QRDetailView> {
  @override
  Widget build(BuildContext context) {
    final memberData = ref.watch(Member.memberListProvider);
    final member =
        memberData.firstWhere((member) => member.id == widget.memberId);
    final qrCodes = member.qrCodes;
    final qr = qrCodes.firstWhere((qr) => qr.id == widget.qrId);

    return Scaffold(
      appBar: AppBar(
        title: Text(qr.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => QRDetailViewModel.navigateToModifyQR(
              context,
              member.id,
              qr,
            ),
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
              child: CustomText.titleLarge(
                context: context,
                text: qr.accountName,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
