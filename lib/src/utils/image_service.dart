import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  static Future<XFile?> pick(BuildContext context, ImageSource source) async {
    final XFile? file = await ImagePicker().pickImage(source: source);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    return file!;
  }

  static void showPickImage(
    BuildContext context, {
    required Function(XFile?) onImagePicked,
  }) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text(
                    'Camera',
                  ),
                  onTap: () =>
                      pick(context, ImageSource.camera).then(onImagePicked),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text(
                    'Gallery',
                  ),
                  onTap: () =>
                      pick(context, ImageSource.gallery).then(onImagePicked),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
