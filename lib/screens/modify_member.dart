import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/providers/data_list.dart';

class ModifyMemberScreen extends ConsumerStatefulWidget {
  const ModifyMemberScreen({
    super.key,
    required this.groupId,
    this.memberId,
    this.memberName,
  });

  final String groupId;
  final String? memberId;
  final String? memberName;

  @override
  ConsumerState<ModifyMemberScreen> createState() {
    return _ModifyMemberScreenState();
  }
}

class _ModifyMemberScreenState extends ConsumerState<ModifyMemberScreen> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.memberName != null) {
      _nameController.text = widget.memberName!;
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

  void _saveMember() async {
    final enteredName = _nameController.text;

    if (enteredName.isEmpty) {
      _showDialog();
      return;
    }

    if (widget.memberName == null) {
      await ref
          .read(dataListProvider.notifier)
          .addMember(widget.groupId, enteredName);
    } else {
      await ref
          .read(dataListProvider.notifier)
          .editMemberName(widget.groupId, widget.memberId!, enteredName);
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
        title: widget.memberName == null
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
              icon: widget.memberName == null
                  ? const Icon(Icons.add)
                  : const Icon(Icons.save),
              label: widget.memberName == null
                  ? const Text('Add Member')
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
