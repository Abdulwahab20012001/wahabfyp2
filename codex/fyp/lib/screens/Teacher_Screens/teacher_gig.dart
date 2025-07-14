import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/Gig_screens/Teacher_View/Detailed_gig_screen.dart';
import 'package:fyp/custom_widgets/container.dart';
import 'package:fyp/utils/app_colors.dart';

class ViewGigsScreen extends StatelessWidget {
  const ViewGigsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const mycontainer(
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
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'My Gigs',
                  style: TextStyle(
                      color: Mycolors.Text_black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance.ref().child('gigs').onValue,
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
                  return const Center(child: Text('No gigs available'));
                }

                User? user = FirebaseAuth.instance.currentUser;
                final uid = user?.uid;

                // Collect gigs from all categories
                List<Map<dynamic, dynamic>> gigs = [];
                data.forEach((category, gigData) {
                  (gigData as Map<dynamic, dynamic>).forEach((gigId, gig) {
                    if (gig['uid'] == uid) {
                      gigs.add(
                          {'key': gigId, 'category': category, 'gig': gig});
                    }
                  });
                });

                if (gigs.isEmpty) {
                  return const Center(child: Text('No gigs available'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: gigs.length,
                  itemBuilder: (context, index) {
                    final gig = gigs[index]['gig'];
                    final category = gigs[index]['category'];
                    final gigKey = gigs[index]['key'];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailedGigScreen(
                              gigId: gigKey,
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
                              child: gig['imageUrls'] != null &&
                                      gig['imageUrls'].isNotEmpty
                                  ? Image.network(
                                      gig['imageUrls'][0],
                                      width: double.infinity,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.work,
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
                                          'Category: $category',
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black,
                                          ),
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
                                                      const Icon(Icons.delete),
                                                  title: const Text('Delete'),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    _deleteGig(
                                                        category, gigKey);
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

  void _deleteGig(String category, String gigKey) {
    FirebaseDatabase.instance
        .ref()
        .child('gigs')
        .child(category)
        .child(gigKey)
        .remove()
        .then((_) {
      Fluttertoast.showToast(
        msg: 'Gig deleted successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.cyan,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: 'Failed to delete gig: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }
}
