import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/services/firebase_service.dart';
import 'package:project/models/advertisement_model.dart';

class AdminAdvertisementsScreen extends StatefulWidget {
  const AdminAdvertisementsScreen({Key? key}) : super(key: key);

  @override
  State<AdminAdvertisementsScreen> createState() => _AdminAdvertisementsScreenState();
}

class _AdminAdvertisementsScreenState extends State<AdminAdvertisementsScreen> {
  // Used to manually trigger refresh
  Key _refreshKey = UniqueKey();

  void _refresh() {
    setState(() {
      _refreshKey = UniqueKey(); // change the key to trigger StreamBuilder rebuild
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advertisements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
            tooltip: 'Refresh',
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        key: _refreshKey,
        stream: FirebaseFirestore.instance.collection('advertisements').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading advertisements'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final ads = snapshot.data!.docs;

          if (ads.isEmpty) {
            return const Center(child: Text('No advertisements found'));
          }

          return ListView.builder(
            itemCount: ads.length,
            itemBuilder: (context, index) {
              final ad = ads[index];
              final subject = ad['subject'] ?? 'No Subject';
              final Timestamp createdAtTimestamp = ad['createdAt'] ?? Timestamp.now();
              final createdAt = createdAtTimestamp.toDate();
              final bool isApproved = ad['isApproved'] ?? false;
              final String reason = ad['reason'] ?? '';

              final DocumentReference createdByRef = ad['createdBy'];
              final String userId = createdByRef.id;

              return FutureBuilder<String>(
                future: FirebaseService().getUserFullName(userId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Loading creator info...'),
                        ),
                      ),
                    );
                  }

                  final username = userSnapshot.data ?? 'Unknown User';

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    subject,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isApproved ? Colors.green.shade100 : reason.contains('null')? const Color.fromARGB(255, 233, 255, 134) : const Color.fromARGB(255, 255, 110, 110),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    isApproved ? 'Approved' : reason.contains('null')?  'Pending' :'Declined',
                                    style: TextStyle(
                                      color: isApproved ? Colors.green.shade800 : reason.contains('null')? Colors.orange.shade800 : Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Created At: ${createdAt.toLocal()}',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Created By: $username',
                              style: const TextStyle(fontSize: 14),
                            ),
                            if (!isApproved && (reason == "null" || reason.isEmpty))
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      try {
                                        final updatedAd = {
                                          ...ad.data() as Map<String, dynamic>,
                                          'isApproved': true,
                                        };
                                        await FirebaseService().updateAdvertisement(
                                          ad.id,
                                          Advertisement.fromJson(updatedAd),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Failed to approve ad: $e')),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.check),
                                    label: const Text('Approve'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          final TextEditingController reasonController = TextEditingController();
                                          return AlertDialog(
                                            title: const Text('Decline Advertisement'),
                                            content: TextField(
                                              controller: reasonController,
                                              maxLines: 3,
                                              decoration: const InputDecoration(
                                                hintText: 'Enter decline reason',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(),
                                                child: const Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  final declineReason = reasonController.text.trim();
                                                  if (declineReason.isNotEmpty) {
                                                    try {
                                                      final updatedAd = {
                                                        ...ad.data() as Map<String, dynamic>,
                                                        'isApproved': false,
                                                        'reason': declineReason,
                                                      };
                                                      await FirebaseService().updateAdvertisement(
                                                        ad.id,
                                                        Advertisement.fromJson(updatedAd),
                                                      );
                                                      Navigator.of(context).pop();
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text('Failed to decline ad: $e')),
                                                      );
                                                    }
                                                  }
                                                },
                                                child: const Text('Submit'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.cancel),
                                    label: const Text('Decline'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else if (reason != "null" && reason.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Decline Reason: $reason',
                                  style: const TextStyle(fontSize: 14, color: Colors.redAccent),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
