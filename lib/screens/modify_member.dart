import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import 'package:qr_manager/providers/group_list.dart';
import 'package:qr_manager/providers/member_list.dart';
import 'package:qr_manager/utils/dialog.dart';

class ModifyMemberScreen extends ConsumerStatefulWidget {
  const ModifyMemberScreen({
    super.key,
    required this.groupId,
    this.memberId,
  });

  final String groupId;
  final String? memberId;

  @override
  ConsumerState<ModifyMemberScreen> createState() {
    return _ModifyMemberScreenState();
  }
}

class _ModifyMemberScreenState extends ConsumerState<ModifyMemberScreen> {
  final _nameController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.memberId != null) {
      final memberData = ref.watch(memberListProvider);
      final member =
          memberData.firstWhere((member) => member.id == widget.memberId);
      _nameController.text = member.name;
    }
  }

  void _saveMember() async {
    final enteredName = _nameController.text;

    final memberData = ref.watch(memberListProvider);
    final existingMember =
        memberData.firstWhereOrNull((member) => member.name == enteredName && member.id != widget.memberId);

    if (enteredName.isEmpty) {
      showDialogWithMessage(context, 'Invalid Input', 'Please make sure a valid name was entered.');
      return;
    }

    if (existingMember != null) {
      showDialogWithMessage(context, 'Invalid Input', 'A member with the same name already exists.');
      return;
    }

    if (widget.memberId == null) {
      final memberId = await ref.read(memberListProvider.notifier).addMember(enteredName);
      await ref
          .read(groupListProvider.notifier)
          .addMember(widget.groupId, memberId);
    } else {
      await ref
          .read(memberListProvider.notifier)
          .editMemberName(widget.memberId!, enteredName);
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
