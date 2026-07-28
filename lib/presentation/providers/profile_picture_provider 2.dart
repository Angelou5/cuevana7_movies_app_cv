import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ProfilePictureProvider extends ChangeNotifier {
  File? _storedProfilePicture;
  File? get storedProfilePicture => _storedProfilePicture;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  final ImagePicker _picker = ImagePicker();

  Future<void> changeProfilePicture() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (pickedFile == null) return;

    _isUploading = true;
    notifyListeners();

    // Simulamos un retraso de red
    await Future.delayed(const Duration(seconds: 2));

    try {
      _storedProfilePicture = await _saveImageLocally(File(pickedFile.path));
    } catch (e) {
      print('Error al guardar localmente: $e');
    }

    _isUploading = false;
    notifyListeners();
  }

  Future<File> _saveImageLocally(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final String extension = path.extension(imageFile.path);
    final String fileName = 'current_profile_picture$extension';
    final String savedPath = path.join(directory.path, fileName);

    return await imageFile.copy(savedPath);
  }
}