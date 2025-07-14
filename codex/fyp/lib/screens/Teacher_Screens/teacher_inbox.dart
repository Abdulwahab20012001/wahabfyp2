import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/Messaging_screens/Teacher_View/chatscreen.dart';
import 'package:fyp/utils/app_colors.dart';

class TeacherInboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final teacherId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Chats'),
        backgroundColor: Mycolors.primary_cyan,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance
            .ref()
            .child('inbox')
            .child('users')
            .child(teacherId)
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
              final studentId = data['receiverId'] ?? '';

              if (studentId.isEmpty) {
                return SizedBox.shrink();
              }

              return FutureBuilder<Map<String, dynamic>>(
                future: _getUserInfo(studentId),
                builder: (context, studentSnapshot) {
                  if (!studentSnapshot.hasData ||
                      studentSnapshot.data!.isEmpty) {
                    return SizedBox.shrink();
                  }

                  final studentData = studentSnapshot.data!;
                  final studentName = studentData['name'] ?? 'Unknown';
                  final studentProfilePic = studentData['profile'] ??
                      'https://example.com/default-profile-pic.png';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(studentProfilePic),
                    ),
                    title: Text(studentName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherChatScreen(
                            studentId: studentId,
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
        .child('student')
        .child(userId)
        .get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
    } else {
      return {};
    }
  }
}
