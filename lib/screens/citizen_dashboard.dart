import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/announcement_provider.dart';
import 'announcement_detail_screen.dart';

class CitizenDashboard extends StatefulWidget {
  @override
  _CitizenDashboardState createState() => _CitizenDashboardState();
}

class _CitizenDashboardState extends State<CitizenDashboard> {
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = Provider.of<AnnouncementProvider>(context, listen: false).fetchAnnouncements();
  }

  void _refreshAnnouncements() {
    setState(() {
      _future = Provider.of<AnnouncementProvider>(context, listen: false).fetchAnnouncements();
    });
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/'); // Use the appropriate route name for your start screen
    print('Logging out...');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnnouncementProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back arrow
        title: Text('Citizen Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshAnnouncements,
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'logout') _logout();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Text('Log Out'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          final announcements = provider.announcements;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// === Announcements ===
                  Text(
                    'Announcements',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ...announcements.map((ann) => Card(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(ann.subject, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            ann.announcement.length > 50
                                ? ann.announcement.substring(0, 50) + '...'
                                : ann.announcement,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AnnouncementDetailScreen(announcement: ann),
                              ),
                            );
                          },
                        ),
                      )),

                  SizedBox(height: 25),

                  /// === Polls ===
                  Text(
                    'Polls',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // TODO: Replace with actual poll cards

                  SizedBox(height: 25),

                  /// === Advertisements ===
                  Text(
                    'Advertisements',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // TODO: Replace with actual advertisement cards
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
