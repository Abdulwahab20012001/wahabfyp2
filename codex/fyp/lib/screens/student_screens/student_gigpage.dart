import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fyp/Gig_screens/Student_View/DetailedViewGig.dart';
import 'package:fyp/Gig_screens/Teacher_View/Detailed_gig_screen.dart';
import 'package:fyp/utils/app_colors.dart';
import '../../custom_widgets/container.dart';

class StudentViewGigsScreen extends StatelessWidget {
  const StudentViewGigsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const mycontainer(
            height: 85,
            width: double.infinity,
            borderRadius: 20,
            color: Mycolors.primary_cyan,
            child: Center(
              child: Text(
                'Study Buddy',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, top: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Available Gigs',
                style: TextStyle(
                    color: Mycolors.Text_black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseDatabase.instance.ref().child('gigs').onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final data =
                    snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;
                if (data == null) {
                  return const Center(child: Text('No gigs available'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final category = data.keys.elementAt(index);
                    final gigsInCategory =
                        data[category] as Map<dynamic, dynamic>;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: gigsInCategory.entries.map((entry) {
                        final gigKey = entry.key;
                        final gig = entry.value;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailedViewGigScreen(
                                  category: category,
                                  gigId: gigKey,
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
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10.0)),
                                  child: gig['imageUrls'] != null &&
                                          gig['imageUrls'].isNotEmpty
                                      ? Image.network(
                                          gig['imageUrls'][0],
                                          width: double.infinity,
                                          height: 100, // Defined height
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(Icons.work,
                                          size: 50, color: Colors.grey),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        gig['title'] ?? 'No title',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      Text(
                                        '\$${gig['rate']?.toString() ?? '0.00'} per hour',
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
                      }).toList(),
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
}
