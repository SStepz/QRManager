import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/providers/group_list.dart';
import 'package:qr_manager/providers/member_list.dart';
import 'package:qr_manager/screens/modify_member.dart';
import 'package:qr_manager/screens/qrs.dart';

class MembersScreen extends ConsumerStatefulWidget {
  const MembersScreen({
    super.key,
    required this.groupId,
  });

  final String groupId;

  @override
  ConsumerState<MembersScreen> createState() {
    return _MembersScreenState();
  }
}

class _MembersScreenState extends ConsumerState<MembersScreen> {
  @override
  Widget build(BuildContext context) {
    final groupData = ref.watch(groupListProvider);
    final memberData = ref.watch(memberListProvider);
    final group = groupData.firstWhere((group) => group.id == widget.groupId);
    final members = memberData
        .where((member) => group.memberIds.contains(member.id))
        .toList();

    Widget content = Center(
      child: Text(
        'No members created yet.',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ),
    );

    if (members.isNotEmpty) {
      content = ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              leading: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              title: Text(
                member.name,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
              subtitle: Text(
                member.qrCodes.length > 1
                    ? '${member.qrCodes.length} QR Codes'
                    : '${member.qrCodes.length} QR Code',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
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
                            builder: (ctx) => ModifyMemberScreen(
                              groupId: group.id,
                              memberId: member.id,
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
                                'Remove Member',
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
                                'Are you sure you want to remove ${member.name} from ${group.name} group?',
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
                              .read(groupListProvider.notifier)
                              .removeMember(group.id, member.id);
                          await ref
                              .read(memberListProvider.notifier)
                              .removeMember(member.id);
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
                    builder: (ctx) => QRsScreen(
                      groupId: group.id,
                      memberId: member.id,
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
        title: Text(group.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ModifyMemberScreen(groupId: group.id),
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
