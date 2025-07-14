import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class StudentScreen extends StatefulWidget {
  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  List<Widget> studentCards = [];

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  void fetchStudents() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("student");
    DataSnapshot snapshot = await ref.get();

    List<Widget> tempCards = [];
    if (snapshot.exists) {
      snapshot.children.forEach((studentSnapshot) {
        String studentId = studentSnapshot.key ?? 'N/A';
        String name = studentSnapshot.child('name').value as String? ?? 'N/A';
        String email = studentSnapshot.child('email').value as String? ?? 'N/A';
        String profileImage =
            studentSnapshot.child('profile').value as String? ?? 'N/A';
        String city = studentSnapshot.child('city').value as String? ?? 'N/A';
        String education =
            studentSnapshot.child('education').value as String? ?? 'N/A';
        String phone = studentSnapshot.child('phone').value as String? ?? 'N/A';

        tempCards.add(buildStudentCard(
          studentId,
          name,
          email,
          profileImage,
          city,
          education,
          phone,
        ));
      });

      setState(() {
        studentCards = tempCards;
      });
    } else {
      print("No student data available");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No student data found")),
      );
    }
  }

  Widget buildStudentCard(String studentId, String name, String email,
      String profileImage, String city, String education, String phone) {
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
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade800),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text('Email: $email',
                style:
                    TextStyle(fontSize: 16, color: Colors.blueGrey.shade600)),
            Text('City: $city',
                style:
                    TextStyle(fontSize: 16, color: Colors.blueGrey.shade600)),
            Text('Education: $education',
                style:
                    TextStyle(fontSize: 16, color: Colors.blueGrey.shade600)),
            Text('Phone: $phone',
                style:
                    TextStyle(fontSize: 16, color: Colors.blueGrey.shade600)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => removeStudent(studentId),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void removeStudent(String studentId) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("student/$studentId");
    await ref.remove();
    fetchStudents();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Student Removed")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Students List"),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: ListView(
        children: studentCards,
      ),
    );
  }
}
