import 'package:flutter/material.dart';
import 'package:try_test/constant/user_constant.dart';
import 'package:try_test/pages/settingsPage.dart';
import 'package:try_test/pages/splashScreen.dart';
import '../chat/chat_list_lookingfor_screen.dart';
import '../chat/chat_list_rentreq_screen.dart';
import '../chat/chat_list_screen.dart';
import '../consts.dart';
import '../pageutills/myAdsReviews.dart';
import '../pageutills/myAdspage.dart';
import '../pageutills/myProfileUpdate.dart';
import '../pageutills/mySubscription.dart';
import '../pageutills/subscriptionPlan.dart';
import 'Postadswithnavbar.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isAppBarCollapsed = false;
  int? userId;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }
  Future<void> _getUserData() async {
    
    userId = UserConstant.USER_ID ?? 1;
    setState(() {}); // Call setState to update the UI if `id` is being used there
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo is ScrollUpdateNotification) {
            setState(() {
              _isAppBarCollapsed =
                  scrollInfo.metrics.pixels > 200; // Adjust threshold as needed
            });
          }
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 350, // Adjust as needed
              flexibleSpace: FlexibleSpaceBar(
                background: const _TopPortion(),
                title: _isAppBarCollapsed
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 8),
                          Text("My Profile"),
                        ],
                      )
                    : null,
                centerTitle: false,
                collapseMode: CollapseMode.parallax,
              ),
              pinned: true,
              floating: true, // Allows the app bar to reappear on scroll up
              snap: true, // Makes the app bar snap into view
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Divider(),
                        const _SectionHeader(text: 'Ads'),
                        _ProfileOptionItem(
                          icon: Icons.add_circle_outline,
                          text: 'Post Ad',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PostAdsWithNavPage(),
                              ),
                            );
                          },
                        ),
                        _ProfileOptionItem(
                          icon: Icons.shopping_bag,
                          text: 'My Ads',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyAdsPage(),
                              ),
                            );
                          },
                        ),

                        const Divider(),
                        const _SectionHeader(text: 'Subscription Plans'),
                        _ProfileOptionItem(
                          icon: Icons.new_releases,
                          text: 'New Plan',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SubscriptionPlanPage(),
                              ),
                            );
                          },
                        ),
                        _ProfileOptionItem(
                          icon: Icons.subscriptions,
                          text: 'My Subscription',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MySubscriptionPage(),
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        const _SectionHeader(text: 'Ads Reviews'),
                        _ProfileOptionItem(
                          icon: Icons.rate_review,
                          text: 'My Ads Reviews',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyReviewPage(),
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        const _SectionHeader(text: 'Profile'),
                        _ProfileOptionItem(
                          icon: Icons.person,
                          text: 'Profile',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UpdateProfilePage(),
                              ),
                            );
                          },
                        ),
                        // _ProfileOptionItem(
                        //   icon: Icons.settings,
                        //   text: 'Settings',
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => const SettingsPage(heading: 'Settings'),
                        //       ),
                        //     );
                        //   },
                        // ),
                        const Divider(),
                        const _SectionHeader(text: 'My Chats'),
                        _ProfileOptionItem(
                          icon: Icons.request_page,
                          text: 'Rent Request',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatListRentreqScreen(),
                              ),
                            );
                          },
                        ),
                        _ProfileOptionItem(
                          icon: Icons.search,
                          text: 'Looking For',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatListLookingforScreen(),
                              ),
                            );
                          },
                        ),

                        const Divider(),
                        _ProfileOptionItem(
                          icon: Icons.logout,
                          text: 'Logout',
                          onTap: () async {
                            

                            UserConstant.clearUserData();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SplashScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(
                            height: 100), // Add some padding at the bottom
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _GradientButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  ChatListScreen(),
                  ),
                );
              },
              label: "My Chats",
              icon: Icons.message_rounded,
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryTextColor,
                  AppColors.primaryColor,
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            _GradientButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PostAdsWithNavPage(),
                  ),
                );
              },
              label: "Post Ads",
              icon: Icons.person_add_alt_1,
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryTextColor,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final Gradient gradient;

  const _GradientButton({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ProfileOptionItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ProfileOptionItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryTextColor,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Center(
        child: SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'A', // Replace 'A' with dynamic text if needed
                    style: TextStyle(
                      fontSize: 80,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UpdateProfilePage(),
                          ),
                        );
                      // Add your edit action here
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
