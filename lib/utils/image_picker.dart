import 'package:image_picker/image_picker.dart';

class ImageSelector {
  final ImagePicker picker = ImagePicker();

  Future<XFile?> pick({ImageSource source = ImageSource.gallery}) async {
    return await picker.pickImage(
      source: source,
      imageQuality: 100,
      requestFullMetadata: false,
      maxHeight: 100,
      maxWidth: 100
    );
  }

  Future<List<XFile>> pickMultiple() async {
    return await picker.pickMultiImage(requestFullMetadata: false);
  }
}