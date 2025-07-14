import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fyp/screens/Course_Screens/Teacher_View/Video_Play_screen.dart';
import 'package:fyp/utils/app_colors.dart';

class DetailedCourseeScreen extends StatefulWidget {
  final String category;
  final String courseId;

  const DetailedCourseeScreen({
    super.key,
    required this.category,
    required this.courseId,
  });

  @override
  _DetailedCourseeScreenState createState() => _DetailedCourseeScreenState();
}

class _DetailedCourseeScreenState extends State<DetailedCourseeScreen> {
  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  // Fetch reviews from Firebase
  void _fetchReviews() async {
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .ref()
        .child('courses')
        .child(widget.category)
        .child(widget.courseId)
        .child('reviews')
        .get();

    if (snapshot.exists) {
      var reviewsData = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _reviews = reviewsData.entries.map((entry) {
          return {
            'rating': entry.value['rating'],
            'review': entry.value['review'],
          };
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataSnapshot>(
      future: FirebaseDatabase.instance
          .ref()
          .child('courses')
          .child(widget.category)
          .child(widget.courseId)
          .get(),
      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.value == null) {
          return const Center(child: Text('No data available'));
        }

        var courseData = snapshot.data!.value as Map<dynamic, dynamic>;
        List<String> videoUrls = (courseData['videoUrls'] as List<dynamic>?)
                ?.map((url) => url as String)
                .toList() ??
            [];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Course Details'),
            backgroundColor: Mycolors.primary_cyan,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: courseData['imageUrl'] != null
                            ? Image.network(
                                courseData['imageUrl'],
                                width: double.infinity,
                                height: 250.0,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 250.0,
                                width: double.infinity,
                                color: Colors.grey,
                                child: const Icon(
                                  Icons.image,
                                  size: 100,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      const SizedBox(height: 8.0),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                courseData['title'] ?? 'No title',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Mycolors.Text_black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                courseData['description'] ??
                                    'No description available',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (videoUrls.isNotEmpty)
                                Center(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Navigate to video player screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VideoPlayerScreen(
                                            videoUrls: videoUrls,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.play_circle_filled),
                                    label: const Text('View Videos'),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.red,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0,
                                        vertical: 12.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
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
  }
}
