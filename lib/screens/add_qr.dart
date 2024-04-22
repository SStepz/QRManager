import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/models/group.dart';
import 'package:qr_manager/providers/data_list.dart';
import 'package:qr_manager/widgets/image_input.dart';

class AddQRScreen extends ConsumerStatefulWidget {
  const AddQRScreen({
    super.key,
    required this.groupId,
    required this.memberId,
  });

  final String groupId;
  final String memberId;

  @override
  ConsumerState<AddQRScreen> createState() {
    return _AddQRScreenState();
  }
}

class _AddQRScreenState extends ConsumerState<AddQRScreen> {
  final _nameController = TextEditingController();
  final _accountNameController = TextEditingController();
  File? _selectedImage;

  void _showDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Invalid input',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
        ),
        content: Text(
          'Please make sure every field is valid.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
        ),
        actions: [
          Center(
            child: TextButton(
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
          ),
        ],
      ),
    );
  }

  void _saveMember() async {
    final enteredName = _nameController.text;
    final enteredAccountName = _accountNameController.text;

    if (enteredName.isEmpty ||
        enteredAccountName.isEmpty ||
        _selectedImage == null) {
      _showDialog();
      return;
    }

    await ref.read(dataListProvider.notifier).addQR(
        widget.groupId,
        widget.memberId,
        QRCode(
            name: enteredName,
            accountName: enteredAccountName,
            imagePath: _selectedImage!.path));

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New QR Code'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'QR Code Name',
              ),
              maxLength: 20,
              controller: _nameController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Account Name',
              ),
              maxLength: 50,
              controller: _accountNameController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            ImageInput(
              onPickImage: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _saveMember,
              icon: const Icon(Icons.add),
              label: const Text('Add QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
