import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonDecode

import '../../consts.dart';

class CarouselSlider extends StatefulWidget {
  const CarouselSlider({Key? key}) : super(key: key);

  @override
  _CarouselSliderState createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider> {
  int activeIndex = 0;
  final PageController pageController = PageController(viewportFraction: 1);
  List<String> images = []; // Initialize as an empty list

  @override
  void initState() {
    super.initState();
    _fetchBannerImages(); // Fetch images on initialization
  }

  Future<void> _fetchBannerImages() async {
    final url = '${AppConstant.API_URL}api/v1/banner/all-banner';

    try {
      final response = await http.get(Uri.parse(url));
       print(response.body);
       print(response.statusCode);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List<dynamic> results = data['results'];
          setState(() {
            images = results.map((banner) => banner['link'] as String).toList();
          });
        } else {
          // Handle the case where the success key is false
          print('Failed to fetch banners: ${data['message']}');
        }
      } else {
        // Handle response errors
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error fetching banners: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return images.isEmpty
        ? Center(child: CircularProgressIndicator()) // Show loading spinner if images are not yet fetched
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
                    borderRadius: BorderRadius.circular(20)),
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
