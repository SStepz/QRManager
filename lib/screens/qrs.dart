import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/providers/data_list.dart';
import 'package:qr_manager/screens/modify_qr.dart';
import 'package:qr_manager/screens/qr_detail.dart';

class QRsScreen extends ConsumerStatefulWidget {
  const QRsScreen({
    super.key,
    required this.groupId,
    required this.memberId,
  });

  final String groupId;
  final String memberId;

  @override
  ConsumerState<QRsScreen> createState() {
    return _QRsScreenState();
  }
}

class _QRsScreenState extends ConsumerState<QRsScreen> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(dataListProvider);
    final group = data.firstWhere((group) => group.id == widget.groupId);
    final member =
        group.members.firstWhere((member) => member.id == widget.memberId);
    final qrCodes = member.qrCodes;

    Widget content = Center(
      child: Text(
        'No QR codes created yet.',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
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
              leading: Icon(
                Icons.qr_code_rounded,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              title: Text(
                qrCode.name,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ModifyQRScreen(
                              groupId: group.id,
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
                              title: Text(
                                'Remove QR Code',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                    ),
                              ),
                              content: Text(
                                'Are you sure you want to remove ${qrCode.name} from ${member.name}?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                    ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text(
                                    'Cancel',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                ),
                                TextButton(
                                  child: Text(
                                    'Remove',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirm!) {
                          await ref
                              .read(dataListProvider.notifier)
                              .removeQR(group.id, member.id, qrCode.id);
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
                    builder: (ctx) => QRDetailScreen(
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
                  builder: (ctx) => ModifyQRScreen(
                    groupId: group.id,
                    memberId: member.id,
                  ),
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
