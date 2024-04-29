import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/modules/groups/group_list/group_list_view_model.dart';
import 'package:qr_manager/src/common/components/custom_text.dart';
import 'package:qr_manager/src/common/components/custom_icon.dart';

class GroupListView extends ConsumerStatefulWidget {
  const GroupListView({super.key});

  @override
  ConsumerState<GroupListView> createState() {
    return _GroupListViewState();
  }
}

class _GroupListViewState extends ConsumerState<GroupListView> {
  @override
  Widget build(BuildContext context) {
    final groupData = ref.watch(Group.groupListProvider);

    Widget content = Center(
      child: CustomText.bodyLarge(
        context: context,
        text: 'No groups created yet.',
        color: Theme.of(context).colorScheme.onBackground,
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
              leading: CustomIcon.colorIcon(
                context: context,
                icon: Icons.groups,
              ),
              title: CustomText.titleLarge(
                context: context,
                text: group.name,
                color: Colors.white,
              ),
              subtitle: CustomText.titleMedium(
                context: context,
                text: group.memberIds.length > 1
                    ? '${group.memberIds.length} Members'
                    : '${group.memberIds.length} Member',
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => GroupListViewModel.navigateToModifyGroup(
                        context: context,
                        groupId: group.id,
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
                                text: 'Remove Group',
                                weight: FontWeight.bold,
                              ),
                              content: CustomText.bodyLarge(
                                context: context,
                                text:
                                    'Are you sure you want to remove ${group.name} group?',
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
                          await GroupListViewModel.removeGroup(ref, group.id);
                        }
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
              onTap: () =>
                  GroupListViewModel.navigateToMemberList(context, group.id),
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
            onPressed: () =>
                GroupListViewModel.navigateToModifyGroup(context: context),
          ),
        ],
      ),
      body: content,
    );
  }
}
