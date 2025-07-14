import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fyp/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class FreeCoursesScreen extends StatefulWidget {
  const FreeCoursesScreen({Key? key}) : super(key: key);

  @override
  _FreeCoursesScreenState createState() => _FreeCoursesScreenState();
}

class _FreeCoursesScreenState extends State<FreeCoursesScreen> {
  List<Map<String, dynamic>> _freeCourses = [];

  @override
  void initState() {
    super.initState();
    _fetchFreeCourses();
  }

  // Fetch free courses from Firebase Realtime Database
  void _fetchFreeCourses() async {
    DataSnapshot snapshot =
        await FirebaseDatabase.instance.ref().child('Freecourses').get();

    if (snapshot.exists) {
      var coursesData = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _freeCourses = coursesData.entries.map((entry) {
          return {
            'description': entry.value['description'] ?? 'No Description',
            'imageUrl': entry.value['imageUrl'] ?? '',
            'pdfUrl': entry.value['pdfUrl'] ?? '',
            'price': entry.value['price'] ?? 0,
          };
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Free Courses'),
        backgroundColor: Colors.teal,
      ),
      body: _freeCourses.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: _freeCourses.length,
                itemBuilder: (context, index) {
                  final course = _freeCourses[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          child: course['imageUrl'].isNotEmpty
                              ? Image.network(
                                  course['imageUrl'],
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 120,
                                  color: Colors.grey,
                                  child: const Center(
                                      child: Icon(Icons.image, size: 50)),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course['description'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Price: Free',
                                style: const TextStyle(
                                    color: Mycolors.primary_cyan, fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Open PDF Link
                                    _launchPDF(course['pdfUrl']);
                                  },
                                  icon: const Icon(Icons.picture_as_pdf),
                                  label: const Text('Open PDF'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  // Method to open the PDF URL
  void _launchPDF(String pdfUrl) async {
    if (pdfUrl.isNotEmpty) {
      final Uri url = Uri.parse(pdfUrl);
      if (await canLaunch(url.toString())) {
        await launch(url.toString());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open PDF link')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No PDF available for this course')),
      );
    }
  }
}
