import 'package:flutter/material.dart';

import '../service/google_map_helper.dart';


class LocationButton extends StatefulWidget {
  @override
  _LocationButtonState createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  String locationMessage = "Press the button to get your location";

  // Function to update the UI with location information
  void _updateLocationMessage() async {
    String location = await GoogleMapHelper.getCurrentLocation();
    setState(() {
      locationMessage = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Current Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              locationMessage,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateLocationMessage, // Calls the function to update location
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Keeps the button as small as possible
                children: [
                  Icon(Icons.location_on), // Location icon
                  SizedBox(width: 8), // Spacing between icon and text
                  Text("Get Location"), // Button text
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

