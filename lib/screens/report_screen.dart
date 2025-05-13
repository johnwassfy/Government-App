import 'package:flutter/material.dart';
import 'package:project/models/report.dart'; // Make sure to import your model if needed

class ReportScreen extends StatelessWidget {
  final Report report;  // Assuming you pass a report object to this screen

  // Constructor to accept the report object when navigating to this screen
  const ReportScreen({required this.report, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Refresh logic goes here (e.g., call a method to fetch new data)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Report refreshed!')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report ID: ${report.id}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Title: ${report.title}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Description: ${report.description}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            // If you want to display more information or items in the report
            Expanded(
              child: ListView.builder(
                itemCount: report.items.length, // Assuming report has items to display
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(report.items[index]),
                    leading: Icon(Icons.check_circle),
                    onTap: () {
                      // Handle item tap
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Item tapped: ${report.items[index]}')),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
