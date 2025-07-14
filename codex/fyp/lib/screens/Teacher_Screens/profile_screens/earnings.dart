import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fyp/utils/app_colors.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class TeacherEarningsScreen extends StatelessWidget {
  const TeacherEarningsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Earnings'),
        backgroundColor: Mycolors.primary_cyan,
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
                    MaterialStateColor.resolveWith((states) => Colors.cyan),
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
                  DataColumn(
                    label: Text('Status',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  DataColumn(
                    label: Text('Teacher Amount',
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

                  // Teacher amount is 80% of total amount
                  final teacherAmount = (double.tryParse(amount) ?? 0.0) * 0.8;

                  return DataRow(cells: [
                    DataCell(
                      CircleAvatar(
                        backgroundImage: NetworkImage(profilePic),
                        radius: 20,
                      ),
                    ),
                    DataCell(Text(
                      studentName,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    )),
                    DataCell(Text(
                      '\$${amount}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
                    DataCell(Text(
                      formattedTime,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    )),
                    DataCell(Text(
                      '\$${teacherAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
                    const DataCell(Text(
                      'Pending',
                      style: TextStyle(fontSize: 16, color: Colors.red),
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
