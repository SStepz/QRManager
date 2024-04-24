import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import 'package:qr_manager/providers/group_list.dart';
import 'package:qr_manager/utils/dialog.dart';

class ModifyGroupScreen extends ConsumerStatefulWidget {
  const ModifyGroupScreen({
    super.key,
    this.groupId,
  });

  final String? groupId;

  @override
  ConsumerState<ModifyGroupScreen> createState() {
    return _ModifyGroupScreenState();
  }
}

class _ModifyGroupScreenState extends ConsumerState<ModifyGroupScreen> {
  final _nameController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.groupId != null) {
      final groupData = ref.watch(groupListProvider);
      final group = groupData.firstWhere((group) => group.id == widget.groupId);
      _nameController.text = group.name;
    }
  }

  void _saveGroup() async {
    final enteredName = _nameController.text;

    final groupData = ref.watch(groupListProvider);
    final existingGroup =
        groupData.firstWhereOrNull((group) => group.name == enteredName && group.id != widget.groupId);

    if (enteredName.isEmpty) {
      showDialogWithMessage(context, 'Invalid Input', 'Please make sure a valid name was entered.');
      return;
    }

    if (existingGroup != null) {
      showDialogWithMessage(context, 'Invalid Input', 'A group with the same name already exists.');
      return;
    }

    if (widget.groupId == null) {
      await ref.read(groupListProvider.notifier).addGroup(enteredName);
    } else {
      await ref
          .read(groupListProvider.notifier)
          .editGroupName(widget.groupId!, enteredName);
    }

    if (mounted) {
      Navigator.of(context).pop();
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
