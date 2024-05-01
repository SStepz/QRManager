import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/modules/groups/modify_group/modify_group_view_model.dart';
import 'package:qr_manager/src/common/components/display_dialog.dart';

class ModifyGroupView extends ConsumerStatefulWidget {
  const ModifyGroupView({
    super.key,
    this.groupId,
  });

  final String? groupId;

  @override
  ConsumerState<ModifyGroupView> createState() {
    return _ModifyGroupViewState();
  }
}

class _ModifyGroupViewState extends ConsumerState<ModifyGroupView> {
  final _nameController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.groupId != null) {
      _nameController.text =
          ModifyGroupViewModel.getGroupName(ref, widget.groupId);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveGroup() async {
    final enteredName = _nameController.text;
    final existingGroup =
        ModifyGroupViewModel.getExistingGroup(ref, enteredName, widget.groupId);

    if (enteredName.isEmpty) {
      DisplayDialog.showDialogWithMessage(context, 'Invalid Input',
          'Please make sure a valid name was entered.');
      return;
    }

    if (existingGroup != null) {
      DisplayDialog.showDialogWithMessage(context, 'Invalid Input',
          'A group with the same name already exists.');
      return;
    }

    await ModifyGroupViewModel.saveGroup(ref, enteredName, widget.groupId);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.groupId == null
            ? const Text('Add New Group')
            : const Text('Edit Group'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Group Name',
              ),
              maxLength: 20,
              controller: _nameController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _saveGroup,
              icon: widget.groupId == null
                  ? const Icon(Icons.add)
                  : const Icon(Icons.save),
              label: widget.groupId == null
                  ? const Text('Add Group')
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
