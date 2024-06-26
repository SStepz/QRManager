import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/modules/qrs/modify_qr/modify_qr_view.dart';
import 'package:qr_manager/src/modules/qrs/qr_detail/qr_detail_view.dart';
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
    final group = QRListViewModel.getGroup(ref, widget.groupId);
    final member = QRListViewModel.getMember(ref, widget.memberId);
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
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ModifyQRView(
                              memberId: member.id,
                              qrCode: qrCode,
                            ),
                          ),
                        );
                      },
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
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => QRDetailView(
                      groupId: group.id,
                      memberId: member.id,
                      qrId: qrCode.id,
                    ),
                  ),
                );
              },
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
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ModifyQRView(memberId: member.id),
                ),
              );
            },
          ),
        ],
      ),
      body: content,
    );
  }
}
