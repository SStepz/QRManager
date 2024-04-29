import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/modules/qrs/qr_list/qr_list_view_model.dart';
import 'package:qr_manager/src/common/components/custom_text.dart';
import 'package:qr_manager/src/common/components/custom_icon.dart';

class QRListView extends ConsumerStatefulWidget {
  const QRListView({
    super.key,
    required this.groupId,
    required this.memberId,
  });

  final String groupId;
  final String memberId;

  @override
  ConsumerState<QRListView> createState() {
    return _QRListViewState();
  }
}

class _QRListViewState extends ConsumerState<QRListView> {
  @override
  Widget build(BuildContext context) {
    final groupData = ref.watch(Group.groupListProvider);
    final memberData = ref.watch(Member.memberListProvider);
    final group = groupData.firstWhere((group) => group.id == widget.groupId);
    final member =
        memberData.firstWhere((member) => member.id == widget.memberId);
    final qrCodes = member.qrCodes;

    Widget content = Center(
      child: CustomText.bodyLarge(
        context: context,
        text: 'No QR codes created yet.',
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );

    if (qrCodes.isNotEmpty) {
      content = ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: qrCodes.length,
        itemBuilder: (context, index) {
          final qrCode = qrCodes[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              leading: CustomIcon.colorIcon(
                context: context,
                icon: Icons.qr_code_rounded,
              ),
              title: CustomText.titleLarge(
                context: context,
                text: qrCode.name,
                color: Colors.white,
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => QRListViewModel.navigateToModifyQR(
                        context: context,
                        memberId: member.id,
                        qrCode: qrCode,
                      ),
                      icon: const Icon(Icons.edit),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: CustomText.titleLarge(
                                context: context,
                                text: 'Remove QR Code',
                                weight: FontWeight.bold,
                              ),
                              content: CustomText.bodyLarge(
                                context: context,
                                text:
                                    'Are you sure you want to remove ${qrCode.name} from ${member.name}?',
                              ),
                              actions: [
                                TextButton(
                                  child: CustomText.bodyLarge(
                                    context: context,
                                    text: 'Cancel',
                                    weight: FontWeight.bold,
                                  ),
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                ),
                                TextButton(
                                  child: CustomText.bodyLarge(
                                    context: context,
                                    text: 'Remove',
                                    weight: FontWeight.bold,
                                  ),
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirm!) {
                          QRListViewModel.removeQR(
                            ref,
                            member.id,
                            qrCode.id,
                          );
                        }
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
              onTap: () => QRListViewModel.navigateToQRDetail(
                context,
                group.id,
                member.id,
                qrCode.id,
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(member.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => QRListViewModel.navigateToModifyQR(
              context: context,
              memberId: member.id,
            ),
          ),
        ],
      ),
      body: content,
    );
  }
}
