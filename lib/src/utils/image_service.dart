import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ebom/generated/locale_keys.g.dart';
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
                  title: Text(
                    LocaleKeys.image_service_choose_camera.tr(),
                  ),
                  onTap: () =>
                      pick(context, ImageSource.camera).then(onImagePicked),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(
                    LocaleKeys.image_service_choose_gallery.tr(),
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
