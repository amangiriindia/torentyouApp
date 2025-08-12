// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../components/ProductCard.dart';
// import '../components/no_data_found.dart';
// import '../constant/india_states_and_cities.dart';
// import '../consts.dart';
// import '../service/product_service.dart';
// import 'ProductDetailsPage.dart';
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});
//
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   final TextEditingController _customLocationController = TextEditingController();
//   final ProductService _productService = ProductService();
//
//   List<dynamic> products = [];
//   List<dynamic> allProducts = [];
//   List<Map<String, dynamic>> categories = [];
//   List<Map<String, dynamic>> subcategories = [];
//   bool isLoading = false;
//   bool isCategoriesLoading = true;
//   bool isSubcategoriesLoading = false;
//   bool isInitialLoad = true;
//
//   // Filter values
//   RangeValues _priceRange = RangeValues(0, 50000);
//   String? selectedCategory;
//   String? selectedSubcategory;
//   String? selectedState;
//   String? selectedCity;
//   bool showCustomLocationField = false;
//   double minPrice = 0;
//   double maxPrice = 50000;
//   bool isGettingLocation = false;
//
//   // Filter visibility
//   bool isFilterVisible = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }
//
//   // Initialize data - load cached data and fetch fresh data
//   Future<void> _initializeData() async {
//     await _loadCachedData();
//     await Future.wait([
//       fetchCategories(),
//       fetchAllProducts(),
//     ]);
//   }
//
//   // Load cached data
//   Future<void> _loadCachedData() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     // Load cached categories
//     final cachedCategories = prefs.getString('rental_categories');
//     if (cachedCategories != null) {
//       setState(() {
//         categories = List<Map<String, dynamic>>.from(jsonDecode(cachedCategories));
//         isCategoriesLoading = false;
//       });
//     }
//
//     // Load cached products
//     final cachedProducts = prefs.getString('all_products');
//     if (cachedProducts != null) {
//       final productsList = List<dynamic>.from(jsonDecode(cachedProducts));
//       setState(() {
//         allProducts = productsList;
//         products = productsList;
//         isLoading = false;
//         isInitialLoad = false;
//       });
//       updatePriceRange();
//     }
//   }
//
//   // Fetch all products from API
//   Future<void> fetchAllProducts() async {
//     if (!isInitialLoad) {
//       setState(() => isLoading = true);
//     }
//
//     const url = 'https://trytest-xcqt.onrender.com/api/v1/product/get-all';
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success']) {
//           final List<dynamic> fetchedProducts = data['results'];
//
//           if (mounted) {
//             setState(() {
//               allProducts = fetchedProducts;
//               products = fetchedProducts;
//               isLoading = false;
//               isInitialLoad = false;
//             });
//           }
//
//           // Cache products
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('all_products', jsonEncode(fetchedProducts));
//
//           updatePriceRange();
//         }
//       } else {
//         throw Exception('Failed to load products');
//       }
//     } catch (e) {
//       print('Error fetching products: $e');
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//           isInitialLoad = false;
//         });
//       }
//
//       // Show error only if no cached data
//       if (allProducts.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Error loading products. Please try again.',
//               style: TextStyle(fontSize: 14.sp),
//             ),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 3),
//           ),
//         );
//       }
//     }
//   }
//
//   // Fetch categories from API
//   Future<void> fetchCategories() async {
//     const url = '${AppConstant.API_URL}api/v1/category/all-category';
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success']) {
//           final List<Map<String, dynamic>> fetchedCategories =
//           List<Map<String, dynamic>>.from(data['results'].map((category) {
//             return {
//               'id': category['id'] ?? 0,
//               'name': category['c_name'],
//             };
//           }));
//
//           if (mounted) {
//             setState(() {
//               categories = fetchedCategories;
//               isCategoriesLoading = false;
//             });
//           }
//
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('rental_categories', jsonEncode(fetchedCategories));
//         }
//       } else {
//         throw Exception('Failed to load categories');
//       }
//     } catch (e) {
//       print('Error fetching categories: $e');
//       setState(() {
//         isCategoriesLoading = false;
//       });
//     }
//   }
//
//   // Fetch subcategories for a selected category
//   Future<void> fetchSubcategories(String categoryId) async {
//     setState(() {
//       isSubcategoriesLoading = true;
//       subcategories = [];
//       selectedSubcategory = null;
//     });
//
//     final url = '${AppConstant.API_URL}api/v1/subcategory/single-subcategory/$categoryId';
//     try {
//       final response = await http.get(Uri.parse(url));
//       print('Subcategory API Response: ${response.body}');
//       print('Status Code: ${response.statusCode}');
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success']) {
//           final List<Map<String, dynamic>> fetchedSubcategories =
//           List<Map<String, dynamic>>.from(data['data'].map((subcategory) {
//             return {
//               'id': subcategory['id'] ?? 0,
//               'name': subcategory['subcategory_name'] ?? 'Unknown',
//             };
//           }));
//
//           if (mounted) {
//             setState(() {
//               subcategories = fetchedSubcategories;
//               isSubcategoriesLoading = false;
//             });
//           }
//
//           // Cache subcategories
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('subcategories_$categoryId', jsonEncode(fetchedSubcategories));
//         } else {
//           throw Exception('API success is false');
//         }
//       } else {
//         throw Exception('Failed to load subcategories: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching subcategories: $e');
//       setState(() {
//         isSubcategoriesLoading = false;
//       });
//
//       // Try to load cached subcategories
//       final prefs = await SharedPreferences.getInstance();
//       final cachedSubcategories = prefs.getString('subcategories_$categoryId');
//       if (cachedSubcategories != null) {
//         setState(() {
//           subcategories = List<Map<String, dynamic>>.from(jsonDecode(cachedSubcategories));
//           isSubcategoriesLoading = false;
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Failed to load subcategories. Please try again.',
//               style: TextStyle(fontSize: 14.sp),
//             ),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 3),
//           ),
//         );
//       }
//     }
//   }
//
//   // Get current location
//   Future<void> _getCurrentLocation() async {
//     setState(() {
//       isGettingLocation = true;
//     });
//
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         throw Exception('Location services are disabled.');
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw Exception('Location permissions are denied.');
//         }
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         throw Exception('Location permissions are permanently denied.');
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       String? city = await _getCityFromCoordinates(position.latitude, position.longitude);
//       String? state = city != null ? IndiaStatesAndCities.getStateForCity(city) : null;
//
//       if (city != null && state != null) {
//         setState(() {
//           selectedState = state;
//           selectedCity = city;
//           showCustomLocationField = false;
//           _customLocationController.clear();
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Unable to determine city from location.',
//               style: TextStyle(fontSize: 14.sp),
//             ),
//             backgroundColor: Colors.orange,
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error getting location: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Error getting location: $e',
//             style: TextStyle(fontSize: 14.sp),
//           ),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     } finally {
//       setState(() {
//         isGettingLocation = false;
//       });
//     }
//   }
//
//   // Placeholder for reverse geocoding
//   Future<String?> _getCityFromCoordinates(double latitude, double longitude) async {
//     // Implement reverse geocoding here using a service like Google Maps API
//     return null;
//   }
//
//   // Get the final location value to use for search
//   String? getFinalLocationValue() {
//     if (showCustomLocationField) {
//       return _customLocationController.text.trim().isEmpty
//           ? null
//           : _customLocationController.text.trim();
//     }
//     return selectedCity;
//   }
//
//   // Filter products locally
//   void filterProducts() {
//     setState(() => isLoading = true);
//
//     List<dynamic> filteredProducts = List.from(allProducts);
//
//     // Apply search term filter
//     if (_searchController.text.isNotEmpty) {
//       final searchTerm = _searchController.text.toLowerCase();
//       filteredProducts = filteredProducts.where((product) {
//         final productName = (product['product_name'] ?? '').toString().toLowerCase();
//         final tags = (product['tags'] ?? '').toString().toLowerCase();
//         final description = (product['short_description'] ?? '').toString().toLowerCase();
//         return productName.contains(searchTerm) ||
//             tags.contains(searchTerm) ||
//             description.contains(searchTerm);
//       }).toList();
//     }
//
//     // Apply category filter
//     if (selectedCategory != null) {
//       filteredProducts = filteredProducts.where((product) {
//         return product['category_id'].toString() == selectedCategory;
//       }).toList();
//     }
//
//     // Apply subcategory filter
//     if (selectedSubcategory != null) {
//       filteredProducts = filteredProducts.where((product) {
//         return product['subcategory'].toString() == selectedSubcategory;
//       }).toList();
//     }
//
//     // Apply price range filter
//     filteredProducts = filteredProducts.where((product) {
//       final price = double.tryParse(product['monthly_rental']?.toString() ?? '0') ?? 0;
//       return price >= _priceRange.start && price <= _priceRange.end;
//     }).toList();
//
//     // Apply location filter
//     final locationFilter = getFinalLocationValue();
//     if (locationFilter != null && locationFilter.isNotEmpty) {
//       filteredProducts = filteredProducts.where((product) {
//         final productLocation = (product['location'] ?? '').toString().toLowerCase();
//         return productLocation.contains(locationFilter.toLowerCase());
//       }).toList();
//     }
//
//     setState(() {
//       products = filteredProducts;
//       isLoading = false;
//     });
//   }
//
//   // Search products (now filters locally)
//   Future<void> searchProducts(
//       String searchTerm, {
//         String? categoryId,
//         String? subcategoryId,
//         double? priceMin,
//         double? priceMax,
//         String? location,
//       }) async {
//     filterProducts();
//   }
//
//   // Update price range based on current products
//   void updatePriceRange() {
//     if (allProducts.isEmpty) return;
//
//     double min = double.infinity;
//     double max = 0;
//
//     for (var product in allProducts) {
//       double price = double.tryParse(product['monthly_rental']?.toString() ?? '0') ?? 0;
//       if (price < min) min = price;
//       if (price > max) max = price;
//     }
//
//     if (mounted) {
//       setState(() {
//         minPrice = min == double.infinity ? 0 : min;
//         maxPrice = max == 0 ? 50000 : max;
//         if (_priceRange.start == 0 && _priceRange.end == 50000) {
//           _priceRange = RangeValues(minPrice, maxPrice);
//         }
//       });
//     }
//   }
//
//   // Clear all filters
//   void clearAllFilters() {
//     setState(() {
//       selectedCategory = null;
//       selectedSubcategory = null;
//       subcategories = [];
//       selectedState = null;
//       selectedCity = null;
//       showCustomLocationField = false;
//       _customLocationController.clear();
//       _priceRange = RangeValues(minPrice, maxPrice);
//       _searchController.clear();
//       products = List.from(allProducts);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 50.h,
//             floating: true,
//             pinned: true,
//             flexibleSpace: Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.primaryColor,
//                     AppColors.primaryTextColor,
//                   ],
//                 ),
//               ),
//               child: FlexibleSpaceBar(
//                 title: Text(
//                   'Search Products',
//                   style: TextStyle(fontSize: 18.sp),
//                 ),
//                 background: Container(
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         AppColors.primaryColor,
//                         AppColors.primaryTextColor,
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Container(
//               color: Colors.white,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.all(16.w),
//                     child: Column(
//                       children: [
//                         // Search Bar
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12.r),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.2),
//                                 spreadRadius: 1.r,
//                                 blurRadius: 5.r,
//                               ),
//                             ],
//                           ),
//                           child: TextField(
//                             controller: _searchController,
//                             decoration: InputDecoration(
//                               hintText: 'Search products...',
//                               prefixIcon: const Icon(Icons.search),
//                               suffixIcon: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   if (_searchController.text.isNotEmpty)
//                                     IconButton(
//                                       icon: const Icon(Icons.clear),
//                                       onPressed: () {
//                                         _searchController.clear();
//                                         filterProducts();
//                                       },
//                                     ),
//                                   IconButton(
//                                     icon: Icon(
//                                       Icons.filter_list,
//                                       color: isFilterVisible
//                                           ? AppColors.primaryColor
//                                           : Colors.grey,
//                                     ),
//                                     onPressed: () {
//                                       setState(() {
//                                         isFilterVisible = !isFilterVisible;
//                                       });
//                                     },
//                                   ),
//                                 ],
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.r),
//                                 borderSide: BorderSide.none,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                             ),
//                             style: TextStyle(fontSize: 16.sp),
//                             onSubmitted: (value) => filterProducts(),
//                             onChanged: (value) {
//                               if (value.isEmpty) {
//                                 filterProducts();
//                               }
//                             },
//                           ),
//                         ),
//
//                         // Filter Section
//                         AnimatedContainer(
//                           duration: const Duration(milliseconds: 300),
//                           height: isFilterVisible
//                               ? (showCustomLocationField
//                               ? (selectedCategory != null ? 620.h : 550.h)
//                               : (selectedCategory != null ? 550.h : 480.h))
//                               : 0,
//                           child: SingleChildScrollView(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(height: 16.h),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       'Filters',
//                                       style: TextStyle(
//                                         fontSize: 18.sp,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     TextButton(
//                                       onPressed: clearAllFilters,
//                                       child: Text(
//                                         'Clear All',
//                                         style: TextStyle(fontSize: 14.sp),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 16.h),
//
//                                 // Category Dropdown
//                                 isCategoriesLoading
//                                     ? const Center(child: CircularProgressIndicator())
//                                     : DropdownButtonFormField<String>(
//                                   decoration: InputDecoration(
//                                     labelText: 'Category',
//                                     prefixIcon: const Icon(Icons.category),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12.r),
//                                     ),
//                                     labelStyle: TextStyle(fontSize: 14.sp),
//                                   ),
//                                   value: selectedCategory,
//                                   hint: Text(
//                                     'Select Category',
//                                     style: TextStyle(fontSize: 14.sp),
//                                   ),
//                                   items: categories.map((category) {
//                                     return DropdownMenuItem<String>(
//                                       value: category['id'].toString(),
//                                       child: Text(
//                                         category['name'],
//                                         style: TextStyle(fontSize: 14.sp),
//                                       ),
//                                     );
//                                   }).toList(),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       selectedCategory = value;
//                                       selectedSubcategory = null;
//                                       subcategories = [];
//                                       if (value != null) {
//                                         fetchSubcategories(value);
//                                       }
//                                     });
//                                   },
//                                 ),
//                                 SizedBox(height: 16.h),
//
//                                 // Subcategory Dropdown
//                                 if (selectedCategory != null)
//                                   isSubcategoriesLoading
//                                       ? Padding(
//                                     padding: EdgeInsets.symmetric(vertical: 8.h),
//                                     child: const Center(child: CircularProgressIndicator()),
//                                   )
//                                       : DropdownButtonFormField<String>(
//                                     decoration: InputDecoration(
//                                       labelText: 'Subcategory',
//                                       prefixIcon: const Icon(Icons.category_outlined),
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12.r),
//                                       ),
//                                       labelStyle: TextStyle(fontSize: 14.sp),
//                                     ),
//                                     value: selectedSubcategory,
//                                     hint: Text(
//                                       'Select Subcategory',
//                                       style: TextStyle(fontSize: 14.sp),
//                                     ),
//                                     items: subcategories.isEmpty
//                                         ? [
//                                       DropdownMenuItem<String>(
//                                         value: null,
//                                         child: Text(
//                                           'No subcategories available',
//                                           style: TextStyle(fontSize: 14.sp),
//                                         ),
//                                       ),
//                                     ]
//                                         : subcategories.map((subcategory) {
//                                       return DropdownMenuItem<String>(
//                                         value: subcategory['id'].toString(),
//                                         child: Text(
//                                           subcategory['name'],
//                                           style: TextStyle(fontSize: 14.sp),
//                                         ),
//                                       );
//                                     }).toList(),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         selectedSubcategory = value;
//                                       });
//                                     },
//                                   ),
//                                 SizedBox(height: 16.h),
//
//                                 // State Dropdown
//                                 DropdownButtonFormField<String>(
//                                   decoration: InputDecoration(
//                                     labelText: 'State',
//                                     prefixIcon: const Icon(Icons.location_city),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12.r),
//                                     ),
//                                     labelStyle: TextStyle(fontSize: 14.sp),
//                                   ),
//                                   value: selectedState,
//                                   hint: Text(
//                                     'Select State',
//                                     style: TextStyle(fontSize: 14.sp),
//                                   ),
//                                   items: IndiaStatesAndCities.getAllStates().map((state) {
//                                     return DropdownMenuItem<String>(
//                                       value: state,
//                                       child: Text(
//                                         state,
//                                         style: TextStyle(fontSize: 14.sp),
//                                       ),
//                                     );
//                                   }).toList(),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       selectedState = value;
//                                       selectedCity = null;
//                                       showCustomLocationField = value == 'custom';
//                                       if (value != 'custom') {
//                                         _customLocationController.clear();
//                                       }
//                                     });
//                                   },
//                                 ),
//                                 SizedBox(height: 16.h),
//
//                                 // City Dropdown
//                                 if (selectedState != null && selectedState != 'custom')
//                                   DropdownButtonFormField<String>(
//                                     decoration: InputDecoration(
//                                       labelText: 'City',
//                                       prefixIcon: const Icon(Icons.location_on),
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12.r),
//                                       ),
//                                       labelStyle: TextStyle(fontSize: 14.sp),
//                                     ),
//                                     value: selectedCity,
//                                     hint: Text(
//                                       'Select City',
//                                       style: TextStyle(fontSize: 14.sp),
//                                     ),
//                                     items: IndiaStatesAndCities.getCitiesForState(selectedState!)
//                                         .map((city) {
//                                       return DropdownMenuItem<String>(
//                                         value: city,
//                                         child: Text(
//                                           city,
//                                           style: TextStyle(fontSize: 14.sp),
//                                         ),
//                                       );
//                                     }).toList(),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         selectedCity = value;
//                                         showCustomLocationField = value == 'custom';
//                                         if (value != 'custom') {
//                                           _customLocationController.clear();
//                                         }
//                                       });
//                                     },
//                                   ),
//                                 SizedBox(height: 16.h),
//
//                                 // Custom Location Field
//                                 if (showCustomLocationField)
//                                   Column(
//                                     children: [
//                                       TextField(
//                                         controller: _customLocationController,
//                                         decoration: InputDecoration(
//                                           labelText: 'Enter Custom Location',
//                                           prefixIcon: const Icon(Icons.edit_location),
//                                           border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(12.r),
//                                           ),
//                                           hintText: 'e.g., Lucknow, Indore, etc.',
//                                           labelStyle: TextStyle(fontSize: 14.sp),
//                                           hintStyle: TextStyle(fontSize: 14.sp),
//                                         ),
//                                         style: TextStyle(fontSize: 14.sp),
//                                       ),
//                                       SizedBox(height: 16.h),
//                                     ],
//                                   ),
//
//                                 // Get Current Location Button
//                                 SizedBox(
//                                   width: double.infinity,
//                                   child: ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: AppColors.primaryColor,
//                                       foregroundColor: Colors.white,
//                                       padding: EdgeInsets.symmetric(vertical: 16.h),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(12.r),
//                                       ),
//                                     ),
//                                     onPressed: isGettingLocation ? null : _getCurrentLocation,
//                                     child: isGettingLocation
//                                         ? const CircularProgressIndicator(color: Colors.white)
//                                         : Text(
//                                       'Get My Current Location',
//                                       style: TextStyle(
//                                         fontSize: 16.sp,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 16.h),
//
//                                 // Price Range Slider
//                                 Text(
//                                   'Price Range',
//                                   style: TextStyle(
//                                     fontSize: 16.sp,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8.h),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       '₹${_priceRange.start.round()}',
//                                       style: TextStyle(fontSize: 14.sp),
//                                     ),
//                                     Text(
//                                       '₹${_priceRange.end.round()}',
//                                       style: TextStyle(fontSize: 14.sp),
//                                     ),
//                                   ],
//                                 ),
//                                 RangeSlider(
//                                   values: _priceRange,
//                                   min: 0,
//                                   max: maxPrice > 50000 ? maxPrice : 50000,
//                                   divisions: 500,
//                                   activeColor: AppColors.primaryColor,
//                                   labels: RangeLabels(
//                                     '₹${_priceRange.start.round()}',
//                                     '₹${_priceRange.end.round()}',
//                                   ),
//                                   onChanged: (RangeValues values) {
//                                     setState(() {
//                                       _priceRange = values;
//                                     });
//                                   },
//                                 ),
//                                 SizedBox(height: 16.h),
//
//                                 // Apply Filter Button
//                                 SizedBox(
//                                   width: double.infinity,
//                                   child: ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: AppColors.primaryColor,
//                                       foregroundColor: Colors.white,
//                                       padding: EdgeInsets.symmetric(vertical: 16.h),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(12.r),
//                                       ),
//                                     ),
//                                     onPressed: () {
//                                       filterProducts();
//                                       setState(() {
//                                         isFilterVisible = false;
//                                       });
//                                     },
//                                     child: Text(
//                                       'Apply Filters',
//                                       style: TextStyle(
//                                         fontSize: 16.sp,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Products Grid
//                   if (isLoading && isInitialLoad)
//                     Padding(
//                       padding: EdgeInsets.all(50.w),
//                       child: const Center(child: CircularProgressIndicator()),
//                     )
//                   else if (products.isEmpty && !isLoading)
//                     NoDataFound(
//                       message: 'No products found',
//                     )
//                   else
//                     Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16.w),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 '${products.length} products found',
//                                 style: TextStyle(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               if (products.length > 4)
//                                 TextButton(
//                                   onPressed: () {
//                                     // Navigate to view all products
//                                   },
//                                   child: Text(
//                                     'View All',
//                                     style: TextStyle(fontSize: 14.sp),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(16.w),
//                           child: GridView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               childAspectRatio: 0.5,
//                               mainAxisSpacing: 15.w,
//                               crossAxisSpacing: 15.w,
//                             ),
//                             itemCount: products.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               final product = products[index];
//
//                               final String title = product['product_name'] ?? 'Unknown';
//                               final String price = "₹${product['monthly_rental']}/Month";
//
//                               final int productId = product['id'];
//                               String image_url = product['image'] ?? '';
//                               String image;
//
//                               if (!image_url.startsWith("https://")) {
//                                 image = "https://www.torentyou.com/admin/uploads/$image_url";
//                               } else {
//                                 image = image_url;
//                               }
//
//                               return ProductCard(
//                                 title: title,
//                                 imageUrl: image,
//                                 price: price,
//                                 category: product['category_id'].toString(),
//                                 onRentNow: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => ProductDetailsPage(
//                                         productId: productId,
//                                         image: image,
//                                         categoryId: product['category_id'],
//                                         subcategoryId: product['subcategory'],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     _customLocationController.dispose();
//     super.dispose();
//   }
// }



import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../components/ProductCard.dart';
import '../components/no_data_found.dart';
import '../constant/india_states_and_cities.dart';
import '../consts.dart';
import '../service/google_map_helper.dart';
import '../service/product_service.dart';
import 'ProductDetailsPage.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customLocationController = TextEditingController();
  final ProductService _productService = ProductService();

  List<dynamic> products = [];
  List<dynamic> allProducts = [];
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> subcategories = [];
  bool isLoading = false;
  bool isCategoriesLoading = true;
  bool isSubcategoriesLoading = false;
  bool isInitialLoad = true;

  // Filter values
  RangeValues _priceRange = RangeValues(0, 50000);
  String? selectedCategory;
  String? selectedSubcategory;
  String? selectedState;
  String? selectedCity;
  bool showCustomLocationField = false;
  double minPrice = 0;
  double maxPrice = 50000;
  bool isGettingLocation = false;

  // Location coordinates for API
  String? addLatitude;
  String? addLongitude;

  // Filter visibility
  bool isFilterVisible = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// Initialize data - load cached data and fetch fresh data
  Future<void> _initializeData() async {
    await _loadCachedData();
    await Future.wait([
      fetchCategories(),
      fetchAllProducts(),
    ]);
  }

  /// Load cached data from SharedPreferences
  Future<void> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load cached categories
    final cachedCategories = prefs.getString('rental_categories');
    if (cachedCategories != null) {
      setState(() {
        categories = List<Map<String, dynamic>>.from(jsonDecode(cachedCategories));
        isCategoriesLoading = false;
      });
    }

    // Load cached products
    final cachedProducts = prefs.getString('all_products');
    if (cachedProducts != null) {
      final productsList = List<dynamic>.from(jsonDecode(cachedProducts));
      setState(() {
        allProducts = productsList;
        products = productsList;
        isLoading = false;
        isInitialLoad = false;
      });
      updatePriceRange();
    }
  }

  /// Fetch all products from API
  Future<void> fetchAllProducts() async {
    if (!isInitialLoad) {
      setState(() => isLoading = true);
    }

    const url = 'https://trytest-xcqt.onrender.com/api/v1/product/get-all';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final List<dynamic> fetchedProducts = data['results'];

          if (mounted) {
            setState(() {
              allProducts = fetchedProducts;
              products = fetchedProducts;
              isLoading = false;
              isInitialLoad = false;
            });
          }

          // Cache products
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('all_products', jsonEncode(fetchedProducts));

          updatePriceRange();
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          isInitialLoad = false;
        });
      }

      // Show error only if no cached data
      if (allProducts.isEmpty) {
        _showSnackBar(
          'Error loading products. Please check your internet connection and try again.',
          Colors.red,
          Icons.error_outline,
        );
      }
    }
  }

  /// Fetch categories from API
  Future<void> fetchCategories() async {
    const url = '${AppConstant.API_URL}api/v1/category/all-category';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final List<Map<String, dynamic>> fetchedCategories =
          List<Map<String, dynamic>>.from(data['results'].map((category) {
            return {
              'id': category['id'] ?? 0,
              'name': category['c_name'] ?? 'Unknown Category',
            };
          }));

          if (mounted) {
            setState(() {
              categories = fetchedCategories;
              isCategoriesLoading = false;
            });
          }

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('rental_categories', jsonEncode(fetchedCategories));
        }
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        isCategoriesLoading = false;
      });
    }
  }

  /// Fetch subcategories for a selected category
  Future<void> fetchSubcategories(String categoryId) async {
    setState(() {
      isSubcategoriesLoading = true;
      subcategories = [];
      selectedSubcategory = null;
    });

    final url = '${AppConstant.API_URL}api/v1/subcategory/single-subcategory/$categoryId';
    try {
      final response = await http.get(Uri.parse(url));
      print('Subcategory API Response: ${response.body}');
      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final List<Map<String, dynamic>> fetchedSubcategories =
          List<Map<String, dynamic>>.from(data['data'].map((subcategory) {
            return {
              'id': subcategory['id'] ?? 0,
              'name': subcategory['subcategory_name'] ?? 'Unknown Subcategory',
            };
          }));

          if (mounted) {
            setState(() {
              subcategories = fetchedSubcategories;
              isSubcategoriesLoading = false;
            });
          }

          // Cache subcategories
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('subcategories_$categoryId', jsonEncode(fetchedSubcategories));
        } else {
          throw Exception('API response success is false');
        }
      } else {
        throw Exception('Failed to load subcategories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching subcategories: $e');
      setState(() {
        isSubcategoriesLoading = false;
      });

      // Try to load cached subcategories
      final prefs = await SharedPreferences.getInstance();
      final cachedSubcategories = prefs.getString('subcategories_$categoryId');
      if (cachedSubcategories != null) {
        setState(() {
          subcategories = List<Map<String, dynamic>>.from(jsonDecode(cachedSubcategories));
          isSubcategoriesLoading = false;
        });
      } else {
        _showSnackBar(
          'Failed to load subcategories. Please try again.',
          Colors.red,
          Icons.error_outline,
        );
      }
    }
  }

  /// Update coordinates for API calls
  Future<void> updateCoordinates() async {
    Map<String, double>? location = await GoogleMapHelper.updateAddressForApi();
    if (location != null) {
      setState(() {
        addLatitude = location['latitude']?.toString();
        addLongitude = location['longitude']?.toString();
      });
    } else {
      print("Failed to update location coordinates.");
    }
  }

  /// Update location field with current location using GoogleMapHelper
  Future<void> _updateLocationField() async {
    setState(() {
      isGettingLocation = true;
    });

    try {
      // Get current location coordinates
      Map<String, double>? coordinates = await GoogleMapHelper.updateAddressForApi();

      if (coordinates != null) {
        // Update coordinates for API
        setState(() {
          addLatitude = coordinates['latitude']?.toString();
          addLongitude = coordinates['longitude']?.toString();
        });

        // Get city and state from coordinates
        Map<String, String?> locationData = await GoogleMapHelper.getCityAndStateFromCoordinates(
          coordinates['latitude']!,
          coordinates['longitude']!,
        );

        String? city = locationData['city'];
        String? state = locationData['state'];

        if (city != null && state != null) {
          // Check if the detected city exists in our predefined list
          List<String> availableCities = IndiaStatesAndCities.getCitiesForState(state);
          bool cityExists = availableCities.any((availableCity) =>
          availableCity.toLowerCase() == city.toLowerCase());

          if (cityExists) {
            // City exists in our list, set it normally
            setState(() {
              selectedState = state;
              selectedCity = city;
              showCustomLocationField = false;
              _customLocationController.clear();
            });

            _showSnackBar(
              'Location detected: $city, $state',
              Colors.green,
              Icons.location_on,
            );
          } else {
            // City doesn't exist in our list, use custom location
            setState(() {
              selectedState = state;
              selectedCity = null;
              showCustomLocationField = true;
              _customLocationController.text = city;
            });

            _showSnackBar(
              'Location detected: $city, $state (using custom location)',
              Colors.orange,
              Icons.edit_location,
            );
          }
        } else {
          throw Exception('Unable to determine city and state from location');
        }
      } else {
        throw Exception('Unable to get current location coordinates');
      }
    } catch (e) {
      print('Error getting location: $e');

      // Show more specific error messages
      String errorMessage = 'Error getting location';
      IconData errorIcon = Icons.error_outline;

      if (e.toString().contains('Location services are disabled')) {
        errorMessage = 'Location services are disabled. Please enable them in settings.';
        errorIcon = Icons.location_disabled;
      } else if (e.toString().contains('permissions are denied')) {
        errorMessage = 'Location permission denied. Please grant location access.';
        errorIcon = Icons.location_disabled;
      } else if (e.toString().contains('timeout') || e.toString().contains('time')) {
        errorMessage = 'Location request timed out. Please try again.';
        errorIcon = Icons.timer_off;
      }

      _showSnackBar(errorMessage, Colors.red, errorIcon);

      // Optionally show options to open settings
      _showLocationErrorDialog(e.toString());
    } finally {
      setState(() {
        isGettingLocation = false;
      });
    }
  }

  /// Show location error dialog with options
  void _showLocationErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.location_off, color: Colors.red),
              SizedBox(width: 8.w),
              Text('Location Error'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Unable to get your current location.'),
              SizedBox(height: 8.h),
              Text(
                'Possible solutions:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text('• Enable location services'),
              Text('• Grant location permission'),
              Text('• Ensure GPS is turned on'),
              Text('• Try again in an open area'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await GoogleMapHelper.openLocationSettings();
              },
              child: Text('Open Settings'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateLocationField();
              },
              child: Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  /// Get the final location value to use for search
  String? getFinalLocationValue() {
    if (showCustomLocationField) {
      return _customLocationController.text.trim().isEmpty
          ? null
          : _customLocationController.text.trim();
    }
    return selectedCity;
  }

  /// Filter products locally based on all selected criteria
  void filterProducts() {
    setState(() => isLoading = true);

    List<dynamic> filteredProducts = List.from(allProducts);

    // Apply search term filter
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filteredProducts = filteredProducts.where((product) {
        final productName = (product['product_name'] ?? '').toString().toLowerCase();
        final tags = (product['tags'] ?? '').toString().toLowerCase();
        final description = (product['short_description'] ?? '').toString().toLowerCase();
        return productName.contains(searchTerm) ||
            tags.contains(searchTerm) ||
            description.contains(searchTerm);
      }).toList();
    }

    // Apply category filter
    if (selectedCategory != null) {
      filteredProducts = filteredProducts.where((product) {
        return product['category_id'].toString() == selectedCategory;
      }).toList();
    }

    // Apply subcategory filter
    if (selectedSubcategory != null) {
      filteredProducts = filteredProducts.where((product) {
        return product['subcategory'].toString() == selectedSubcategory;
      }).toList();
    }

    // Apply price range filter
    filteredProducts = filteredProducts.where((product) {
      final price = double.tryParse(product['monthly_rental']?.toString() ?? '0') ?? 0;
      return price >= _priceRange.start && price <= _priceRange.end;
    }).toList();

    // Apply location filter
    final locationFilter = getFinalLocationValue();
    if (locationFilter != null && locationFilter.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        final productLocation = (product['location'] ?? '').toString().toLowerCase();
        return productLocation.contains(locationFilter.toLowerCase());
      }).toList();
    }

    setState(() {
      products = filteredProducts;
      isLoading = false;
    });
  }

  /// Update price range based on current products
  void updatePriceRange() {
    if (allProducts.isEmpty) return;

    double min = double.infinity;
    double max = 0;

    for (var product in allProducts) {
      double price = double.tryParse(product['monthly_rental']?.toString() ?? '0') ?? 0;
      if (price < min) min = price;
      if (price > max) max = price;
    }

    if (mounted) {
      setState(() {
        minPrice = min == double.infinity ? 0 : min;
        maxPrice = max == 0 ? 50000 : max;
        if (_priceRange.start == 0 && _priceRange.end == 50000) {
          _priceRange = RangeValues(minPrice, maxPrice);
        }
      });
    }
  }

  /// Clear all filters and reset to initial state
  void clearAllFilters() {
    setState(() {
      selectedCategory = null;
      selectedSubcategory = null;
      subcategories = [];
      selectedState = null;
      selectedCity = null;
      showCustomLocationField = false;
      _customLocationController.clear();
      _priceRange = RangeValues(minPrice, maxPrice);
      _searchController.clear();
      products = List.from(allProducts);
      // Reset location coordinates
      addLatitude = null;
      addLongitude = null;
    });

    _showSnackBar(
      'All filters cleared successfully!',
      Colors.blue,
      Icons.clear_all,
    );
  }

  /// Show snackbar with custom message, color and icon
  void _showSnackBar(String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  /// Helper method to build filter chips
  Widget _buildFilterChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.blue.shade800,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Sort products based on selected criteria
  void _sortProducts(String sortType) {
    setState(() {
      isLoading = true;
    });

    List<dynamic> sortedProducts = List.from(products);

    switch (sortType) {
      case 'name_asc':
        sortedProducts.sort((a, b) {
          String nameA = (a['product_name'] ?? '').toString().toLowerCase();
          String nameB = (b['product_name'] ?? '').toString().toLowerCase();
          return nameA.compareTo(nameB);
        });
        break;
      case 'name_desc':
        sortedProducts.sort((a, b) {
          String nameA = (a['product_name'] ?? '').toString().toLowerCase();
          String nameB = (b['product_name'] ?? '').toString().toLowerCase();
          return nameB.compareTo(nameA);
        });
        break;
      case 'price_low':
        sortedProducts.sort((a, b) {
          double priceA = double.tryParse(a['monthly_rental']?.toString() ?? '0') ?? 0;
          double priceB = double.tryParse(b['monthly_rental']?.toString() ?? '0') ?? 0;
          return priceA.compareTo(priceB);
        });
        break;
      case 'price_high':
        sortedProducts.sort((a, b) {
          double priceA = double.tryParse(a['monthly_rental']?.toString() ?? '0') ?? 0;
          double priceB = double.tryParse(b['monthly_rental']?.toString() ?? '0') ?? 0;
          return priceB.compareTo(priceA);
        });
        break;
    }

    // Simulate a brief loading delay for better UX
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          products = sortedProducts;
          isLoading = false;
        });
      }
    });

    // Show sort applied message
    String sortMessage = '';
    switch (sortType) {
      case 'name_asc':
        sortMessage = 'Sorted by name (A to Z)';
        break;
      case 'name_desc':
        sortMessage = 'Sorted by name (Z to A)';
        break;
      case 'price_low':
        sortMessage = 'Sorted by price (Low to High)';
        break;
      case 'price_high':
        sortMessage = 'Sorted by price (High to Low)';
        break;
    }

    _showSnackBar(sortMessage, AppColors.primaryColor, Icons.sort);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 50.h,
            floating: true,
            pinned: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.primaryTextColor,
                  ],
                ),
              ),
              child: FlexibleSpaceBar(
                title: Text(
                  'Search Products',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryTextColor,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        // Search Bar
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1.r,
                                blurRadius: 5.r,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search products...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_searchController.text.isNotEmpty)
                                    IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        filterProducts();
                                      },
                                    ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.filter_list,
                                      color: isFilterVisible
                                          ? AppColors.primaryColor
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isFilterVisible = !isFilterVisible;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            style: TextStyle(fontSize: 16.sp),
                            onSubmitted: (value) => filterProducts(),
                            onChanged: (value) {
                              setState(() {});
                              if (value.isEmpty) {
                                filterProducts();
                              }
                            },
                          ),
                        ),

                        // Quick action buttons (when filters are collapsed)
                        if (!isFilterVisible)
                          Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppColors.primaryColor,
                                      side: BorderSide(color: AppColors.primaryColor),
                                      padding: EdgeInsets.symmetric(vertical: 12.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    onPressed: isGettingLocation ? null : _updateLocationField,
                                    icon: isGettingLocation
                                        ? SizedBox(
                                      width: 16.w,
                                      height: 16.h,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                        : Icon(Icons.my_location, size: 18.sp),
                                    label: Text(
                                      isGettingLocation ? 'Getting...' : 'Use My Location',
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.grey.shade700,
                                      side: BorderSide(color: Colors.grey.shade300),
                                      padding: EdgeInsets.symmetric(vertical: 12.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    onPressed: clearAllFilters,
                                    icon: Icon(Icons.clear_all, size: 18.sp),
                                    label: Text(
                                      'Clear All',
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Filter Section
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: isFilterVisible
                              ? (showCustomLocationField
                              ? (selectedCategory != null ? 650.h : 580.h)
                              : (selectedCategory != null ? 580.h : 520.h))
                              : 0,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isFilterVisible) ...[
                                  SizedBox(height: 16.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Filters',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: clearAllFilters,
                                        child: Text(
                                          'Clear All',
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),

                                  // Category Dropdown
                                  isCategoriesLoading
                                      ? const Center(child: CircularProgressIndicator())
                                      : DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Category',
                                      prefixIcon: const Icon(Icons.category),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      labelStyle: TextStyle(fontSize: 14.sp),
                                    ),
                                    value: selectedCategory,
                                    hint: Text(
                                      'Select Category',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    items: categories.map((category) {
                                      return DropdownMenuItem<String>(
                                        value: category['id'].toString(),
                                        child: Text(
                                          category['name'],
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCategory = value;
                                        selectedSubcategory = null;
                                        subcategories = [];
                                        if (value != null) {
                                          fetchSubcategories(value);
                                        }
                                      });
                                    },
                                  ),
                                  SizedBox(height: 16.h),

                                  // Subcategory Dropdown
                                  if (selectedCategory != null)
                                    isSubcategoriesLoading
                                        ? Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.h),
                                      child: const Center(child: CircularProgressIndicator()),
                                    )
                                        : DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Subcategory',
                                        prefixIcon: const Icon(Icons.category_outlined),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                        labelStyle: TextStyle(fontSize: 14.sp),
                                      ),
                                      value: selectedSubcategory,
                                      hint: Text(
                                        'Select Subcategory',
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                      items: subcategories.isEmpty
                                          ? [
                                        DropdownMenuItem<String>(
                                          value: null,
                                          child: Text(
                                            'No subcategories available',
                                            style: TextStyle(fontSize: 14.sp),
                                          ),
                                        ),
                                      ]
                                          : subcategories.map((subcategory) {
                                        return DropdownMenuItem<String>(
                                          value: subcategory['id'].toString(),
                                          child: Text(
                                            subcategory['name'],
                                            style: TextStyle(fontSize: 14.sp),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedSubcategory = value;
                                        });
                                      },
                                    ),
                                  SizedBox(height: 16.h),

                                  // State Dropdown
                                  DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'State',
                                      prefixIcon: const Icon(Icons.location_city),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      labelStyle: TextStyle(fontSize: 14.sp),
                                    ),
                                    value: selectedState,
                                    hint: Text(
                                      'Select State',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    items: IndiaStatesAndCities.getAllStates().map((state) {
                                      return DropdownMenuItem<String>(
                                        value: state,
                                        child: Text(
                                          state,
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedState = value;
                                        selectedCity = null;
                                        showCustomLocationField = false;
                                        _customLocationController.clear();
                                      });
                                    },
                                  ),
                                  SizedBox(height: 16.h),

                                  // City Dropdown
                                  if (selectedState != null && !showCustomLocationField)
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'City',
                                        prefixIcon: const Icon(Icons.location_on),
                                        suffixIcon: IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            setState(() {
                                              showCustomLocationField = true;
                                              selectedCity = null;
                                            });
                                          },
                                          tooltip: 'Enter custom city',
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                        labelStyle: TextStyle(fontSize: 14.sp),
                                      ),
                                      value: selectedCity,
                                      hint: Text(
                                        'Select City',
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                      items: selectedState != null
                                          ? IndiaStatesAndCities.getCitiesForState(selectedState!)
                                          .map((city) {
                                        return DropdownMenuItem<String>(
                                          value: city,
                                          child: Text(
                                            city,
                                            style: TextStyle(fontSize: 14.sp),
                                          ),
                                        );
                                      }).toList()
                                          : [],
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCity = value;
                                        });
                                      },
                                    ),

                                  // Custom Location Field
                                  if (showCustomLocationField && selectedState != null)
                                    Column(
                                      children: [
                                        TextField(
                                          controller: _customLocationController,
                                          decoration: InputDecoration(
                                            labelText: 'Enter Custom City',
                                            prefixIcon: const Icon(Icons.edit_location),
                                            suffixIcon: IconButton(
                                              icon: const Icon(Icons.list),
                                              onPressed: () {
                                                setState(() {
                                                  showCustomLocationField = false;
                                                  _customLocationController.clear();
                                                });
                                              },
                                              tooltip: 'Select from list',
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12.r),
                                            ),
                                            hintText: 'e.g., Lucknow, Indore, etc.',
                                            labelStyle: TextStyle(fontSize: 14.sp),
                                            hintStyle: TextStyle(fontSize: 14.sp),
                                          ),
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                        SizedBox(height: 16.h),
                                      ],
                                    ),

                                  // Get Current Location Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(vertical: 16.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                      ),
                                      onPressed: isGettingLocation ? null : _updateLocationField,
                                      child: isGettingLocation
                                          ? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20.w,
                                            height: 20.h,
                                            child: const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Text(
                                            'Getting Location...',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                          : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.my_location),
                                          SizedBox(width: 8.w),
                                          Text(
                                            'Get My Current Location',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),

                                  // Location Info Display (if location is detected)
                                  if (selectedCity != null || _customLocationController.text.isNotEmpty)
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8.r),
                                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.green,
                                            size: 20.sp,
                                          ),
                                          SizedBox(width: 8.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Current Location:',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.green.shade700,
                                                  ),
                                                ),
                                                Text(
                                                  '${getFinalLocationValue() ?? ''}, ${selectedState ?? ''}',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green.shade800,
                                                  ),
                                                ),
                                                if (addLatitude != null && addLongitude != null)
                                                  Text(
                                                    'Lat: ${double.parse(addLatitude!).toStringAsFixed(4)}, Lng: ${double.parse(addLongitude!).toStringAsFixed(4)}',
                                                    style: TextStyle(
                                                      fontSize: 11.sp,
                                                      color: Colors.green.shade600,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  SizedBox(height: 16.h),

                                  // Price Range Slider
                                  Text(
                                    'Price Range (Monthly Rental)',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                        child: Text(
                                          '₹${_priceRange.start.round()}',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                        child: Text(
                                          '₹${_priceRange.end.round()}',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  RangeSlider(
                                    values: _priceRange,
                                    min: 0,
                                    max: maxPrice > 50000 ? maxPrice : 50000,
                                    divisions: 500,
                                    activeColor: AppColors.primaryColor,
                                    inactiveColor: AppColors.primaryColor.withOpacity(0.2),
                                    labels: RangeLabels(
                                      '₹${_priceRange.start.round()}',
                                      '₹${_priceRange.end.round()}',
                                    ),
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        _priceRange = values;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 16.h),

                                  // Filter Summary
                                  if (selectedCategory != null ||
                                      selectedSubcategory != null ||
                                      getFinalLocationValue() != null ||
                                      (_priceRange.start > minPrice || _priceRange.end < maxPrice))
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8.r),
                                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Active Filters:',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue.shade800,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Wrap(
                                            spacing: 6.w,
                                            runSpacing: 4.h,
                                            children: [
                                              if (selectedCategory != null)
                                                _buildFilterChip('Category: ${categories.firstWhere((c) => c['id'].toString() == selectedCategory)['name']}'),
                                              if (selectedSubcategory != null)
                                                _buildFilterChip('Subcategory: ${subcategories.firstWhere((s) => s['id'].toString() == selectedSubcategory)['name']}'),
                                              if (getFinalLocationValue() != null)
                                                _buildFilterChip('Location: ${getFinalLocationValue()}'),
                                              if (_priceRange.start > minPrice || _priceRange.end < maxPrice)
                                                _buildFilterChip('Price: ₹${_priceRange.start.round()} - ₹${_priceRange.end.round()}'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  SizedBox(height: 16.h),

                                  // Apply Filter Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(vertical: 16.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                        elevation: 2,
                                      ),
                                      onPressed: () {
                                        filterProducts();
                                        setState(() {
                                          isFilterVisible = false;
                                        });

                                        _showSnackBar(
                                          'Filters applied successfully!',
                                          Colors.green,
                                          Icons.check_circle,
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.filter_alt),
                                          SizedBox(width: 8.w),
                                          Text(
                                            'Apply Filters',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Products Grid with loading overlay
                  if (isLoading && !isInitialLoad)
                    Container(
                      height: 200.h,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Filtering products...',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (isLoading && isInitialLoad)
                    Container(
                      height: 300.h,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Loading products...',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (products.isEmpty && !isLoading)
                      Container(
                        height: 300.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            NoDataFound(
                              message: _searchController.text.isNotEmpty
                                  ? 'No products found for "${_searchController.text}"'
                                  : 'No products found matching your filters',
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: clearAllFilters,
                              icon: const Icon(Icons.refresh),
                              label: Text(
                                'Clear Filters & Retry',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        children: [
                          // Products count and sort options
                          Container(
                            color: Colors.grey.shade50,
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.search_outlined,
                                      size: 18.sp,
                                      color: Colors.grey.shade600,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      '${products.length} product${products.length != 1 ? 's' : ''} found',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                                if (products.isNotEmpty)
                                  PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.sort,
                                      color: Colors.grey.shade600,
                                      size: 20.sp,
                                    ),
                                    onSelected: (value) {
                                      _sortProducts(value);
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'name_asc',
                                        child: Text('Name (A to Z)'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'name_desc',
                                        child: Text('Name (Z to A)'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'price_low',
                                        child: Text('Price (Low to High)'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'price_high',
                                        child: Text('Price (High to Low)'),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),

                          // Products Grid
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.5,
                                mainAxisSpacing: 15.w,
                                crossAxisSpacing: 15.w,
                              ),
                              itemCount: products.length,
                              itemBuilder: (BuildContext context, int index) {
                                final product = products[index];

                                final String title = product['product_name'] ?? 'Unknown Product';
                                final String price = "₹${product['monthly_rental'] ?? '0'}/Month";

                                final int productId = product['id'] ?? 0;
                                String image_url = product['image'] ?? '';
                                String image;

                                if (image_url.isEmpty) {
                                  image = 'https://via.placeholder.com/300x200?text=No+Image';
                                } else if (!image_url.startsWith("https://")) {
                                  image = "https://www.torentyou.com/admin/uploads/$image_url";
                                } else {
                                  image = image_url;
                                }

                                return ProductCard(
                                  title: title,
                                  imageUrl: image,
                                  price: price,
                                  category: product['category_id']?.toString() ?? '0',
                                  onRentNow: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetailsPage(
                                          productId: productId,
                                          image: image,
                                          categoryId: product['category_id'] ?? 0,
                                          subcategoryId: product['subcategory'] ?? 0,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),

                          // Load more button (if needed)
                          if (products.length >= 20)
                            Padding(
                              padding: EdgeInsets.all(16.w),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primaryColor,
                                  side: BorderSide(color: AppColors.primaryColor),
                                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                onPressed: () {
                                  // Implement load more functionality if needed
                                  _showSnackBar(
                                    'All products are already loaded',
                                    Colors.blue,
                                    Icons.info_outline,
                                  );
                                },
                                child: Text(
                                  'Load More Products',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                            ),
                        ],
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customLocationController.dispose();
    super.dispose();
  }
}