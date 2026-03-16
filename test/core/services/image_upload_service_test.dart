import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jainquest/core/services/image_upload_service.dart';

void main() {
  group('ImageUploadService.classifyPickerError', () {
    test('maps permission-related platform errors', () {
      final error = PlatformException(
        code: 'photo_access_denied',
        message: 'The user did not allow photo access.',
      );

      expect(
        ImageUploadService.classifyPickerError(error),
        PhotoPickerFailure.permissionDenied,
      );
    });

    test('maps already active errors', () {
      final error = PlatformException(
        code: 'already_active',
        message: 'Image picker is already active',
      );

      expect(
        ImageUploadService.classifyPickerError(error),
        PhotoPickerFailure.busy,
      );
    });

    test('maps invalid image selection errors', () {
      final error = PlatformException(
        code: 'no_valid_image_uri',
        message: 'Cannot find the selected image.',
      );

      expect(
        ImageUploadService.classifyPickerError(error),
        PhotoPickerFailure.invalidImage,
      );
    });

    test('maps unavailable picker states', () {
      final error = StateError('Image picker is not available');

      expect(
        ImageUploadService.classifyPickerError(error),
        PhotoPickerFailure.unavailable,
      );
    });

    test('falls back to message matching for unknown platform codes', () {
      final error = PlatformException(
        code: 'something_else',
        message: 'Permission was denied by the system',
      );

      expect(
        ImageUploadService.classifyPickerError(error),
        PhotoPickerFailure.permissionDenied,
      );
    });
  });
}
