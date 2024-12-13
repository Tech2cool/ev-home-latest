import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/components/lottie/lottie_page.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/customer_pages/description_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OurProjectList extends StatelessWidget {
  const OurProjectList({super.key});

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final projects = settingProvider.ourProject;

    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return PropertyCard(
            project: project,
          );
        },
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final OurProject project;

  const PropertyCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Navigate to Lottiepage on tap
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Lottiepage(),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DescriptionScreen(
              project: project,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 133, 0, 0)
                  .withOpacity(0.7), // Grey shadow color
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Image.network(
                            project.showCaseImage!,
                            width: 250,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 250,
                              height: 30,
                              decoration: BoxDecoration(
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color.fromARGB(255, 133, 0, 0),
                              size: 18,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              project.locationName!,
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(width: 0),
                            // const Icon(
                            //   Icons.house,
                            //   color: Color.fromARGB(255, 133, 0, 0),
                            //   size: 18,
                            // ),
                            // const SizedBox(width: 0),
                            // Text(
                            //   project.configurations
                            //       .map((ele) => ele.configuration)
                            //       .toList()
                            //       .join(),
                            //   style: const TextStyle(
                            //     color: Colors.black,
                            //     // fontWeight: FontWeight.w300,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
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
