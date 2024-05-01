import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/modules/members/modify_member/modify_member_view_model.dart';
import 'package:qr_manager/src/common/components/display_dialog.dart';

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
      _nameController.text =
          ModifyMemberViewModel.getMemberName(ref, widget.memberId);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveMember() async {
    final enteredName = _nameController.text;
    final existingMember = ModifyMemberViewModel.getExistingMember(
        ref, enteredName, widget.memberId);

    if (enteredName.isEmpty) {
      DisplayDialog.showDialogWithMessage(context, 'Invalid Input',
          'Please make sure a valid name was entered.');
      return;
    }

    if (existingMember != null) {
      DisplayDialog.showDialogWithMessage(context, 'Invalid Input',
          'A member with the same name already exists.');
      return;
    }

    await ModifyMemberViewModel.saveMember(
      ref,
      widget.groupId,
      enteredName,
      widget.memberId,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
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
              onPressed: _saveMember,
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
