import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/modules/members/modify_member/modify_member_view_model.dart';

class ModifyMemberView extends ConsumerStatefulWidget {
  const ModifyMemberView({
    super.key,
    required this.groupId,
    this.memberId,
  });

  final String groupId;
  final String? memberId;

  @override
  ConsumerState<ModifyMemberView> createState() {
    return _ModifyMemberViewState();
  }
}

class _ModifyMemberViewState extends ConsumerState<ModifyMemberView> {
  final _nameController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.memberId != null) {
      final memberData = ref.watch(Member.memberListProvider);
      final member =
          memberData.firstWhere((member) => member.id == widget.memberId);
      _nameController.text = member.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.memberId == null
            ? const Text('Add New Member')
            : const Text('Edit Member'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Member Name',
              ),
              maxLength: 20,
              controller: _nameController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                await ModifyMemberViewModel.saveMember(
                  ref,
                  context,
                  widget.groupId,
                  _nameController.text,
                  widget.memberId,
                  () {
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                );
              },
              icon: widget.memberId == null
                  ? const Icon(Icons.add)
                  : const Icon(Icons.save),
              label: widget.memberId == null
                  ? const Text('Add Member')
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
