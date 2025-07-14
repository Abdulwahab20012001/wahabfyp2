import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fyp/screens/Course_Screens/Student_View/Attempt_Quiz.dart';
import 'package:fyp/screens/Course_Screens/Teacher_View/Video_Play_screen.dart';
import 'package:fyp/utils/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';

class DetailedCourseScreen extends StatefulWidget {
  final String category;
  final String courseId;

  const DetailedCourseScreen({
    super.key,
    required this.category,
    required this.courseId,
  });

  @override
  _DetailedCourseScreenState createState() => _DetailedCourseScreenState();
}

class _DetailedCourseScreenState extends State<DetailedCourseScreen> {
  bool _isVideoDownloaded = false;
  bool _isReviewGiven = false;
  List<Map<String, dynamic>> _reviews = [];
  bool _isDownloading = false; // Track download state

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

  // Method to download videos and save them in the gallery
  Future<void> _downloadVideos(
      BuildContext context, List<String> videoUrls) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      setState(() {
        _isDownloading = true; // Set to true when downloading starts
      });

      final directory = await getExternalStorageDirectory();

      for (int i = 0; i < videoUrls.length; i++) {
        final savePath = '${directory!.path}/video_${i + 1}.mp4';
        try {
          final dio = Dio();
          await dio.download(videoUrls[i], savePath);

          // Save video to the gallery
          final result = await GallerySaver.saveVideo(savePath);
          if (result == null || !result) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Failed to save video ${i + 1} to gallery')),
            );
          }
        } catch (e) {
          setState(() {
            _isDownloading = false; // Stop downloading on error
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error downloading video ${i + 1}!')),
          );
          break;
        }
      }

      setState(() {
        _isDownloading = false; // Set to false after all downloads are complete
        _isVideoDownloaded = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All videos downloaded successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied!')),
      );
    }
  }

  // Method to show review dialog
  void _showReviewDialog(BuildContext context, String courseId) {
    double rating = 0;
    TextEditingController reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Give a Review',
            style: TextStyle(color: Colors.black),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            rating = index + 1.0; // Update the selected rating
                          });
                        },
                        icon: Icon(
                          Icons.star,
                          color: index < rating ? Colors.amber : Colors.grey,
                        ),
                      );
                    }),
                  ),
                  TextField(
                    controller: reviewController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: 'Write your review here',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (rating > 0 && reviewController.text.isNotEmpty) {
                  final review = {
                    'rating': rating,
                    'review': reviewController.text,
                  };

                  FirebaseDatabase.instance
                      .ref()
                      .child('courses')
                      .child(widget.category)
                      .child(courseId)
                      .child('reviews')
                      .push()
                      .set(review);

                  setState(() {
                    _reviews.add(review); // Add to local list
                    _isReviewGiven = true; // Disable review button
                  });

                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please provide a rating and review!')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
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
                              const SizedBox(height: 10),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: _isDownloading ||
                                          _isVideoDownloaded
                                      ? null
                                      : () =>
                                          _downloadVideos(context, videoUrls),
                                  icon: _isDownloading
                                      ? const CircularProgressIndicator()
                                      : const Icon(Icons.download),
                                  label: _isVideoDownloaded
                                      ? const Text('All Videos Downloaded')
                                      : const Text('Download Videos'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AttemptQuizScreen(
                                            courseId: widget.courseId,
                                            category: widget.category,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.quiz, size: 24),
                                    label: const Text(
                                      'Attempt Quiz',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: _isReviewGiven
                                        ? null
                                        : () => _showReviewDialog(
                                            context, widget.courseId),
                                    icon:
                                        const Icon(Icons.rate_review, size: 24),
                                    label: const Text(
                                      'Give a Review',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Reviews:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (_reviews.isEmpty)
                                const Text(
                                  'No reviews yet',
                                  style: TextStyle(color: Colors.black),
                                ),
                              for (var review in _reviews)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.star,
                                                  color: Colors.amber),
                                              Text(
                                                '${review['rating']}',
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            review['review'] ?? 'No review',
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ],
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
