import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  File? imageFile;
  final imagePicker = ImagePicker();

  Future<File?> takePhoto() async {
    try {
      final pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedImage == null) {
        return null;
      }
      imageFile = File(pickedImage.path);
      return File(pickedImage.path);
    } catch (e) {
      return null;
    }
  }

  Future<File?> pickImage() async {
    try {
      final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage == null) {
        return null;
      }
      imageFile = File(pickedImage.path);
      return File(pickedImage.path);
    } catch (e) {
      return null;
    }
  }

  Future<List<File>> pickMultiImage() async {
    final List<File> list = [];
    try {
      final List<XFile> selectedImages = await imagePicker.pickMultiImage();

      if (selectedImages.isNotEmpty) {
        for (var each in selectedImages) {
          list.add(File(each.path));
        }
      }
      return list;
    } catch (e) {
      return list;
    }
  }
}
