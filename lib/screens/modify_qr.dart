import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/providers/data_list.dart';
import 'package:qr_manager/models/group.dart';
import 'package:qr_manager/widgets/image_input.dart';

class ModifyQRScreen extends ConsumerStatefulWidget {
  const ModifyQRScreen({
    super.key,
    required this.groupId,
    required this.memberId,
    this.qrCode,
  });

  final String groupId;
  final String memberId;
  final QRCode? qrCode;

  @override
  ConsumerState<ModifyQRScreen> createState() {
    return _ModifyQRScreenState();
  }
}

class _ModifyQRScreenState extends ConsumerState<ModifyQRScreen> {
  final _nameController = TextEditingController();
  final _accountNameController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.qrCode != null) {
      _nameController.text = widget.qrCode!.name;
      _accountNameController.text = widget.qrCode!.accountName;
      _selectedImage = widget.qrCode!.image;
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

  void _saveQR() async {
    final enteredName = _nameController.text;
    final enteredAccountName = _accountNameController.text;

    if (enteredName.isEmpty ||
        enteredAccountName.isEmpty ||
        _selectedImage == null) {
      _showDialog();
      return;
    }

    if (widget.qrCode == null) {
      await ref.read(dataListProvider.notifier).addQR(
          widget.groupId,
          widget.memberId,
          QRCode(
              name: enteredName,
              accountName: enteredAccountName,
              imagePath: _selectedImage!.path));
    } else {
      await ref.read(dataListProvider.notifier).editQR(
          widget.groupId,
          widget.memberId,
          widget.qrCode!.id,
          QRCode(
              id: widget.qrCode!.id,
              name: enteredName,
              accountName: enteredAccountName,
              imagePath: _selectedImage!.path));
    }

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
        title: widget.qrCode == null
            ? const Text('Add New QR Code')
            : const Text('Edit QR Code'),
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
            const SizedBox(height: 10),
            ImageInput(
              initialImage: _selectedImage,
              onPickImage: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _saveQR,
              icon: widget.qrCode == null
                  ? const Icon(Icons.add)
                  : const Icon(Icons.save),
              label: widget.qrCode == null
                  ? const Text('Add QR Code')
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
