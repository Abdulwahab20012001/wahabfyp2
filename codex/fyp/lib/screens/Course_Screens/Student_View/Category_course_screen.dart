import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fyp/screens/Course_Screens/Student_View/DetailedViewCourse.dart';
import 'package:fyp/utils/app_colors.dart';

class CategoryCoursesScreen extends StatelessWidget {
  final String category;

  const CategoryCoursesScreen({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Mycolors.primary_cyan,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance
            .ref()
            .child('courses')
            .child(category)
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;

          if (data == null || data.isEmpty) {
            return const Center(child: Text('No courses available'));
          }

          final approvedCourses = data.entries
              .where((courseEntry) => courseEntry.value['status'] == 'approved')
              .toList();

          if (approvedCourses.isEmpty) {
            return const Center(child: Text('No approved courses available'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.95,
            ),
            itemCount: approvedCourses.length,
            itemBuilder: (context, index) {
              final courseKey = approvedCourses[index].key;
              final course = approvedCourses[index].value;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailedViewCourseScreen(
                        courseId: courseKey,
                        category: category,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10.0)),
                          child: course['imageUrl'] != null
                              ? Image.network(
                                  course['imageUrl'],
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.book,
                                  size: 50, color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course['title'] ?? 'No title',
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            Text(
                              '\$${course['price']?.toString() ?? '0.00'}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
