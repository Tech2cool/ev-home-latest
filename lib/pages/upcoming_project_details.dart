import 'dart:ui';

import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/pages/customer_pages/featured_project_screen.dart';
import 'package:flutter/material.dart';
// Import the AnimatedGradient widget

class UpcomingProjectsList extends StatelessWidget {
  final List<Map<String, String>> properties = [
    {
      'image': 'assets/images/flamingo bay photo.png',
      'title': 'Flamingo Bay',
      'location': 'Nerul',
    },
    {
      'image': 'assets/images/the venetian.png',
      'title': 'The Venetian',
      'location': 'Vashi',
    },
    {
      'image': 'assets/images/23 miami.png',
      'title': '23 Miami',
      'location': 'Koperkhairane',
    },
    {
      'image': 'assets/images/23 malibu west.png',
      'title': '23 Malibu West',
      'location': 'Koperkhairane',
    },
  ];

  final List<String> featuredProjectImages = [
    'assets/images/flamingo bay.png',
    'assets/images/the venetian logo.png',
    'assets/images/23 miami logo.png',
    'assets/images/23 malibu logo.png',
  ];

  UpcomingProjectsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(properties.length, (index) {
          return PropertyCardVertical(
            property: properties[index],
            featuredImage: featuredProjectImages[index],
          );
        }),
      ],
    );
  }
}

class PropertyCardVertical extends StatelessWidget {
  final Map<String, String> property;
  final String featuredImage;

  const PropertyCardVertical({
    super.key,
    required this.property,
    required this.featuredImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeaturedProjectScreen(
              logoImagePath: featuredImage,
              title: property['title']!,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        height: 120, // Set a fixed height for the card
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              // Add the background image with blur effect
              Positioned.fill(
                child: Image.asset(
                  property['image']!, // Path to your background image
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
                  child: Container(
                    color:
                        Colors.black.withOpacity(0.1), // Optional dark overlay
                  ),
                ),
              ),
              // Foreground content
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(25), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 26, 25, 25)
                                .withOpacity(0.6),
                            offset: const Offset(0, 6),
                            blurRadius: 3,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            25), // Same radius as the container
                        child: Image.asset(
                          property['image']!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Move title to the top
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            property['title']!,
                            style: const TextStyle(
                              color: Color(0xFF042630),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                              height: 6), // Add spacing below the title
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Color(0xFF042630),
                                size: 18,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                property['location']!,
                                style: const TextStyle(
                                  color: Colors
                                      .white, // Adjust text color for contrast
                                  fontSize: 14,
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
            ],
          ),
        ),
      ),
    );
  }
}
