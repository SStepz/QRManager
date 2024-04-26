import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/modules/groups/modify_group/modify_group_view_model.dart';

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
      final groupData = ref.watch(Group.groupListProvider);
      final group = groupData.firstWhere((group) => group.id == widget.groupId);
      _nameController.text = group.name;
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
              onPressed: () async {
                await ModifyGroupViewModel.saveGroup(
                  ref,
                  context,
                  _nameController.text,
                  widget.groupId,
                  () {
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                );
              },
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
