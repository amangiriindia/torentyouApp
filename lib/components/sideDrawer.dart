import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../consts.dart';
import '../pageutills/categoryWise.dart';

class SideDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideDrawer({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final response = await http.get(Uri.parse('${AppConstant.API_URL}api/v1/category/all-category'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        categories = data['results'];
      });
    } else {
      // Handle the error as needed
      print('Failed to load categories');
    }
  }

  void _onDrawerItemTap(int index) {
    final selectedCategory = categories[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryWise(
          categoryName: selectedCategory['c_name'],
          categoryId: selectedCategory['id'],
        ),
      ),
    );
    widget.scaffoldKey.currentState?.closeDrawer(); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle itemTextStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColors.primaryTextColor,
      fontSize: 18,
      letterSpacing: 1,
    );

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: categories.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categories.map((item) {
              return ListTile(
                leading: Image.network(item['image'], width: 30, height: 30),
                title: Text(item['c_name'], style: itemTextStyle),
                onTap: () => _onDrawerItemTap(categories.indexOf(item)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
