import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../consts.dart';
import '../pageutills/categoryWise.dart';
import 'HomePage.dart';
import 'NotificationsPage.dart';
import 'PostAdsPage.dart';
import 'ProfilePage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    const HomePage(),
    const PostAdsPage(),
    const NotificationsPage(),
  ];

  final List<Map<String, dynamic>> drawerItems = [
    {"title": "Property", "icon": Icons.home},
    {"title": "Vehicle", "icon": Icons.directions_car},
    {"title": "Furniture", "icon": Icons.chair},
    {"title": "Appliances", "icon": Icons.kitchen},
    {"title": "Hotels", "icon": Icons.hotel},
    {"title": "Home Stay", "icon": Icons.house},
    {"title": "Clothes", "icon": Icons.checkroom},
    {"title": "Yachts and Helicopters", "icon": Icons.airplanemode_active},
    {"title": "Tools", "icon": Icons.build},
  ];

  final TextStyle itemTextStyle = const TextStyle(
    fontWeight: FontWeight.w500,
    color: AppColors.primaryTextColor,
    fontSize: 18,
    letterSpacing: 1,
  );

  void _onDrawerItemTap(int index) {
    String selectedCategory = drawerItems[index]["title"];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryWise(categoryName: selectedCategory), // Navigate to CategoryPage with category name
      ),
    );
    _scaffoldKey.currentState?.closeDrawer(); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 65,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            height: 1.0,
            color: AppColors.dividerColor.withOpacity(0.5),
          ),
        ),
        leading: IconButton(
          icon: Icon(CupertinoIcons.bars, size: 30, color: Colors.grey.shade800),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              child: Icon(CupertinoIcons.profile_circled, size: 30, color: Colors.grey.shade800),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              ),
            ),
          ),
        ],
        title: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Image(
            image: AssetImage('assets/logo.png'), // Replace with your logo file path
            width: 110, // Adjust size as needed
            height: 110,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.dividerColor.withOpacity(0.5),
              width: 1.0,
            ),
          ),
        ),
        child: NavigationBar(
          indicatorColor: AppColors.navbarPillColor,
          selectedIndex: _selectedIndex,
          elevation: 0,
          destinations: const [
            NavigationDestination(icon: Icon(LineIcons.home, color: Colors.black), label: 'Home'),
            NavigationDestination(icon: Icon(LineIcons.bullhorn, color: Colors.black), label: 'Post Ads'),
            NavigationDestination(icon: Icon(LineIcons.bell, color: Colors.black), label: 'Notifications'),
          ],
          onDestinationSelected: (index) => setState(() {
            _selectedIndex = index;
          }),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: drawerItems.map((item) {
                return ListTile(
                  leading: Icon(item["icon"] as IconData, color: Colors.black),
                  title: Text(item["title"] as String, style: itemTextStyle),
                  onTap: () => _onDrawerItemTap(drawerItems.indexOf(item)),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
