import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageInputViewModel {
  static Future<File?> chooseImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: source,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return null;
    }

    return File(pickedImage.path);
  }
}
