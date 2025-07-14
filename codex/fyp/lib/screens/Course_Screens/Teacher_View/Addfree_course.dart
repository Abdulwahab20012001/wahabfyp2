import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/screens/Course_Screens/Teacher_View/FreeCourse_dashboard.dart';
import 'package:fyp/screens/Teacher_Screens/teacher_dashboard.dart';
import 'package:fyp/screens/Teacher_Screens/teacher_homescreen.dart';
import 'package:fyp/utils/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../../custom_widgets/container.dart';

class AddFreeCourseScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _AddFreeCourseScreenState createState() => _AddFreeCourseScreenState();
}

class _AddFreeCourseScreenState extends State<AddFreeCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  double _price = 0.0;
  File? _image;
  File? _pdf;
  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _pdf = File(result.files.single.path!);
      });
    }
  }

  Future<void> _freeuploadCourse() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isUploading = true;
      });

      try {
        String imageUrl = '';
        if (_image != null) {
          final imageRef = FirebaseStorage.instance
              .ref()
              .child('course_images')
              .child('${DateTime.now().toIso8601String()}.jpg');
          await imageRef.putFile(_image!);
          imageUrl = await imageRef.getDownloadURL();
        }

        String pdfUrl = '';
        if (_pdf != null) {
          final pdfRef = FirebaseStorage.instance
              .ref()
              .child('course_pdfs')
              .child('${DateTime.now().toIso8601String()}.pdf');
          await pdfRef.putFile(_pdf!);
          pdfUrl = await pdfRef.getDownloadURL();
        }

        User? user = FirebaseAuth.instance.currentUser;
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('Freecourses').push();
        await ref.set({
          'uid': user?.uid,
          'title': _title,
          'description': _description,
          'price': 0,
          'imageUrl': imageUrl,
          'pdfUrl': pdfUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Course uploaded successfully!')));
        setState(() {
          _isUploading = false;
        });
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload course')));
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const mycontainer(
            height: 120,
            width: 450,
            borderRadius: 20,
            color: Mycolors.primary_cyan,
            child: Center(
              child: Text(
                'Study Buddy',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 0,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          width: double.infinity,
                          height: 180,
                          child: _image == null
                              ? const Icon(Icons.add_a_photo, size: 50)
                              : Image.file(_image!, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        style: TextStyle(color: Mycolors.Text_black),
                        decoration: InputDecoration(
                            labelText: 'Course Title',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter a title';
                          return null;
                        },
                        onSaved: (value) {
                          _title = value!;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        style: TextStyle(color: Mycolors.Text_black),
                        decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Please enter a description';
                          return null;
                        },
                        onSaved: (value) {
                          _description = value!;
                        },
                        maxLines: 5,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton.icon(
                        onPressed: _pickPdf,
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Select PDF'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Mycolors.bg_color,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 12.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _isUploading
                          ? CircularProgressIndicator()
                          : InkWell(
                              onTap: () {
                                _freeuploadCourse().then((value) =>
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FreeCoursDashboard())));
                              },
                              child: const mycontainer(
                                borderRadius: 20,
                                color: Mycolors.primary_cyan,
                                height: 50,
                                width: 200,
                                child: Center(
                                    child: Text(
                                  'Add Course',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
