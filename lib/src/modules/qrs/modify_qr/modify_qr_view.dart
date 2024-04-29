import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/src/data/models/member/member.dart';
import 'package:qr_manager/src/modules/image_input/image_input_view.dart';
import 'package:qr_manager/src/modules/qrs/modify_qr/modify_qr_view_model.dart';

class ModifyQRView extends ConsumerStatefulWidget {
  const ModifyQRView({
    super.key,
    required this.memberId,
    this.qrCode,
  });

  final String memberId;
  final QRCode? qrCode;

  @override
  ConsumerState<ModifyQRView> createState() {
    return _ModifyQRViewState();
  }
}

class _ModifyQRViewState extends ConsumerState<ModifyQRView> {
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
            ImageInputView(
              initialImage: _selectedImage,
              onPickImage: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                await ModifyQRViewModel.saveQR(
                  ref,
                  context,
                  widget.memberId,
                  _nameController.text,
                  _accountNameController.text,
                  _selectedImage,
                  widget.qrCode,
                  () {
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                );
              },
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
