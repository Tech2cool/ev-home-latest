import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:flutter/material.dart';
import '../../pages/cp_pages/resale_screen.dart';

class ResalePropertyList extends StatelessWidget {
  final List<Map<String, String>> properties = [
    {
      'image':
          'http://cdn.evhomes.tech/f0d5ed78-2df7-4221-a40f-898d1f471a5c-IMG-20241204-WA0010.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImYwZDVlZDc4LTJkZjctNDIyMS1hNDBmLTg5OGQxZjQ3MWE1Yy1JTUctMjAyNDEyMDQtV0EwMDEwLmpwZyIsImlhdCI6MTczMzMxMTYwN30.nxcZtLFHlaOLndXYrjd52C85vF8yEPmv-mVFJkgZ6EI',
      'title': 'Property 1',
      'location': 'Ghansoli',
    },
    {
      'image':
          'http://cdn.evhomes.tech/f0d5ed78-2df7-4221-a40f-898d1f471a5c-IMG-20241204-WA0010.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImYwZDVlZDc4LTJkZjctNDIyMS1hNDBmLTg5OGQxZjQ3MWE1Yy1JTUctMjAyNDEyMDQtV0EwMDEwLmpwZyIsImlhdCI6MTczMzMxMTYwN30.nxcZtLFHlaOLndXYrjd52C85vF8yEPmv-mVFJkgZ6EI',
      'title': 'Property 2',
      'location': 'Vashi',
    },
    // Add more properties here
  ];

  ResalePropertyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(
            properties.length,
            (index) => PropertyCardVertical1(
                property: properties[index], context: context))
      ],
    );
  }
}

class PropertyCardVertical1 extends StatelessWidget {
  final Map<String, String> property;
  final BuildContext context;

  const PropertyCardVertical1(
      {super.key, required this.property, required this.context});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ResaleScreen()), // Navigate to ResaleScreen
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        height: 120, // Set a fixed height for the card
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
                          child: Image.network(
                            property['image']!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.fill,
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
