import 'package:carousel_slider/carousel_slider.dart';
import 'package:ev_homes/core/constant/constant.dart';
import 'package:flutter/material.dart';

class ResaleScreen extends StatefulWidget {
  const ResaleScreen({super.key});

  @override
  State<ResaleScreen> createState() => _ResaleScreenState();
}

class _ResaleScreenState extends State<ResaleScreen> {
  final List<String> imgList = [
    'assets/images/resalbul1.jpg',
    'assets/images/resalbul2.jpg',
    'assets/images/resalbul3.jpg',
    'assets/images/resalbul4.jpg',
  ];

  bool _isHovered = false; // Track hover state for the button

  // List of nearby attractions with their images
  final List<String> attractions = [
    'assets/images/badroom1.jpg',
    'assets/images/bedroom2.jpg',
    'assets/images/kichken.jpg',
    'assets/images/livingroom1.jpg',
    'assets/images/washroom.jpg',
  ];

  // List of nearby places with their icons
  final List<Map<String, dynamic>> places = [
    {
      'name': 'Hospital',
      'icon': Icons.local_hospital,
    },
    {
      'name': 'College',
      'icon': Icons.school,
    },
    {
      'name': 'Bus Stand',
      'icon': Icons.directions_bus,
    },
    {
      'name': 'Mall',
      'icon': Icons.shopping_cart,
    },
    {
      'name': 'Railway Station',
      'icon': Icons.train,
    },
    {
      'name': 'Park',
      'icon': Icons.park,
    },
    {
      'name': 'Restaurant',
      'icon': Icons.restaurant,
    },
  ];

  // List of amenities with their icons
  final List<Map<String, dynamic>> amenities = [
    {'name': 'Lift', 'icon': Icons.elevator},
    {'name': 'Gym', 'icon': Icons.fitness_center},
    {'name': 'VisitorParking', 'icon': Icons.local_parking},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resale'),
      ),
      backgroundColor: Constant.bgColor, // Set the page background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Enable vertical scrolling
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top slider
              CarouselSlider(
                options: CarouselOptions(
                  height: 250.0, // Adjust the height of the carousel
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 2),
                  enlargeCenterPage: true,
                  viewportFraction: 0.9, // Increase the width of the images
                ),
                items: imgList.map((item) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        item,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Title and price text
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.end, // Align items at the bottom
                    children: [
                      Text(
                        '2BHK',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(width: 4), // Small space between 2BHK and area
                      Text(
                        '(1,624 sq.ft)', // Area text
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '₹ 50,00,000', // Price in Indian Rupees
                    style: TextStyle(
                      fontSize: 16, // Reduced size
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Address with button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'vashi, navi mumbai, maharashtra.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // "See on Location" button with hover effect
                  MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        _isHovered = true;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        _isHovered = false;
                      });
                    },
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Add functionality for button press (e.g., open map)
                      },
                      icon: Icon(
                        Icons.location_on,
                        color: _isHovered
                            ? Constant.errorColor
                            : Constant.avatorbgColor,
                      ),
                      label: Text(
                        'Location',
                        style: TextStyle(
                          color: _isHovered
                              ? Constant.errorColor
                              : Constant.avatorbgColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isHovered
                            ? Constant.avatorbgColor
                            : Constant.errorColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        minimumSize: const Size(0, 40),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // "Around This Property" section
              const Text(
                'Connectivity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Use primary color for headline
                ),
              ),
              const SizedBox(height: 5),

              // Horizontal scrollable section for places
              SizedBox(
                height: 120, // Fixed height for the scrollable section
                child: ListView.builder(
                  scrollDirection:
                      Axis.horizontal, // Enable horizontal scrolling
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final place = places[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Constant.bgColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(
                                place['icon'],
                                size: 25,
                                color: Colors.white, // Icon color
                              ),
                            ),
                          ),
                          const SizedBox(
                              height: 8), // Space between icon and name
                          Text(
                            place['name'], // Display the name of the place
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Change this as needed
                            ),
                          ),
                          const SizedBox(
                              height: 4), // Space between name and distance
                          const Text(
                            'Distance: 2 km', // Add the distance (you can customize this)
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white, // Color for distance text
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Carousel for nearby attractions
              CarouselSlider(
                options: CarouselOptions(
                  height: 150.0, // Adjust the height of the carousel
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 2),
                  enlargeCenterPage: true,
                  viewportFraction: 0.7, // Increase the width of the images
                ),
                items: attractions.map((item) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        item,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Amenities section
              const Text(
                'Amenities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 120, // Fixed height for the scrollable section
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: amenities.length,
                  itemBuilder: (context, index) {
                    final amenity = amenities[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Constant.bgColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(
                                    amenity['icon'],
                                    size: 25,
                                    color: Colors.white, // Icon color
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                              height: 8), // Space between icon and name
                          Row(
                            children: [
                              Text(
                                amenity[
                                    'name'], // Display the name of the place
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Change this as needed
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 44),

              // Centered "Contact Us" button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add functionality for the contact button press
                  },
                  icon: Icon(
                    Icons.phone, // Call icon
                    color: Constant.primaryColor, // Change this as needed
                  ),
                  label: const Text(
                    'Contact Us',
                    style: TextStyle(
                      color: Colors.black, // Change text color as needed
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background
                    side: BorderSide(
                      color: Constant.primaryColor, // Border color
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    minimumSize: const Size(200, 50), // Set a minimum size
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // No border radius
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
