import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/providers/data_list.dart';
import 'package:qr_manager/models/group.dart';
import 'package:qr_manager/widgets/image_input.dart';

class EditQRScreen extends ConsumerStatefulWidget {
  const EditQRScreen({
    super.key,
    required this.groupId,
    required this.memberId,
    required this.qrCode,
  });

  final String groupId;
  final String memberId;
  final QRCode qrCode;

  @override
  ConsumerState<EditQRScreen> createState() {
    return _EditQRScreenState();
  }
}

class _EditQRScreenState extends ConsumerState<EditQRScreen> {
  final _nameController = TextEditingController();
  final _accountNameController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.qrCode.name;
    _accountNameController.text = widget.qrCode.accountName;
    _selectedImage = widget.qrCode.image;
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
          'Please make sure every field is valid.',
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

  void _saveQR() {
    final enteredName = _nameController.text;
    final enteredAccountName = _accountNameController.text;

    if (enteredName.isEmpty || enteredAccountName.isEmpty || _selectedImage == null) {
      _showDialog();
      return;
    }

    ref.read(dataListProvider.notifier).editQR(
        widget.groupId,
        widget.memberId,
        widget.qrCode.id,
        QRCode(
            id: widget.qrCode.id,
            name: enteredName,
            accountName: enteredAccountName,
            image: _selectedImage!));

    Navigator.of(context).pop();
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
        title: const Text('Edit QR Code'),
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
              initialImage: _selectedImage,
              onPickImage: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _saveQR,
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
