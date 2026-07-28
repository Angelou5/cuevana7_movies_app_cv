import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class ProfilePictureProvider extends ChangeNotifier {
  static const _prefsKey = 'profile_picture_path';

  File? _storedProfilePicture;
  File? get storedProfilePicture => _storedProfilePicture;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  final ImagePicker _picker = ImagePicker();

  ProfilePictureProvider() {
    _loadSavedPicture();
  }

  Future<void> _loadSavedPicture() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString(_prefsKey);
    if (savedPath != null) {
      final file = File(savedPath);
      if (await file.exists()) {
        _storedProfilePicture = file;
        notifyListeners();
      }
    }
  }

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

    try {
      final oldPath = _storedProfilePicture?.path;
      _storedProfilePicture = await _saveImageLocally(File(pickedFile.path));
      await _deleteOldPicture(oldPath);
    } catch (e) {
      debugPrint('Error al guardar foto de perfil: $e');
    }

    _isUploading = false;
    notifyListeners();
  }

  Future<File> _saveImageLocally(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final String ext = path.extension(imageFile.path);
    final String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}$ext';
    final String savedPath = path.join(directory.path, fileName);

    final file = await imageFile.copy(savedPath);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, savedPath);

    return file;
  }

  Future<void> _deleteOldPicture(String? oldPath) async {
    if (oldPath == null) return;
    try {
      final oldFile = File(oldPath);
      if (await oldFile.exists()) await oldFile.delete();
    } catch (_) {}
  }
}