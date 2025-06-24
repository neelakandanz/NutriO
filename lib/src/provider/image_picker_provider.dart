// lib/src/provider/image_picker_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

// 1. Provider for the selected image file
final imagePickerProvider = StateProvider.autoDispose<XFile?>((ref) => null);

// 2. Provider for the ImagePicker service
final imagePickerServiceProvider = Provider.autoDispose((ref) => ImagePickerService(ref));

// 3. Service class to handle image picking and permissions
class ImagePickerService {
  final Ref _ref;
  final ImagePicker _picker = ImagePicker();

  ImagePickerService(this._ref);

  Future<void> pickImage(ImageSource source) async {
    final permission = source == ImageSource.camera ? Permission.camera : Permission.photos;
    final status = await permission.request();

    if (status.isGranted) {
      try {
        final pickedFile = await _picker.pickImage(source: source);
        if (pickedFile != null) {
          _ref.read(imagePickerProvider.notifier).state = pickedFile;
          // Here you would navigate to the analysis screen or trigger the API call
          print("Image picked: ${pickedFile.path}");
        } else {
          print("No image selected.");
        }
      } catch (e) {
        print("Error picking image: $e");
      }
    } else if (status.isPermanentlyDenied) {
        // The user permanently denied the permission. Direct them to settings.
        openAppSettings();
    } else {
      print("Permission not granted.");
    }
  }
}