import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class GigScreen extends StatefulWidget {
  @override
  _GigScreenState createState() => _GigScreenState();
}

class _GigScreenState extends State<GigScreen> {
  List<Widget> gigCards = [];

  @override
  void initState() {
    super.initState();
    fetchGigs();
  }

  // Fetch teacher's name based on the teacherId
  Future<String> getTeacherName(String teacherId) async {
    DatabaseReference teacherRef =
        FirebaseDatabase.instance.ref("teacher/$teacherId");
    DataSnapshot teacherSnapshot = await teacherRef.get();
    if (teacherSnapshot.exists) {
      Map<dynamic, dynamic> teacher = teacherSnapshot.value as Map;
      return teacher['name'] as String? ??
          'Unknown Teacher'; // Handle null safely
    } else {
      return 'Unknown Teacher';
    }
  }

  void fetchGigs() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("gigs");
    DataSnapshot snapshot = await ref.get();

    List<Widget> tempCards = [];
    if (snapshot.exists) {
      for (DataSnapshot categorySnapshot in snapshot.children) {
        String category =
            categorySnapshot.key ?? 'Unknown Category'; // Handle null safely

        for (DataSnapshot gigSnapshot in categorySnapshot.children) {
          Map<dynamic, dynamic> gig = gigSnapshot.value as Map;
          String teacherId = gig['uid'] as String? ?? ''; // Handle null safely

          // Fetch the teacher's name asynchronously
          String teacherName = await getTeacherName(teacherId);

          tempCards.add(
            buildGigCard(
              gig['title'] as String? ?? '',
              teacherName,
              gig['rate'] as int? ?? 0,
              category,
              gig['description'] as String? ?? '',
            ),
          );
        }
      }

      setState(() {
        gigCards = tempCards;
      });
    }
  }

  Widget buildGigCard(String title, String teacherName, int rate,
      String category, String description) {
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
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade800),
            ),
            SizedBox(height: 8),
            Text(
              'Teacher: $teacherName',
              style: TextStyle(fontSize: 16, color: Colors.blueGrey.shade600),
            ),
            Text(
              'Rate: \$${rate.toString()}',
              style: TextStyle(fontSize: 16, color: Colors.blueGrey.shade600),
            ),
            Text(
              'Category: $category',
              style: TextStyle(fontSize: 16, color: Colors.blueGrey.shade600),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.blueGrey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gigs'),
        backgroundColor: Colors.teal,
      ),
      body: gigCards.isNotEmpty
          ? ListView(
              children: gigCards,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
