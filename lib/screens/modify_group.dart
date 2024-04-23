import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/providers/data_list.dart';

class ModifyGroupScreen extends ConsumerStatefulWidget {
  const ModifyGroupScreen({
    super.key,
    this.groupId,
    this.groupName,
  });

  final String? groupId;
  final String? groupName;

  @override
  ConsumerState<ModifyGroupScreen> createState() {
    return _ModifyGroupScreenState();
  }
}

class _ModifyGroupScreenState extends ConsumerState<ModifyGroupScreen> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.groupName != null) {
      _nameController.text = widget.groupName!;
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

    if (widget.groupName == null) {
      await ref.read(dataListProvider.notifier).addGroup(enteredName);
    } else {
      await ref
          .read(dataListProvider.notifier)
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
        title: widget.groupName == null
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
              icon: widget.groupName == null
                  ? const Icon(Icons.add)
                  : const Icon(Icons.save),
              label: widget.groupName == null
                  ? const Text('Add Group')
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
