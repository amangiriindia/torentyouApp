import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import '../components/sideDrawer.dart';
import '../consts.dart';
import '../pageutills/notification_screen.dart';
import 'HomePage.dart';
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
    const NotificationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 65.h,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            height: 1.h,
            color: AppColors.dividerColor.withOpacity(0.5),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.bars,
            size: 30.sp,
            color: Colors.grey.shade800,
          ),
          onPressed: () {
            print('Drawer icon tapped - opening drawer');
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              child: Icon(
                CupertinoIcons.profile_circled,
                size: 30.sp,
                color: Colors.grey.shade800,
              ),
              onTap: () {
                print('Profile icon tapped - navigating to ProfilePage');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
          ),
        ],
        title: Padding(
          padding: EdgeInsets.all(20.w),
          child: Image(
            image: const AssetImage('assets/logo.png'),
            width: 110.w,
            height: 110.h,
            errorBuilder: (context, error, stackTrace) => Text(
              'Logo',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.dividerColor.withOpacity(0.5),
              width: 1.h,
            ),
          ),
        ),
        child: NavigationBar(
          indicatorColor: AppColors.navbarPillColor,
          selectedIndex: _selectedIndex,
          elevation: 0,
          destinations: [
            NavigationDestination(
              icon: Icon(LineIcons.home, color: Colors.black, size: 24.sp),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(LineIcons.bullhorn, color: Colors.black, size: 24.sp),
              label: 'Post Ads',
            ),
            NavigationDestination(
              icon: Icon(LineIcons.bell, color: Colors.black, size: 24.sp),
              label: 'Notifications',
            ),
          ],
          onDestinationSelected: (index) {
            print('Navigation item selected: $index');
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      drawer: SideDrawer(scaffoldKey: _scaffoldKey),
      body: _pages[_selectedIndex],
    );
  }
}