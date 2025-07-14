import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fyp/custom_widgets/Textformfield.dart';
import 'package:fyp/utils/app_colors.dart';
import 'package:fyp/utils/toastmessages.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fyp/view_model/controllers/Teacher_controllers/tsession_controller.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController with ChangeNotifier {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final educationController = TextEditingController();
  final cityController = TextEditingController();

  final DatabaseReference ref =
      FirebaseDatabase.instance.ref().child('teacher');
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final picker = ImagePicker();

  XFile? _image;
  XFile? get image => _image;

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // Pick Image from Gallery or Camera
  Future<void> pickImage(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Choose Option',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera, color: Mycolors.primary_cyan),
                title: const Text('Camera'),
                onTap: () async {
                  await _pickImageFromCamera(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image, color: Mycolors.primary_cyan),
                title: const Text('Gallery'),
                onTap: () async {
                  await _pickImageFromGallery(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle,
                    color: Mycolors.primary_cyan),
                title: const Text('Remove'),
                onTap: () {
                  _removeImage();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      await uploadImage(context);
    }
  }

  Future<void> _pickImageFromCamera(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      await uploadImage(context);
    }
  }

  void _removeImage() {
    _image = null;
    notifyListeners();
  }

  // Upload Profile Image
  Future<void> uploadImage(BuildContext context) async {
    try {
      setLoading(true);
      final storageRef = storage
          .ref('/profileImage/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(File(_image!.path));
      final imageUrl = await storageRef.getDownloadURL();

      await updateTeacherData('profile', imageUrl);
      Messages.toastmessages('Profile Image Updated');
    } catch (error) {
      Messages.toastmessages('Error uploading image: $error');
    } finally {
      setLoading(false);
    }
  }

  // Update Firebase Data
  Future<void> updateTeacherData(String key, String value) async {
    try {
      setLoading(true);
      await ref.child(SessionController.session.userid!).update({key: value});
      Messages.toastmessages('$key updated successfully');
    } catch (error) {
      Messages.toastmessages('Error updating $key: $error');
    } finally {
      setLoading(false);
    }
  }

  // Show Update Dialog
  Future<void> showUpdateDialog(
    BuildContext context,
    String title,
    String key,
    TextEditingController controller,
    String hintText,
  ) {
    controller.text = '';
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontSize: 18)),
          content: myfield(
            controller: controller,
            hintText: hintText,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty';
              }
              return null;
            },
            obscureText: false, // If needed, change to true for password fields
            decoration: InputDecoration(
              labelText: hintText,
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  await updateTeacherData(key, controller.text.trim());
                  Navigator.pop(context);
                } else {
                  Messages.toastmessages('Field cannot be empty');
                }
              },
              child:
                  const Text('Update', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  // Update Specific Fields
  Future<void> updateUserName(BuildContext context, String name) async {
    nameController.text = name;
    await showUpdateDialog(
        context, 'Update Username', 'name', nameController, 'Enter new name');
  }

  Future<void> updateEmail(BuildContext context, String email) async {
    emailController.text = email;
    await showUpdateDialog(
        context, 'Update Email', 'email', emailController, 'Enter new email');
  }

  Future<void> updatePhone(BuildContext context, String phone) async {
    phoneController.text = phone;
    await showUpdateDialog(context, 'Update Phone Number', 'phone',
        phoneController, 'Enter new phone number');
  }

  Future<void> updateEducation(BuildContext context, String education) async {
    educationController.text = education;
    await showUpdateDialog(context, 'Update Education', 'education',
        educationController, 'Enter new education');
  }

  Future<void> updateCity(BuildContext context, String city) async {
    cityController.text = city;
    await showUpdateDialog(
        context, 'Update City', 'city', cityController, 'Enter new city');
  }
}
