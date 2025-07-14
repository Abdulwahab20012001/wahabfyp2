import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RejectedTeachersScreen extends StatefulWidget {
  @override
  _RejectedTeachersScreenState createState() => _RejectedTeachersScreenState();
}

class _RejectedTeachersScreenState extends State<RejectedTeachersScreen> {
  List<Widget> rejectedTeacherCards = [];

  @override
  void initState() {
    super.initState();
    fetchRejectedTeachers();
  }

  Future<String> getTeacherName(String teacherId) async {
    DatabaseReference teacherRef =
        FirebaseDatabase.instance.ref("teachers/$teacherId");
    DataSnapshot teacherSnapshot = await teacherRef.get();
    if (teacherSnapshot.exists) {
      Map<dynamic, dynamic> teacher = teacherSnapshot.value as Map;
      return teacher['name'] as String? ?? 'Unknown Teacher';
    } else {
      return 'Unknown Teacher';
    }
  }

  void fetchRejectedTeachers() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("teachers");
    DataSnapshot snapshot = await ref.get();

    List<Widget> tempCards = [];
    if (snapshot.exists) {
      for (DataSnapshot teacherSnapshot in snapshot.children) {
        Map<dynamic, dynamic> teacher = teacherSnapshot.value as Map;
        bool isApproved = teacher['isApproved'] as bool? ?? false;
        bool isRejected = teacher['isRejected'] as bool? ?? false;
        if (isRejected) {
          String teacherId = teacherSnapshot.key ?? '';
          String teacherName = await getTeacherName(teacherId);

          tempCards.add(
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacher['name'] as String? ?? 'No Name',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Teacher: $teacherName',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Email: ${teacher['email']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Phone: ${teacher['phone']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
    }
    setState(() {
      rejectedTeacherCards = tempCards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rejected Teachers',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade200, Colors.red.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          children: rejectedTeacherCards.isEmpty
              ? [Center(child: CircularProgressIndicator())]
              : rejectedTeacherCards,
        ),
      ),
    );
  }
}
