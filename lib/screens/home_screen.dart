import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studio_management/screens/asset_list_screen.dart';
import 'package:studio_management/screens/booking_screen.dart';
import 'package:studio_management/screens/studio_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        primaryColor: Colors.blue[700],
        colorScheme: ColorScheme.dark(
          primary: Colors.blue[700]!,
          secondary: Colors.blue[400]!,
          surface: Colors.grey[900]!,
          background: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors.grey[900],
        ),
        cardTheme: CardTheme(
          color: Colors.grey[850],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      child: Scaffold(
        appBar: _buildAppBar(),
        drawer: _buildDrawer(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Studio Management'),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[700]!,
              Colors.blue[900]!,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue[700]!,
                    Colors.blue[900]!,
                  ],
                ),
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.blue),
              title: const Text('Settings'),
              onTap: () {
                // Navigate to settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.blue),
              title: const Text('Help & Support'),
              onTap: () {
                // Navigate to help & support
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.blue),
              title: const Text('Logout'),
              onTap: () {
                // Handle logout
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.music_note,
        'title': 'Studios',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StudioListScreen()),
            ),
      },
      {
        'icon': Icons.calendar_today,
        'title': 'Bookings',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BookingScreen()),
            ),
      },
      {
        'icon': Icons.devices,
        'title': 'Assets',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AssetListScreen()),
            ),
      },
      {
        'icon': Icons.star,
        'title': 'Feedback',
        'onTap': () {
          // Navigate to feedback screen
        },
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  (index / menuItems.length) * 0.5,
                  1.0,
                  curve: Curves.easeOut,
                ),
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.5, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    (index / menuItems.length) * 0.5,
                    1.0,
                    curve: Curves.easeOut,
                  ),
                )),
                child: child,
              ),
            );
          },
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: item['onTap'],
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item['icon'],
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue[400],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
