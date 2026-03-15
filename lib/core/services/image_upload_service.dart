import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class SelectedImage {
  const SelectedImage({
    required this.bytes,
    required this.contentType,
  });

  final Uint8List bytes;
  final String contentType;
}

class ImageUploadService {
  static final _picker = ImagePicker();
  static final _storage = FirebaseStorage.instance;

  static Future<SelectedImage?> pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
      requestFullMetadata: false,
    );
    if (picked == null) return null;
    return SelectedImage(
      bytes: await picked.readAsBytes(),
      contentType: _resolveContentType(picked),
    );
  }

  static Future<String> uploadProfileImage(
    String userId,
    SelectedImage image,
  ) async {
    final ref = _storage.ref().child('profile_images/$userId.jpg');
    await ref.putData(
      image.bytes,
      SettableMetadata(contentType: image.contentType),
    );
    return await ref.getDownloadURL();
  }

  static Future<void> deleteProfileImage(String userId) async {
    try {
      final ref = _storage.ref().child('profile_images/$userId.jpg');
      await ref.delete();
    } catch (_) {
      // Ignore if file doesn't exist
    }
  }

  static String _resolveContentType(XFile image) {
    final mimeType = image.mimeType;
    if (mimeType != null && mimeType.isNotEmpty) {
      return mimeType;
    }

    final normalizedName = image.name.toLowerCase();
    if (normalizedName.endsWith('.png')) return 'image/png';
    if (normalizedName.endsWith('.gif')) return 'image/gif';
    if (normalizedName.endsWith('.webp')) return 'image/webp';
    if (normalizedName.endsWith('.bmp')) return 'image/bmp';
    return 'image/jpeg';
  }
}
