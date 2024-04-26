import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:qr_manager/src/modules/image_input/image_input_view_model.dart';

class ImageInputView extends StatefulWidget {
  const ImageInputView({
    super.key,
    this.initialImage,
    required this.onPickImage,
  });

  final File? initialImage;
  final void Function(File image) onPickImage;

  @override
  State<ImageInputView> createState() {
    return _ImageInputViewState();
  }
}

class _ImageInputViewState extends State<ImageInputView> {
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (_selectedImage != null)
          Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.black.withOpacity(0.7),
                ),
                child: TextButton.icon(
                  icon: const Icon(Icons.camera),
                  label: const Text('Take Picture'),
                  onPressed: () async {
                    _selectedImage = await ImageInputViewModel.chooseImage(
                      ImageSource.camera,
                    );
                    setState(() {});
                    widget.onPickImage(_selectedImage!);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.black.withOpacity(0.7),
                ),
                child: TextButton.icon(
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Choose From Gallery'),
                  onPressed: () async {
                    _selectedImage = await ImageInputViewModel.chooseImage(
                      ImageSource.gallery,
                    );
                    setState(() {});
                    widget.onPickImage(_selectedImage!);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
        ),
      ),
      height: 300,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
