import 'package:admin_panel/Teacher/Certificate_Screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TeachersScreen extends StatefulWidget {
  @override
  _TeachersScreenState createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  List<Widget> teacherCards = [];

  @override
  void initState() {
    super.initState();
    fetchTeachers();
  }

  void fetchTeachers() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("teacher");
    DataSnapshot snapshot = await ref.get();

    List<Widget> tempCards = [];
    if (snapshot.exists) {
      snapshot.children.forEach((teacherSnapshot) {
        String teacherId = teacherSnapshot.key ?? 'N/A';
        String name = teacherSnapshot.child('name').value as String? ?? 'N/A';
        String email = teacherSnapshot.child('email').value as String? ?? 'N/A';
        String education =
            teacherSnapshot.child('education').value as String? ?? 'N/A';
        String city = teacherSnapshot.child('city').value as String? ?? 'N/A';
        String stripeId =
            teacherSnapshot.child('stripeId').value as String? ?? 'N/A';
        String certificateUrl =
            teacherSnapshot.child('certificateUrl').value as String? ?? 'N/A';
        String profileImage =
            teacherSnapshot.child('profile').value as String? ?? 'N/A';

        tempCards.add(buildTeacherCard(
          teacherId,
          name,
          email,
          education,
          city,
          stripeId,
          certificateUrl,
          profileImage,
        ));
      });

      setState(() {
        teacherCards = tempCards;
      });
    } else {
      print("No teachers data available");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No teachers data found")),
      );
    }
  }

  Widget buildTeacherCard(
      String teacherId,
      String name,
      String email,
      String education,
      String city,
      String stripeId,
      String certificateUrl,
      String profileImage) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.blueGrey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text('Email: $email',
                style:
                    TextStyle(fontSize: 16, color: Colors.blueGrey.shade600)),
            Text('Education: $education',
                style:
                    TextStyle(fontSize: 16, color: Colors.blueGrey.shade600)),
            Text('City: $city',
                style:
                    TextStyle(fontSize: 16, color: Colors.blueGrey.shade600)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  certificateUrl.isNotEmpty
                      ? 'Certificate: Uploaded'
                      : 'Certificate: N/A',
                  style: TextStyle(
                      fontSize: 16,
                      color: certificateUrl.isNotEmpty
                          ? Colors.green
                          : Colors.red),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removeTeacher(teacherId),
                    ),
                    IconButton(
                      icon: Icon(Icons.visibility, color: Colors.blue),
                      onPressed: () => viewCertificate(teacherId),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void removeTeacher(String teacherId) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("teacher/$teacherId");
    await ref.remove();
    fetchTeachers();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Teacher Removed")),
    );
  }

  void viewCertificate(String teacherId) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("teacher/$teacherId/certificateUrl");
    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      String certificateUrl = snapshot.value as String;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CertificateScreen(certificateUrl: certificateUrl),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Certificate not found")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teachers List"),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: ListView(
        children: teacherCards,
      ),
    );
  }
}
