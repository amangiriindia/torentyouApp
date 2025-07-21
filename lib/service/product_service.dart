import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../consts.dart';

class ProductService {
  // Search products with filters
  Future<List<dynamic>> searchProducts({
    required String searchTerm,
    String? categoryId,
    double? priceMin,
    double? priceMax,
    String? location,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstant.API_URL}api/v1/product/search-product'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'searchTerm': searchTerm,
          if (categoryId != null) 'category_id': int.parse(categoryId),
          if (priceMin != null) 'priceMin': priceMin.toInt(),
          if (priceMax != null) 'priceMax': priceMax.toInt(),
          if (location != null) 'location': location,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['products'] ?? [];
        } else {
          throw Exception('Search failed: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      print('ProductService searchProducts error: $e');
      throw Exception('Error searching products: $e');
    }
  }

  // Get all categories
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstant.API_URL}api/v1/category/all-category'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List<Map<String, dynamic>> categories =
          List<Map<String, dynamic>>.from(data['results'].map((category) {
            return {
              'id': category['id'] ?? 0,
              'name': category['c_name'] ?? 'Unknown Category',
            };
          }));

          // Cache categories
          await _cacheCategories(categories);
          return categories;
        } else {
          throw Exception('Failed to load categories: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('ProductService getAllCategories error: $e');

      // Try to load from cache if API fails
      final cachedCategories = await _getCachedCategories();
      if (cachedCategories.isNotEmpty) {
        return cachedCategories;
      }

      throw Exception('Error loading categories: $e');
    }
  }

  // Get products by category
  Future<List<dynamic>> getProductsByCategory(int categoryId) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstant.API_URL}api/v1/product/all-product'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'category_id': categoryId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final products = List<Map<String, dynamic>>.from(data['results']);

          // Cache products
          await _cacheProducts(categoryId, products);
          return products;
        } else {
          throw Exception('Failed to load products: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('ProductService getProductsByCategory error: $e');

      // Try to load from cache if API fails
      final cachedProducts = await _getCachedProducts(categoryId);
      if (cachedProducts.isNotEmpty) {
        return cachedProducts;
      }

      throw Exception('Error loading products: $e');
    }
  }

  // Get featured products
  Future<List<dynamic>> getFeaturedProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstant.API_URL}api/v1/product/featured-products'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['products'] ?? [];
        } else {
          throw Exception('Failed to load featured products: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load featured products: ${response.statusCode}');
      }
    } catch (e) {
      print('ProductService getFeaturedProducts error: $e');
      throw Exception('Error loading featured products: $e');
    }
  }

  // Get product details
  Future<Map<String, dynamic>> getProductDetails(int productId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstant.API_URL}api/v1/product/product-details/$productId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['product'] ?? {};
        } else {
          throw Exception('Failed to load product details: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load product details: ${response.statusCode}');
      }
    } catch (e) {
      print('ProductService getProductDetails error: $e');
      throw Exception('Error loading product details: $e');
    }
  }

  // Cache categories
  Future<void> _cacheCategories(List<Map<String, dynamic>> categories) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('rental_categories', jsonEncode(categories));
    } catch (e) {
      print('Error caching categories: $e');
    }
  }

  // Get cached categories
  Future<List<Map<String, dynamic>>> _getCachedCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('rental_categories');
      if (cachedData != null) {
        return List<Map<String, dynamic>>.from(jsonDecode(cachedData));
      }
    } catch (e) {
      print('Error getting cached categories: $e');
    }
    return [];
  }

  // Cache products
  Future<void> _cacheProducts(int categoryId, List<dynamic> products) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'category_${categoryId}_products';
      await prefs.setString(key, jsonEncode(products));
    } catch (e) {
      print('Error caching products: $e');
    }
  }

  // Get cached products
  Future<List<dynamic>> _getCachedProducts(int categoryId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'category_${categoryId}_products';
      final cachedData = prefs.getString(key);
      if (cachedData != null) {
        return jsonDecode(cachedData);
      }
    } catch (e) {
      print('Error getting cached products: $e');
    }
    return [];
  }

  // Clear all cache
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      for (String key in keys) {
        if (key.startsWith('category_') || key == 'rental_categories') {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  // Get price range for products
  Map<String, double> getPriceRange(List<dynamic> products) {
    if (products.isEmpty) {
      return {'min': 0.0, 'max': 10000.0};
    }

    double minPrice = double.infinity;
    double maxPrice = 0.0;

    for (var product in products) {
      double price = double.tryParse(product['monthly_rental']?.toString() ?? '0') ?? 0;
      if (price < minPrice) minPrice = price;
      if (price > maxPrice) maxPrice = price;
    }

    return {
      'min': minPrice == double.infinity ? 0.0 : minPrice,
      'max': maxPrice == 0.0 ? 10000.0 : maxPrice,
    };
  }

  // Filter products by price range
  List<dynamic> filterProductsByPrice(List<dynamic> products, double minPrice, double maxPrice) {
    return products.where((product) {
      double price = double.tryParse(product['monthly_rental']?.toString() ?? '0') ?? 0;
      return price >= minPrice && price <= maxPrice;
    }).toList();
  }
}