import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../consts.dart';

class CarouselSlider extends StatefulWidget {
  const CarouselSlider({Key? key}) : super(key: key);

  @override
  _CarouselSliderState createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider> {
  int activeIndex = 0;
  final PageController pageController = PageController(viewportFraction: 1);
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    _loadStoredImages();      // Load from SharedPreferences first
    _fetchBannerImages();     // Then fetch from backend to update
  }

  /// Load banner image URLs from SharedPreferences (temporary cache)
  Future<void> _loadStoredImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cachedImages = prefs.getStringList('banner_images');

    if (cachedImages != null && cachedImages.isNotEmpty) {
      setState(() {
        images = cachedImages;
      });
    }
  }

  /// Fetch fresh images from backend and update SharedPreferences + UI
  Future<void> _fetchBannerImages() async {
    final url = '${AppConstant.API_URL}api/v1/banner/all-banner';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List<dynamic> results = data['results'];
          final List<String> fetchedImages =
          results.map((banner) => banner['link'] as String).toList();

          if (mounted) {
            setState(() {
              images = fetchedImages;
            });
          }

          // Store in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setStringList('banner_images', fetchedImages);
        } else {
          print('Backend returned failure: ${data['message']}');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching banners: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return images.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Stack(
      children: [
        SizedBox(
          height: 230.0,
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                activeIndex = index;
              });
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.network(
                  images[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Center(
            child: AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: images.length,
              effect: const SlideEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: AppColors.backgroundColor,
                dotColor: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
