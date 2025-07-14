import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RejectedCoursesScreen extends StatefulWidget {
  @override
  _RejectedCoursesScreenState createState() => _RejectedCoursesScreenState();
}

class _RejectedCoursesScreenState extends State<RejectedCoursesScreen> {
  List<DataRow> rejectedCourseRows = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRejectedCourses();
  }

  Future<Map<String, String>> getTeacherInfo(String teacherId) async {
    DatabaseReference teacherRef =
        FirebaseDatabase.instance.ref("teacher/$teacherId");
    DataSnapshot teacherSnapshot = await teacherRef.get();
    if (teacherSnapshot.exists) {
      Map<dynamic, dynamic> teacher = teacherSnapshot.value as Map;
      return {
        'name': teacher['name'] as String? ?? 'Unknown Teacher',
        'education': teacher['education'] as String? ?? 'Unknown Education'
      };
    } else {
      return {'name': 'Unknown Teacher', 'education': 'Unknown Education'};
    }
  }

  void fetchRejectedCourses() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("courses");
    DataSnapshot snapshot = await ref.get();

    List<DataRow> tempRows = [];
    if (snapshot.exists) {
      for (DataSnapshot categorySnapshot in snapshot.children) {
        String category = categorySnapshot.key ?? 'Unknown Category';

        for (DataSnapshot courseSnapshot in categorySnapshot.children) {
          Map<dynamic, dynamic> course = courseSnapshot.value as Map;
          String status = course['status'] as String? ?? 'pending';
          String teacherId = course['uid'] as String? ?? '';

          if (status == 'rejected') {
            tempRows.add(
              DataRow(cells: [
                DataCell(Text(
                  course['title'] as String? ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                DataCell(
                  FutureBuilder<Map<String, String>>(
                    future: getTeacherInfo(teacherId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      }
                      if (snapshot.hasError || !snapshot.hasData) {
                        return Text('Unknown Teacher');
                      }
                      Map<String, String> teacherInfo = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(teacherInfo['name'] ?? 'Unknown Teacher'),
                          Text(
                            'Edu: ${teacherInfo['education']}',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                DataCell(Text(
                  '\$${course['price'] as int? ?? 0}',
                  style: TextStyle(color: Colors.green),
                )),
                DataCell(Text(course['description'] as String? ?? '')),
                DataCell(Text(category)),
              ]),
            );
          }
        }
      }

      setState(() {
        rejectedCourseRows = tempRows;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rejected Courses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.red[100]!),
                    columns: const [
                      DataColumn(
                          label: Text('Course Title',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Teacher',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Price',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Description',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Category',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: rejectedCourseRows,
                  ),
                ),
              ),
            ),
    );
  }
}
