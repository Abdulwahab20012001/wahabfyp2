import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AdminPaymentsScreen extends StatelessWidget {
  const AdminPaymentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments Received'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance.ref('payments').onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return const Center(
                child: Text(
                  'No payments received yet.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            // Parse the data from Realtime Database
            final Map<dynamic, dynamic> payments = Map<dynamic, dynamic>.from(
                snapshot.data!.snapshot.value as Map);

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    MaterialStateColor.resolveWith((states) => Colors.teal),
                columns: const [
                  DataColumn(
                    label: Text('Profile Pic',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  DataColumn(
                    label: Text('Student Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  DataColumn(
                    label: Text('Amount',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  DataColumn(
                    label: Text('Timestamp',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
                rows: payments.entries.map((entry) {
                  final data = Map<String, dynamic>.from(entry.value);
                  final studentName = data['studentName'] ?? 'Unknown';
                  final profilePic =
                      data['studentProfilePic'] ?? 'assets/image.png';
                  final amount = data['amount']?.toStringAsFixed(2) ?? '0.00';
                  final timestamp = data['timestamp'] as int?;
                  final formattedTime = timestamp != null
                      ? DateFormat('yyyy-MM-dd HH:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(timestamp))
                      : 'Unknown';

                  return DataRow(cells: [
                    DataCell(
                      CircleAvatar(
                        backgroundImage: NetworkImage(profilePic),
                        radius: 20,
                      ),
                    ),
                    DataCell(Text(
                      studentName,
                      style: const TextStyle(fontSize: 16),
                    )),
                    DataCell(Text(
                      '\$${amount}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                    DataCell(Text(
                      formattedTime,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    )),
                  ]);
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
