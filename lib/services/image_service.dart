import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'documents/document_api_service.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// Opens camera and returns the captured image
  /// Returns null if user cancels or permission is denied
  static Future<File?> openCamera() async {
    try {
      // Check camera permission
      final cameraStatus = await Permission.camera.status;

      if (cameraStatus.isDenied) {
        final result = await Permission.camera.request();
        if (result.isDenied || result.isPermanentlyDenied) {
          _showPermissionDialog('Camera permission is required to take photos');
          return null;
        }
      }

      // Take picture
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80, // Compress image to reduce size
        maxWidth: 1920, // Limit max width
        maxHeight: 1080, // Limit max height
      );

      if (image != null) {
        return File(image.path);
      }

      return null;
    } catch (e) {
      debugPrint('Error opening camera: $e');
      _showErrorDialog('Failed to open camera. Please try again.');
      return null;
    }
  }

  /// Opens gallery and returns the selected image
  /// Returns null if user cancels or permission is denied
  static Future<File?> openGallery() async {
    try {
      // Check storage permission
      final storageStatus = await Permission.storage.status;
      final photosStatus = await Permission.photos.status;

      if (storageStatus.isDenied && photosStatus.isDenied) {
        final storageResult = await Permission.storage.request();
        final photosResult = await Permission.photos.request();

        if ((storageResult.isDenied || storageResult.isPermanentlyDenied) &&
            (photosResult.isDenied || photosResult.isPermanentlyDenied)) {
          _showPermissionDialog(
            'Storage permission is required to access gallery',
          );
          return null;
        }
      }

      // Pick image from gallery
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Compress image to reduce size
        maxWidth: 1920, // Limit max width
        maxHeight: 1080, // Limit max height
      );

      if (image != null) {
        return File(image.path);
      }

      return null;
    } catch (e) {
      debugPrint('Error opening gallery: $e');
      _showErrorDialog('Failed to open gallery. Please try again.');
      return null;
    }
  }

  /// Shows image source selection dialog (Camera or Gallery)
  /// Returns the selected image file or null if cancelled
  static Future<File?> showImageSourceDialog(BuildContext context) async {
    return showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  final image = await openCamera();
                  if (context.mounted) Navigator.pop(context, image);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  final image = await openGallery();
                  if (context.mounted) Navigator.pop(context, image);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// Shows a simple image picker with camera and gallery options
  /// Returns the selected image file or null if cancelled
  static Future<File?> pickImage(BuildContext context) async {
    return showModalBottomSheet<File?>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  final image = await openCamera();
                  if (context.mounted) Navigator.pop(context, image);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  final image = await openGallery();
                  if (context.mounted) Navigator.pop(context, image);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.of(context).pop(null),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Picks an image using camera or gallery, then uploads it as a document.
  ///
  /// This is a high-level convenience method that handles the entire flow from
  /// picking an image to uploading it to the server and showing feedback to the user.
  /// It uses GetX for showing a loading dialog and success/error snackbars.
  ///
  /// [context] is required to show the image picker.
  /// [documentType] is a string representing the type of document (e.g., 'receipt').
  ///
  /// Returns `true` on successful upload, `false` otherwise (e.g., user
  /// cancelled, permission denied, or upload failed).
  static Future<bool> pickAndUploadDocument({
    required BuildContext context,
    required String documentType,
  }) async {
    print('Starting document upload flow for type: $documentType');
    // 1. Let the user pick an image. `pickImage` handles permissions.
    final File? imageFile = await pickImage(context);
    print('Picked image file: ${imageFile?.path}');
    if (imageFile == null) {
      // User cancelled the image selection.
      return false;
    }

    // 2. Optional: Validate image size before uploading to save bandwidth.
    if (!isImageSizeAcceptable(imageFile, maxSizeMB: 10.0)) {
      Get.snackbar(
        'Image Too Large',
        'Please select an image smaller than 10MB.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    // 3. Show a loading indicator while uploading.
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // 4. Call the combined upload and create document service method.
      await DocumentApiService.uploadAndCreateDocument(
        imagePath: imageFile.path,
        documentType: documentType,
      );
      print('Document uploaded successfully: ${imageFile.path}');

      // 5. Handle success: close dialog and show success message.
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.snackbar(
        'Success',
        'Document uploaded successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      // 6. Handle error: close dialog and show error message.
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.snackbar(
        'Upload Failed',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('pickAndUploadDocument failed: $e');
      return false;
    }
  }

  /// Check if camera permission is granted
  static Future<bool> hasCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Check if storage permission is granted
  static Future<bool> hasStoragePermission() async {
    final storageStatus = await Permission.storage.status;
    final photosStatus = await Permission.photos.status;
    return storageStatus.isGranted || photosStatus.isGranted;
  }

  /// Request camera permission
  static Future<bool> requestCameraPermission() async {
    final result = await Permission.camera.request();
    return result.isGranted;
  }

  /// Request storage permission
  static Future<bool> requestStoragePermission() async {
    final storageResult = await Permission.storage.request();
    final photosResult = await Permission.photos.request();
    return storageResult.isGranted || photosResult.isGranted;
  }

  /// Show permission dialog
  static void _showPermissionDialog(String message) {
    // This would typically show a dialog, but since we don't have context here,
    // we'll just print the message. In a real app, you'd want to pass context
    // or use a global navigator key.
    debugPrint('Permission Required: $message');
  }

  /// Show error dialog
  static void _showErrorDialog(String message) {
    // This would typically show a dialog, but since we don't have context here,
    // we'll just print the message. In a real app, you'd want to pass context
    // or use a global navigator key.
    debugPrint('Error: $message');
  }

  /// Get image size in MB
  static double getImageSizeInMB(File imageFile) {
    final bytes = imageFile.lengthSync();
    return bytes / (1024 * 1024); // Convert to MB
  }

  /// Check if image size is within acceptable limits (e.g., 10MB)
  static bool isImageSizeAcceptable(File imageFile, {double maxSizeMB = 10.0}) {
    final sizeInMB = getImageSizeInMB(imageFile);
    return sizeInMB <= maxSizeMB;
  }
}
