import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/providers/group_list.dart';

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

  void _showDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Invalid input',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
        ),
        content: Text(
          'Please make sure a valid name was entered.',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: Text(
              'Okay',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveGroup() async {
    final enteredName = _nameController.text;

    if (enteredName.isEmpty) {
      _showDialog();
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
