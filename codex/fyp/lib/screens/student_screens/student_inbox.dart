import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/Messaging_screens/Student_View/chat_screen.dart';
import 'package:fyp/utils/app_colors.dart';

class StudentInboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final studentId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Chats'),
        backgroundColor: Mycolors.primary_cyan,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance
            .ref()
            .child('inbox')
            .child('users')
            .child(studentId)
            .onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text('No conversations found.'));
          }

          final inboxData = Map<dynamic, dynamic>.from(
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>);

          return ListView.builder(
            itemCount: inboxData.length,
            itemBuilder: (context, index) {
              final conversationId = inboxData.keys.elementAt(index);
              final data = inboxData[conversationId];
              final teacherId = data['receiverId'] ?? '';

              if (teacherId.isEmpty) {
                return SizedBox.shrink();
              }

              return FutureBuilder<Map<String, dynamic>>(
                future: _getUserInfo(teacherId),
                builder: (context, teacherSnapshot) {
                  if (!teacherSnapshot.hasData ||
                      teacherSnapshot.data!.isEmpty) {
                    return SizedBox.shrink(); // Skip if data is missing
                  }

                  final teacherData = teacherSnapshot.data!;
                  final teacherName = teacherData['name'] ?? 'Unknown';
                  final teacherProfilePic = teacherData['profile'] ??
                      'https://example.com/default-profile-pic.png';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(teacherProfilePic),
                    ),
                    title: Text(teacherName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentChatScreen(
                            teacherId: teacherId,
                            conversationId: conversationId,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _getUserInfo(String userId) async {
    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child('teacher')
        .child(userId)
        .get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
    } else {
      return {};
    }
  }
}
