import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/screens/Teacher_Screens/teacher_gig.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:location/location.dart'; // Import location package
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../../../custom_widgets/container.dart';
import 'package:fyp/utils/app_colors.dart';

class AddGigScreen extends StatefulWidget {
  @override
  _AddGigScreenState createState() => _AddGigScreenState();
}

class _AddGigScreenState extends State<AddGigScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  double _rate = 0.0;
  String? _selectedCategory;
  List<File?> _images = [null, null, null];
  bool _isUploading = false;

  final List<String> _categories = [
    'App Development',
    'Web Development',
    'E-commerce',
    'Amazon',
    'Graphic Design',
    'Writing',
    'Translation',
    'Video Editing',
    'Music & Audio',
    'Programming'
  ];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // _startLocationTracking();
  }

  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _images[index] = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadGig() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isUploading = true;
      });

      try {
        List<String> imageUrls = [];
        for (File? image in _images) {
          if (image != null) {
            final imageRef = FirebaseStorage.instance
                .ref()
                .child('gig_images')
                .child('${DateTime.now().toIso8601String()}.jpg');
            await imageRef.putFile(image);
            imageUrls.add(await imageRef.getDownloadURL());
          }
        }

        User? user = FirebaseAuth.instance.currentUser;
        DatabaseReference ref = FirebaseDatabase.instance
            .ref()
            .child('gigs')
            .child(_selectedCategory!)
            .push();
        await ref.set({
          'uid': user?.uid, // Save the teacher's ID (UID) here
          'title': _title,
          'description': _description,
          'rate': _rate,
          'imageUrls': imageUrls,
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gig uploaded successfully!')));
        setState(() {
          _isUploading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewGigsScreen()),
        );
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload gig')));
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
            width: double.infinity,
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
          const SizedBox(height: 0),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(3, (index) {
                          return GestureDetector(
                            onTap: () => _pickImage(index),
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                              ),
                              width: 100,
                              height: 100,
                              child: _images[index] == null
                                  ? const Icon(Icons.add_a_photo, size: 50)
                                  : Image.file(_images[index]!),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        style: const TextStyle(color: Mycolors.Text_black),
                        decoration: InputDecoration(
                            labelText: 'Gig Title',
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
                      const SizedBox(height: 15),
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
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            labelText: 'Category',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        value: _selectedCategory,
                        items: _categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a category' : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        style: TextStyle(color: Mycolors.Text_black),
                        decoration: InputDecoration(
                            labelText: 'Rate per hour',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter a rate';
                          return null;
                        },
                        onSaved: (value) {
                          _rate = double.parse(value!);
                        },
                      ),
                      const SizedBox(height: 15),
                      _isUploading
                          ? CircularProgressIndicator()
                          : InkWell(
                              onTap: _uploadGig,
                              child: const mycontainer(
                                borderRadius: 20,
                                color: Mycolors.primary_cyan,
                                height: 50,
                                width: 200,
                                child: Center(
                                    child: Text(
                                  'Create Gig',
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
