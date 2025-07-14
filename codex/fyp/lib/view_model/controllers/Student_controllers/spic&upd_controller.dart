import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fyp/custom_widgets/Textformfield.dart';
import 'package:fyp/utils/app_colors.dart';
import 'package:fyp/utils/toastmessages.dart';
import 'package:fyp/view_model/controllers/Student_controllers/Ssession_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class StudentProfileController with ChangeNotifier {
  final namecontroler = TextEditingController();
  final emailcontroller = TextEditingController();
  final phonecontroler = TextEditingController();
  final educationcontroler = TextEditingController();
  final citycontroler = TextEditingController();

  DatabaseReference ref = FirebaseDatabase.instance.ref().child('student');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final picker = ImagePicker();
  XFile? _image;
  XFile? get image => _image;

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  //Gallery
  Future _pickImageFromGallery(BuildContext context) async {
    final PickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      _image = XFile(PickedFile.path);
      UploadImage(context);
      notifyListeners();
    }
  }

//Camera
  Future _pickImageFromCamera(BuildContext context) async {
    final PickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (PickedFile != null) {
      _image = XFile(PickedFile.path);

      UploadImage(context);
      notifyListeners();
    }
  }

  void _imageremover() {
    _image = null;
    notifyListeners();
  }

  void pickImage(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Choose Option',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  InkWell(
                    splashColor: const Color.fromARGB(255, 184, 183, 194),
                    child: const Row(children: [
                      Icon(Icons.camera, color: Mycolors.primary_cyan),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w100,
                            color: Colors.black),
                      )
                    ]),
                    onTap: () {
                      _pickImageFromCamera(context);
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    splashColor: const Color.fromARGB(255, 184, 183, 194),
                    child: const Row(children: [
                      Icon(Icons.image, color: Mycolors.primary_cyan),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w100,
                            color: Mycolors.Text_black),
                      )
                    ]),
                    onTap: () {
                      _pickImageFromGallery(context);
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    splashColor: const Color.fromARGB(255, 184, 183, 194),
                    child: const Row(children: [
                      Icon(Icons.remove_circle, color: Mycolors.primary_cyan),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Remove',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w100,
                            color: Colors.black),
                      )
                    ]),
                    onTap: () {
                      _imageremover();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  //Store image in firebase and get image ftrom firebase
  Future<void> UploadImage(BuildContext context) async {
    setLoading(true);
    firebase_storage.Reference storageref = firebase_storage
        .FirebaseStorage.instance
        .ref('/profileImage' + SSessionController.session.userid.toString());

    firebase_storage.UploadTask uploadTask =
        storageref.putFile(File(image!.path).absolute);
    await Future.value(uploadTask);
    final newurl = await storageref.getDownloadURL();
    ref
        .child(SSessionController.session.userid.toString())
        .update({'profile': newurl.toString()}).then((value) {
      Messages.toastmessages('Profile Update');
      setLoading(false);
      _image = null;
    }).onError((error, stackTrace) {
      Messages.toastmessages(error.toString());
      setLoading(false);
    });
  }

//Update profile data:

//Update Usename:
  Future<void> UpdateUserName(BuildContext context, String name) {
    namecontroler.text = name;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(
                child: Text(
              'Update Username',
              style: TextStyle(color: Mycolors.Text_black),
            )),
            content: myfield(
              controller: namecontroler,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.man_rounded,
                  size: 28,
                  color: Colors.grey,
                ),
                prefixIcon: Icon(
                  Icons.man_2,
                  size: 34,
                  color: Colors.grey,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter name';
                }
                return null;
              },
              obscureText: false,
              hintText: 'Enter Name',
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    ref
                        .child(SSessionController.session.userid.toString())
                        .update({'name': namecontroler.text.toString()}).then(
                            (value) {
                      namecontroler.clear();
                      Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          );
        });
  }

  // Update Email:
  Future<void> UpdateEmail(BuildContext context, String email) {
    emailcontroller.text = email;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(
                child: Text(
              'Update Email',
              style: TextStyle(color: Mycolors.Text_black),
            )),
            content: myfield(
              controller: emailcontroller,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.man_rounded,
                  size: 28,
                  color: Colors.grey,
                ),
                prefixIcon: Icon(
                  Icons.man_2,
                  size: 34,
                  color: Colors.grey,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter email';
                }
                return null;
              },
              obscureText: false,
              hintText: 'Enter email',
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    ref
                        .child(SSessionController.session.userid.toString())
                        .update({'name': namecontroler.text.toString()}).then(
                            (value) {
                      emailcontroller.clear();
                      Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          );
        });
  }

  Future<void> UpdatePhone(BuildContext context, String phoneno) {
    phonecontroler.text = phoneno;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(
                child: Text('Update Phone number',
                    style: TextStyle(color: Mycolors.Text_black))),
            content: myfield(
              controller: phonecontroler,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.man_rounded,
                  size: 28,
                  color: Colors.grey,
                ),
                prefixIcon: Icon(
                  Icons.man_2,
                  size: 34,
                  color: Colors.grey,
                ),
              ),
              validator: (value) {},
              obscureText: false,
              hintText: 'Enter email',
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    ref
                        .child(SSessionController.session.userid.toString())
                        .update({'phone': phonecontroler.text.toString()}).then(
                            (value) {
                      emailcontroller.clear();
                      Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          );
        });
  }

  Future<void> Updateeducation(BuildContext context, String education) {
    educationcontroler.text = education;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(
                child: Text('Update Education',
                    style: TextStyle(color: Mycolors.Text_black))),
            content: myfield(
              controller: educationcontroler,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.man_rounded,
                  size: 28,
                  color: Colors.grey,
                ),
                prefixIcon: Icon(
                  Icons.man_2,
                  size: 34,
                  color: Colors.grey,
                ),
              ),
              validator: (value) {},
              obscureText: false,
              hintText: 'Enter Education',
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    ref
                        .child(SSessionController.session.userid.toString())
                        .update({
                      'education': educationcontroler.text.toString()
                    }).then((value) {
                      emailcontroller.clear();
                      Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          );
        });
  }

  Future<void> Updatecity(BuildContext context, String city) {
    citycontroler.text = city;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(
                child: Text('Update City',
                    style: TextStyle(color: Mycolors.Text_black))),
            content: myfield(
              controller: citycontroler,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.man_rounded,
                  size: 28,
                  color: Colors.grey,
                ),
                prefixIcon: Icon(
                  Icons.man_2,
                  size: 34,
                  color: Colors.grey,
                ),
              ),
              validator: (value) {
                ;
              },
              obscureText: false,
              hintText: 'Enter City name',
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    ref
                        .child(SSessionController.session.userid.toString())
                        .update({'city': citycontroler.text.toString()}).then(
                            (value) {
                      emailcontroller.clear();
                      Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          );
        });
  }
}
