import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    this.initialImage,
    required this.onPickImage,
  });

  final File? initialImage;
  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  void _chooseImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: source,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    // Widget content = TextButton.icon(
    //   icon: const Icon(Icons.camera),
    //   label: const Text('Take Picture'),
    //   onPressed: () => _chooseImage(ImageSource.camera),
    // );

    // if (_selectedImage != null) {
    //   content = GestureDetector(
    //     onTap: () => _chooseImage(ImageSource.camera),
    //     child: Image.file(
    //       _selectedImage!,
    //       fit: BoxFit.cover,
    //       width: double.infinity,
    //       height: double.infinity,
    //     ),
    //   );
    // }

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
                  onPressed: () => _chooseImage(ImageSource.camera),
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
                  onPressed: () => _chooseImage(ImageSource.gallery),
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
