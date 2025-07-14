import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/screens/Teacher_Screens/teacher_dashboard.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../../custom_widgets/container.dart';
import 'package:fyp/utils/app_colors.dart';

class AddCourseScreen extends StatefulWidget {
  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  double _price = 0.0;
  String? _selectedCategory;
  File? _image;
  List<File> _videos = [];
  bool _isUploading = false;
  bool _isUploadingVideos = false;
  final List<TextEditingController> _quizQuestions =
      List.generate(3, (index) => TextEditingController());
  final List<TextEditingController> _quizAnswers =
      List.generate(3, (index) => TextEditingController());

  final List<String> _categories = [
    'App Development',
    'Web Development',
    'E-commerce',
    'Amazon',
    'Math',
    'Physics',
    'English',
    'Chemistry',
    'Other'
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _pickVideos() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true, // Allow selecting multiple videos
    );
    setState(() {
      if (result != null && result.files.isNotEmpty) {
        _videos = result.files.map((file) => File(file.path!)).toList();
      }
    });
  }

  Future<List<String>> _uploadVideos() async {
    setState(() {
      _isUploadingVideos = true;
    });

    List<String> videoUrls = [];
    for (var video in _videos) {
      final videoRef = FirebaseStorage.instance
          .ref()
          .child('course_videos')
          .child('${DateTime.now().toIso8601String()}.mp4');
      await videoRef.putFile(video);
      String videoUrl = await videoRef.getDownloadURL();
      videoUrls.add(videoUrl);
    }

    setState(() {
      _isUploadingVideos = false;
    });

    return videoUrls;
  }

  Future<void> _uploadCourse() async {
    if (_formKey.currentState!.validate()) {
      if (_videos.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select at least one video.")),
        );
        return;
      }

      _formKey.currentState!.save();
      setState(() {
        _isUploading = true;
      });

      try {
        // Upload image
        String imageUrl = '';
        if (_image != null) {
          final imageRef = FirebaseStorage.instance
              .ref()
              .child('course_images')
              .child('${DateTime.now().toIso8601String()}.jpg');
          await imageRef.putFile(_image!);
          imageUrl = await imageRef.getDownloadURL();
        }

        // Upload videos
        List<String> videoUrls = await _uploadVideos();

        // Prepare quiz data
        Map<String, dynamic> quizData = {};
        if (_quizQuestions.every((q) => q.text.isNotEmpty) &&
            _quizAnswers.every((a) => a.text.isNotEmpty)) {
          for (int i = 0; i < _quizQuestions.length; i++) {
            quizData['question${i + 1}'] = {
              'question': _quizQuestions[i].text,
              'answer': _quizAnswers[i].text,
            };
          }
        } else {
          quizData = {}; // Leave it empty if any question/answer is missing
        }

        // Prepare course data
        User? user = FirebaseAuth.instance.currentUser;
        Map<String, dynamic> courseData = {
          'uid': user?.uid,
          'title': _title,
          'description': _description,
          'price': _price,
          'imageUrl': imageUrl,
          'videoUrls': videoUrls, // List of video URLs
          'status': 'pending',
          'quiz': quizData, // Add the quiz data properly here
        };

        // Save course details to Firebase Realtime Database
        DatabaseReference ref = FirebaseDatabase.instance
            .ref()
            .child('courses')
            .child(_selectedCategory!)
            .push();
        await ref.set(courseData);

        // Show success dialog
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'Course Submitted',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            content: const Text(
              'Your course has been submitted and is pending admin approval.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context)
                      .pushReplacementNamed('/teacherDashboard');
                },
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeacherDashboard()));
                    },
                    child: const Text('OK')),
              ),
            ],
          ),
        );

        setState(() {
          _isUploading = false;
        });
      } catch (e) {
        print("Upload error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload course: $e')),
        );
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
                  color: Colors.white,
                ),
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
                      const SizedBox(height: 15),
                      TextFormField(
                        style: const TextStyle(color: Mycolors.Text_black),
                        decoration: InputDecoration(
                          labelText: 'Course Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
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
                        style: const TextStyle(color: Mycolors.Text_black),
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
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
                          labelStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        value: _selectedCategory,
                        items: _categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              category,
                              style: const TextStyle(color: Colors.black),
                            ),
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
                        style: const TextStyle(color: Mycolors.Text_black),
                        decoration: InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter a price';
                          return null;
                        },
                        onSaved: (value) {
                          _price = double.parse(value!);
                        },
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: _isUploadingVideos ? null : _pickVideos,
                        icon: _isUploadingVideos
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Icon(Icons.video_library),
                        label: _isUploadingVideos
                            ? const Text("Uploading Videos...")
                            : Text(_videos.isEmpty
                                ? 'Select Videos'
                                : 'Videos Uploaded'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              _videos.isEmpty ? Colors.blueGrey : Colors.green,
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
                      const Text(
                        'Add Quiz (Optional)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      for (int i = 0; i < 3; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _quizQuestions[i],
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  labelText: 'Question ${i + 1}',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                style: const TextStyle(color: Colors.black),
                                controller: _quizAnswers[i],
                                decoration: InputDecoration(
                                  labelText: 'Answer ${i + 1}',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),
                      _isUploading
                          ? const CircularProgressIndicator()
                          : InkWell(
                              onTap: _uploadCourse,
                              child: const mycontainer(
                                borderRadius: 20,
                                color: Mycolors.primary_cyan,
                                height: 50,
                                width: 200,
                                child: Center(
                                  child: Text(
                                    'Add Course',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
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
