import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fyp/Messaging_screens/Student_View/chat_screen.dart';
import 'package:fyp/custom_widgets/container.dart';
import 'package:fyp/utils/app_colors.dart';

class DetailedViewGigScreen extends StatelessWidget {
  final String category;
  final String gigId;

  const DetailedViewGigScreen({
    Key? key,
    required this.category,
    required this.gigId,
  }) : super(key: key);

  Future<Map<String, dynamic>> _getTeacherInfo(String teacherId) async {
    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child('teacher')
        .child(teacherId)
        .get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    } else {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataSnapshot>(
      future: FirebaseDatabase.instance
          .ref()
          .child('gigs')
          .child(category)
          .child(gigId)
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

        var gigData = snapshot.data!.value as Map<dynamic, dynamic>;
        var imageUrls = List<String>.from(gigData['imageUrls'] ?? []);
        String teacherId = gigData['uid'];

        return FutureBuilder<Map<String, dynamic>>(
          future: _getTeacherInfo(teacherId),
          builder: (context, teacherSnapshot) {
            if (teacherSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (teacherSnapshot.hasError) {
              return Center(child: Text('Error: ${teacherSnapshot.error}'));
            }

            final teacherInfo = teacherSnapshot.data ?? {};
            String teacherName = teacherInfo['name'] ?? 'Unknown';
            String teacherProfilePic = teacherInfo['profile'] ??
                'https://example.com/default-profile-pic.png';

            return Scaffold(
              appBar: AppBar(
                title: Text(gigData['title'] ?? 'Gig Details'),
                backgroundColor: Mycolors.primary_cyan,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    SizedBox(
                      height: 250,
                      child: imageUrls.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: imageUrls.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      imageUrls[index],
                                      width: MediaQuery.of(context).size.width -
                                          60,
                                      height: 250.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              height: 250.0,
                              color: Colors.grey,
                              child: const Center(
                                child: Text(
                                  'No Images Available',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(teacherProfilePic),
                                    radius: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    teacherName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Mycolors.Text_black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      gigData['title'] ?? 'No title',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Mycolors.Text_black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\$${gigData['rate'] ?? 0.00} per hour',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Mycolors.primary_cyan,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Category: $category',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Mycolors.primary_cyan,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Mycolors.primary_cyan,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                gigData['description'] ?? 'No description',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentChatScreen(
                        teacherId: teacherId,
                        conversationId:
                            '${FirebaseAuth.instance.currentUser!.uid}_$teacherId',
                      ),
                    ),
                  );
                },
                backgroundColor: Mycolors.primary_cyan,
                child: const Icon(Icons.message),
              ),
            );
          },
        );
      },
    );
  }
}
