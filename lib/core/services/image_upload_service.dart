import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class SelectedImage {
  const SelectedImage({
    required this.bytes,
    required this.contentType,
  });

  final Uint8List bytes;
  final String contentType;
}

enum PhotoPickerFailure {
  permissionDenied,
  busy,
  invalidImage,
  unavailable,
  unknown,
}

class ImageUploadService {
  static final _picker = ImagePicker();
  static final _storage = FirebaseStorage.instance;

  static Future<SelectedImage?> pickImage() async {
    final picked = _supportsImageTransforms
        ? await _picker.pickImage(
            source: ImageSource.gallery,
            maxWidth: 512,
            maxHeight: 512,
            imageQuality: 80,
            requestFullMetadata: false,
          )
        : await _picker.pickImage(
            source: ImageSource.gallery,
            requestFullMetadata: false,
          );
    if (picked == null) return null;
    return SelectedImage(
      bytes: await picked.readAsBytes(),
      contentType: _resolveContentType(picked),
    );
  }

  static PhotoPickerFailure classifyPickerError(Object error) {
    if (error is StateError) {
      return PhotoPickerFailure.unavailable;
    }

    if (error is! PlatformException) {
      return PhotoPickerFailure.unknown;
    }

    switch (error.code) {
      case 'photo_access_denied':
      case 'photo_access_restricted':
      case 'camera_access_denied':
        return PhotoPickerFailure.permissionDenied;
      case 'already_active':
        return PhotoPickerFailure.busy;
      case 'invalid_image':
      case 'invalid_source':
      case 'no_valid_image_uri':
      case 'no_valid_media_uri':
        return PhotoPickerFailure.invalidImage;
      case 'no_activity':
      case 'channel-error':
      case 'null-error':
        return PhotoPickerFailure.unavailable;
    }

    final normalizedMessage = [
      error.message,
      error.details,
    ]
        .whereType<Object>()
        .map((value) => value.toString().toLowerCase())
        .join(' ');

    if (normalizedMessage.contains('permission') ||
        normalizedMessage.contains('access denied') ||
        normalizedMessage.contains('not allow')) {
      return PhotoPickerFailure.permissionDenied;
    }

    if (normalizedMessage.contains('already active')) {
      return PhotoPickerFailure.busy;
    }

    if (normalizedMessage.contains('invalid image') ||
        normalizedMessage.contains('cannot find the selected image') ||
        normalizedMessage.contains('cannot find the selected media')) {
      return PhotoPickerFailure.invalidImage;
    }

    if (normalizedMessage.contains('foreground activity') ||
        normalizedMessage.contains('channel-error')) {
      return PhotoPickerFailure.unavailable;
    }

    return PhotoPickerFailure.unknown;
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

  static bool get _supportsImageTransforms {
    if (kIsWeb) {
      return false;
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.android || TargetPlatform.iOS => true,
      TargetPlatform.fuchsia ||
      TargetPlatform.linux ||
      TargetPlatform.macOS ||
      TargetPlatform.windows =>
        false,
    };
  }
}
