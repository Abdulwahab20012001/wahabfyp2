import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Added for local notifications
import 'package:fyp/custom_widgets/container.dart';
import 'package:fyp/screens/Course_Screens/Teacher_View/Detailed_PayCourse_Screen.dart';
import 'package:fyp/screens/Course_Screens/Teacher_View/FreeCourse_dashboard.dart';
import 'package:fyp/screens/Course_Screens/Teacher_View/Full_Pay_Course.dart';
import 'package:fyp/utils/app_colors.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); // Local Notifications instance

  @override
  void initState() {
    super.initState();
    _initializeLocalNotifications(); // Initialize notifications
  }

  // Initialize Local Notifications
  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Function to show notification
  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'studybuddy_channel', // Channel ID
      'StudyBuddy Notifications', // Channel Name
      channelDescription: 'Notifications triggered on Study Buddy click.',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Your Course is Approved!', // Notification Title
      'Keep Adding more Courses.', // Notification Body
      platformDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              _showNotification(); // Trigger notification on tap
            },
            child: const mycontainer(
              height: 110,
              width: 450,
              borderRadius: 20,
              color: Mycolors.primary_cyan,
              child: Center(
                child: Text(
                  'Study Buddy',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'My Courses',
                  style: TextStyle(
                      color: Mycolors.Text_black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(15, 20)),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FreeCoursDashboard()));
                  },
                  child: Text(
                    "Free Courses".toUpperCase(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance.ref().child('courses').onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final data =
                    snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;

                if (data == null) {
                  return const Center(
                      child: Text('No approved courses available'));
                }

                User? user = FirebaseAuth.instance.currentUser;
                final uid = user?.uid;

                // Collect only the approved courses for this teacher
                List<Map<dynamic, dynamic>> courses = [];
                data.forEach((category, courseData) {
                  (courseData as Map<dynamic, dynamic>)
                      .forEach((courseId, course) {
                    if (course['uid'] == uid &&
                        course['status'] == 'approved') {
                      courses.add({
                        'key': courseId,
                        'category': category,
                        'course': course
                      });
                    }
                  });
                });

                if (courses.isEmpty) {
                  return const Center(
                      child: Text('No approved courses available'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index]['course'];
                    final category = courses[index]['category'];
                    final courseKey = courses[index]['key'];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailedCourseeScreen(
                              courseId: courseKey,
                              category: category,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10.0)),
                              child: course['imageUrl'] != null
                                  ? Image.network(
                                      course['imageUrl'],
                                      width: double.infinity,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.book,
                                      size: 50, color: Colors.grey),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          'Category: $category',
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black,
                                          ),
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
                                  IconButton(
                                    icon: const Icon(Icons.more_vert, size: 20),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Options',
                                              style: TextStyle(
                                                  color: Mycolors.Text_black),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.edit),
                                                  title:
                                                      const Text('Edit Price'),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    _editCoursePrice(
                                                        context,
                                                        category,
                                                        courseKey,
                                                        course['price']
                                                                ?.toString() ??
                                                            '0.00');
                                                  },
                                                ),
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.delete),
                                                  title: const Text('Delete'),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    _deleteCourse(
                                                        category, courseKey);
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
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
          ),
        ],
      ),
    );
  }

  void _deleteCourse(String category, String courseKey) {
    FirebaseDatabase.instance
        .ref()
        .child('courses')
        .child(category)
        .child(courseKey)
        .remove()
        .then((_) {
      Fluttertoast.showToast(
        msg: 'Course deleted successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.cyan,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: 'Failed to delete course: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  void _editCoursePrice(BuildContext context, String category, String courseKey,
      String currentPrice) {
    final TextEditingController priceController =
        TextEditingController(text: currentPrice);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Course Price'),
          content: TextField(
            style: const TextStyle(color: Colors.black),
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Enter new price',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newPrice = priceController.text;
                FirebaseDatabase.instance
                    .ref()
                    .child('courses')
                    .child(category)
                    .child(courseKey)
                    .update({'price': newPrice}).then((_) {
                  Fluttertoast.showToast(
                    msg: 'Price updated successfully',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  Navigator.pop(context);
                }).catchError((error) {
                  Fluttertoast.showToast(
                    msg: 'Failed to update price: $error',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                });
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
