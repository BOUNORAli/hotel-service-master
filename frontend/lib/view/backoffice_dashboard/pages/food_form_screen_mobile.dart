import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImageMobile() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}
