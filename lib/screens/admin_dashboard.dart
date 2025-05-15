import 'package:flutter/material.dart';
import 'admin_announcements_screen.dart';
import 'admin_advertisements_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/widgets/phone_number_section.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _DashboardCard(
            title: 'Announcements',
            icon: Icons.campaign,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AdminAnnouncementsScreen()),
            ),
          ),
          _DashboardCard(
            title: 'Polls',
            icon: Icons.poll,
            onTap: () {
              // Navigate to Polls screen
            },
          ),
          _DashboardCard(
            title: 'Messages',
            icon: Icons.message,
            onTap: () {
              // Navigate to Messages screen
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('advertisements')
                .where('isApproved', isEqualTo: false)
                .where('reason', isEqualTo: 'null' )
                .snapshots(),
            builder: (context, snapshot) {
              final pendingCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
              return _DashboardCard(
                title: 'Advertisements ($pendingCount)',
                icon: Icons.ad_units,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AdminAdvertisementsScreen()),
                ),
              );
            },
          ),
          _DashboardCard(
            title: 'Users',
            icon: Icons.people,
            onTap: () {
              // Navigate to Users screen
            },
          ),
          _DashboardCard(
            title: 'Official Phone Numbers',
            icon: Icons.phone,
            expandableContent: OfficialPhoneNumbersSection(),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget? expandableContent;
  final VoidCallback? onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    this.expandableContent,
    this.onTap,
  });

  @override
  State<_DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<_DashboardCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  void _handleTap() {
    if (widget.expandableContent != null) {
      setState(() {
        _isExpanded = !_isExpanded;
      });
    } else {
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(widget.icon, size: 28),
            title: Text(widget.title, style: TextStyle(fontSize: 18)),
            trailing: widget.expandableContent != null
                ? Icon(_isExpanded ? Icons.expand_less : Icons.expand_more)
                : Icon(Icons.arrow_forward_ios),
            onTap: _handleTap,
          ),
          AnimatedCrossFade(
            firstChild: SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: widget.expandableContent,
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
