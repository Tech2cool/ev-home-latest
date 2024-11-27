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
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 133, 0, 0)
                  .withOpacity(0.6), // Grey shadow color
              offset: const Offset(3, 3), // Position the shadow
              blurRadius: 8, // Blur effect
              spreadRadius: 3, // Spread the shadow
            ),
          ],
        ),
        height: 120, // Set a fixed height for the card
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              const Positioned.fill(
                child: AnimatedGradientBg(),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: const Color.fromARGB(255, 26, 25, 25)
                  //         .withOpacity(0.4),
                  //     offset: Offset(0, 6),
                  //     blurRadius: 2,
                  //     spreadRadius: 1,
                  //   )
                  // ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 26, 25, 25)
                                  .withOpacity(0.6),
                              offset: const Offset(0, 6),
                              blurRadius: 7,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ClipOval(
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
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              property['title']!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color.fromARGB(255, 133, 0, 0),
                                  size: 18,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  property['location']!,
                                  style: const TextStyle(
                                    color: Colors.black,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
