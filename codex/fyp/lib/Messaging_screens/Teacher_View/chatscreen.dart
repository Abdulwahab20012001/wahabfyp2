import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fyp/utils/app_colors.dart';

class TeacherChatScreen extends StatelessWidget {
  final String studentId;
  final String conversationId;

  const TeacherChatScreen({
    Key? key,
    required this.studentId,
    required this.conversationId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>>(
          future: _getUserInfo(studentId),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Unknown Student');
            }

            final studentData = snapshot.data!;
            final studentName = studentData['name'] ?? 'Unknown';
            final studentProfilePic = studentData['profile'] ??
                'https://example.com/default-profile-pic.png';

            return Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(studentProfilePic),
                ),
                const SizedBox(width: 10),
                Text(studentName),
              ],
            );
          },
        ),
        backgroundColor: Mycolors.primary_cyan,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance
                  .ref()
                  .child('conversations')
                  .child(conversationId)
                  .onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return const Center(child: Text('No messages found.'));
                }

                final messages = Map<dynamic, dynamic>.from(
                    snapshot.data!.snapshot.value as Map);

                // Sort the messages by timestamp
                final sortedMessages = messages.values.toList()
                  ..sort((a, b) =>
                      (a['timestamp'] as int).compareTo(b['timestamp'] as int));

                return ListView.builder(
                  reverse: false, // Ensure the list is not reversed
                  itemCount: sortedMessages.length,
                  itemBuilder: (context, index) {
                    final message = sortedMessages[index];
                    final senderId = message['senderId'];
                    final text = message['text'];

                    return Align(
                      alignment:
                          senderId == FirebaseAuth.instance.currentUser!.uid
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: senderId ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Mycolors
                                  .primary_cyan // Your primary color for the current user
                              : Colors
                                  .grey, // Grey for the other user's messages
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text,
                              style: const TextStyle(
                                  color: Colors.white), // Message text color
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateTime.fromMillisecondsSinceEpoch(
                                      message['timestamp'])
                                  .toString(),
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12), // Timestamp color
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
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _getUserInfo(String userId) async {
    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child('student') // Fetching student data
        .child(userId)
        .get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    } else {
      return {};
    }
  }

  Widget _buildMessageInput(BuildContext context) {
    final TextEditingController _messageController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.black), // Set text color
              decoration: InputDecoration(
                  hintText: 'Type your message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                  fillColor: Mycolors.Text_white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Mycolors.primary_cyan, // Set the icon color
            onPressed: () {
              if (_messageController.text.trim().isNotEmpty) {
                _sendMessage(_messageController.text.trim());
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final newMessageRef = FirebaseDatabase.instance
        .ref()
        .child('conversations')
        .child(conversationId)
        .push();

    await newMessageRef.set({
      'senderId': userId,
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    // Update sender (Teacher)
    await FirebaseDatabase.instance
        .ref()
        .child('inbox')
        .child('users')
        .child(userId)
        .child(conversationId)
        .update({
      'receiverId': studentId,
      'lastMessage': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    // Update receiver (Student)
    await FirebaseDatabase.instance
        .ref()
        .child('inbox')
        .child('users')
        .child(studentId)
        .child(conversationId)
        .update({
      'receiverId': userId,
      'lastMessage': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
