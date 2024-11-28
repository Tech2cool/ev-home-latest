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
    'http://cdn.evhomes.tech/539e6919-1920-429e-96aa-bb8445d8c140-IMG-20241128-WA0006.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjUzOWU2OTE5LTE5MjAtNDI5ZS05NmFhLWJiODQ0NWQ4YzE0MC1JTUctMjAyNDExMjgtV0EwMDA2LmpwZyIsImlhdCI6MTczMjc4NDAzNH0.7MSymzf8SMq-XxVGz-xsNsUD88YtzPKyW8jMsxfCN0k',
    'http://cdn.evhomes.tech/afc0ea3c-a8bc-420b-963d-8b2f8544bb7a-IMG-20241128-WA0005.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImFmYzBlYTNjLWE4YmMtNDIwYi05NjNkLThiMmY4NTQ0YmI3YS1JTUctMjAyNDExMjgtV0EwMDA1LmpwZyIsImlhdCI6MTczMjc4NDA5NH0.qfUyPmNa7WOkvq4JDTl8TuylDykZxuc8RSJqqacT35E',
    'http://cdn.evhomes.tech/ff831d85-327e-4d03-b815-c4dc6092ffc7-IMG-20241128-WA0004.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImZmODMxZDg1LTMyN2UtNGQwMy1iODE1LWM0ZGM2MDkyZmZjNy1JTUctMjAyNDExMjgtV0EwMDA0LmpwZyIsImlhdCI6MTczMjc4NDEzN30.fQdypA7xIyJ1m8slPu3IGpEsOm6F9neT2nMsyFojhHs',
    'http://cdn.evhomes.tech/6ce2510d-1372-426e-9764-79c55bc232f6-IMG-20241128-WA0003.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjZjZTI1MTBkLTEzNzItNDI2ZS05NzY0LTc5YzU1YmMyMzJmNi1JTUctMjAyNDExMjgtV0EwMDAzLmpwZyIsImlhdCI6MTczMjc4NDE4MH0.AQ_jI87OMxfaIPDh4QzI0Dw_hfaeYnV91KGBP7qUuPA',
  ];

  bool _isHovered = false; // Track hover state for the button

  // List of nearby attractions with their images
  final List<String> attractions = [
    'http://cdn.evhomes.tech/bef9c013-f328-432c-ab5c-264666448e24-IMG-20241128-WA0009.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImJlZjljMDEzLWYzMjgtNDMyYy1hYjVjLTI2NDY2NjQ0OGUyNC1JTUctMjAyNDExMjgtV0EwMDA5LmpwZyIsImlhdCI6MTczMjc4MzYwMX0.fZW1VFfEKSnJNIOFKZ720P9zYspTbVzXQWAtWiglBM0',
    'http://cdn.evhomes.tech/1c585c3e-30a8-4147-b7d5-4cbc50c245e0-IMG-20241128-WA0008.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjFjNTg1YzNlLTMwYTgtNDE0Ny1iN2Q1LTRjYmM1MGMyNDVlMC1JTUctMjAyNDExMjgtV0EwMDA4LmpwZyIsImlhdCI6MTczMjc4MzY4Mn0.qKP98h8s4scuEvg6II3TMWhRVAh8qpJJg-eal2UHObw',
    'http://cdn.evhomes.tech/feafc7ac-68f8-46e7-9af1-5c78a042b881-IMG-20241128-WA0007.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImZlYWZjN2FjLTY4ZjgtNDZlNy05YWYxLTVjNzhhMDQyYjg4MS1JTUctMjAyNDExMjgtV0EwMDA3LmpwZyIsImlhdCI6MTczMjc4MzUxNH0.qgb1rb30qQaHbp93FjKwqz8BR1rG3PmcdOKmM7iyAC0',
    'http://cdn.evhomes.tech/fc647791-2473-47d3-a1ea-439f0c52edd3-IMG-20241128-WA0010.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImZjNjQ3NzkxLTI0NzMtNDdkMy1hMWVhLTQzOWYwYzUyZWRkMy1JTUctMjAyNDExMjgtV0EwMDEwLmpwZyIsImlhdCI6MTczMjc4Mzg2Mn0.mBoAModp-JFzyy5x3qLhj3n3Hu9Gg-_sa6UCWCeCGio',
    'https://cdn.evhomes.tech/0c5bbb3a-0c28-4ff9-87cb-9c7eb4989afc-IMG-20241128-WA0002.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjBjNWJiYjNhLTBjMjgtNGZmOS04N2NiLTljN2ViNDk4OWFmYy1JTUctMjAyNDExMjgtV0EwMDAyLmpwZyIsImlhdCI6MTczMjc4MzIxNH0.9UBXPVZK1zSPF4wuuMAOlkKbLN29YCCMPbxfqRmz0Ew',
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
                      child: Image.network(
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
                      child: Image.network(
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
