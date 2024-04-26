import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/modules/members/member_list/member_list_view_model.dart';
import 'package:qr_manager/src/common/components/custom_text.dart';
import 'package:qr_manager/src/common/components/custom_icon.dart';

class MemberListView extends ConsumerStatefulWidget {
  const MemberListView({
    super.key,
    required this.groupId,
  });

  final String groupId;

  @override
  ConsumerState<MemberListView> createState() {
    return _MemberListViewState();
  }
}

class _MemberListViewState extends ConsumerState<MemberListView> {
  @override
  Widget build(BuildContext context) {
    final groupData = ref.watch(Group.groupListProvider);
    final memberData = ref.watch(Member.memberListProvider);
    final group = groupData.firstWhere((group) => group.id == widget.groupId);
    final members = memberData
        .where((member) => group.memberIds.contains(member.id))
        .toList();

    Widget content = Center(
      child: CustomText.bodyLarge(
        context: context,
        text: 'No members created yet.',
        color: Theme.of(context).colorScheme.onBackground,
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
              leading: CustomIcon.colorIcon(
                context: context,
                icon: Icons.person,
              ),
              title: CustomText.titleLarge(
                context: context,
                text: member.name,
                color: Colors.white,
              ),
              subtitle: CustomText.titleMedium(
                context: context,
                text: member.qrCodes.length > 1
                    ? '${member.qrCodes.length} QR Codes'
                    : '${member.qrCodes.length} QR Code',
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () =>
                          MemberListViewModel.navigateToModifyMember(
                        context: context,
                        groupId: group.id,
                        memberId: member.id,
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
                                text: 'Remove Member',
                                weight: FontWeight.bold,
                              ),
                              content: CustomText.bodyLarge(
                                context: context,
                                text:
                                    'Are you sure you want to remove ${member.name} from ${group.name} group?',
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
                          await MemberListViewModel.removeMember(
                            ref,
                            group.id,
                            member.id,
                          );
                        }
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
              onTap: () => MemberListViewModel.navigateToQRList(
                context,
                group.id,
                member.id,
              ),
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
            onPressed: () => MemberListViewModel.navigateToModifyMember(
              context: context,
              groupId: group.id,
            ),
          ),
        ],
      ),
      body: content,
    );
  }
}
