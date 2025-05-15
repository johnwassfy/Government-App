import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/announcement_provider.dart';
import 'announcement_detail_screen.dart';
import '../models/advertisement_model.dart';
import '../services/firebase_service.dart';

class CitizenDashboard extends StatefulWidget {
  @override
  _CitizenDashboardState createState() => _CitizenDashboardState();
}

class _CitizenDashboardState extends State<CitizenDashboard> {
  late Future<void> _future;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<void> _loadData() {
    return Provider.of<AnnouncementProvider>(context, listen: false).fetchAnnouncements();
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/');
    print('Logging out...');
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(thickness: 1.2),
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildAnnouncementCard(ann) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(
          ann.subject,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          ann.announcement.length > 80
              ? '${ann.announcement.substring(0, 80)}...'
              : ann.announcement,
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AnnouncementDetailScreen(announcement: ann),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdCard(Advertisement ad) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(Icons.campaign, color: Theme.of(context).colorScheme.primary),
        title: Text(ad.subject, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          ad.description.length > 80
              ? '${ad.description.substring(0, 80)}...'
              : ad.description,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnnouncementProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Citizen Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _future = _loadData(); // re-trigger the FutureBuilder
              });
            },
            tooltip: 'Refresh',
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

          return RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// === Announcements ===
                  _buildSectionTitle('📢 Announcements'),
                  if (announcements.isEmpty)
                    Text('No announcements available.'),
                  ...announcements.map(_buildAnnouncementCard),

                  /// === Polls ===
                  _buildSectionTitle('🗳️ Polls'),
                  // TODO: Replace with actual poll cards
                  Text('Polls section coming soon!'),

                  /// === Advertisements ===
                  _buildSectionTitle('🧾 Advertisements'),
                  StreamBuilder<List<Advertisement>>(
                    stream: _firebaseService.getApprovedAdvertisementsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error loading advertisements.');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No approved advertisements available.');
                      }

                      final ads = snapshot.data!;
                      return Column(
                        children: ads.map(_buildAdCard).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
