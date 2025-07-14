import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PendingCoursesScreen extends StatefulWidget {
  @override
  _PendingCoursesScreenState createState() => _PendingCoursesScreenState();
}

class _PendingCoursesScreenState extends State<PendingCoursesScreen> {
  List<Widget> pendingCourseCards = [];

  @override
  void initState() {
    super.initState();
    fetchPendingCourses();
  }

  // Fetch both the teacher's name
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

  void fetchPendingCourses() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("courses");
    DataSnapshot snapshot = await ref.get();

    List<Widget> tempCards = [];
    if (snapshot.exists) {
      for (DataSnapshot categorySnapshot in snapshot.children) {
        String category = categorySnapshot.key ?? 'Unknown Category';

        for (DataSnapshot courseSnapshot in categorySnapshot.children) {
          Map<dynamic, dynamic> course = courseSnapshot.value as Map;
          String status = course['status'] as String? ?? 'pending';
          String teacherId = course['uid'] as String? ?? '';

          if (status == 'pending') {
            // Using FutureBuilder to fetch teacher name asynchronously
            tempCards.add(
              FutureBuilder<String>(
                future: getTeacherName(teacherId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  String teacherName = snapshot.data ?? 'Unknown Teacher';

                  return Card(
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
                            course['title'] as String? ?? 'No Title',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Teacher: $teacherName',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Category: $category',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Price: \$${course['price'] as int? ?? 0}',
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ),
                          SizedBox(height: 5),
                          Text(
                            course['description'] as String? ??
                                'No description',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  approveCourse(courseSnapshot.key!, category);
                                },
                                child: Text('Approve'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  rejectCourse(courseSnapshot.key!, category);
                                },
                                child: Text('Reject'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }
      }

      setState(() {
        pendingCourseCards = tempCards;
      });
    }
  }

  void approveCourse(String courseId, String category) async {
    DatabaseReference courseRef =
        FirebaseDatabase.instance.ref("courses/$category/$courseId");
    await courseRef.update({
      'status': 'approved',
    });
    fetchPendingCourses(); // Refresh the list after approval
  }

  void rejectCourse(String courseId, String category) async {
    DatabaseReference courseRef =
        FirebaseDatabase.instance.ref("courses/$category/$courseId");
    await courseRef.update({
      'status': 'rejected',
    });
    fetchPendingCourses(); // Refresh the list after rejection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pending Courses',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: pendingCourseCards.isEmpty
              ? [Center(child: Text('No pending courses available'))]
              : pendingCourseCards,
        ),
      ),
    );
  }
}
