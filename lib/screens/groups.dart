import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/providers/group_list.dart';
import 'package:qr_manager/providers/member_list.dart';
import 'package:qr_manager/screens/modify_group.dart';
import 'package:qr_manager/screens/members.dart';

class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});

  @override
  ConsumerState<GroupsScreen> createState() {
    return _GroupsScreenState();
  }
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    final groupData = ref.watch(groupListProvider);

    Widget content = Center(
      child: Text(
        'No groups created yet.',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ),
    );

    if (groupData.isNotEmpty) {
      content = ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: groupData.length,
        itemBuilder: (context, index) {
          final group = groupData[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              leading: Icon(
                Icons.groups,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              title: Text(
                group.name,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
              subtitle: Text(
                group.memberIds.length > 1
                    ? '${group.memberIds.length} Members'
                    : '${group.memberIds.length} Member',
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
                            builder: (ctx) =>
                                ModifyGroupScreen(groupId: group.id),
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
                                'Remove Group',
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
                                'Are you sure you want to remove ${group.name} group?',
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
                          List<String> memberIds = await ref
                              .read(groupListProvider.notifier)
                              .removeGroup(group.id);
                          for (var memberId in memberIds) {
                            await ref
                                .read(memberListProvider.notifier)
                                .removeMember(memberId);
                          }
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
                    builder: (ctx) => MembersScreen(groupId: group.id),
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
        title: const Text('Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const ModifyGroupScreen(),
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
