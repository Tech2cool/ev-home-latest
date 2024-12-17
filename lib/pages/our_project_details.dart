import 'package:ev_homes/components/lottie/lottie1_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:provider/provider.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/customer_pages/description_screen.dart';
import 'package:ev_homes/components/lottie/lottie_page.dart';

class OurProjectList extends StatelessWidget {
  const OurProjectList({super.key});

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final projects = settingProvider.ourProject;

    return SizedBox(
      height: 320,
      child: Swiper(
        axisDirection: AxisDirection.right,
        itemBuilder: (BuildContext context, int index) {
          final project = projects[index];
          return PropertyCard(project: project);
        },
        itemCount: projects.length,
        itemWidth: 270.0,
        layout: SwiperLayout.STACK,
        loop: true, // Set to false to prevent looping
        autoplay: false,
        pagination: const SwiperPagination(),
        control: const SwiperControl(),
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
            builder: (context) => const Lottie1Page(),
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
        margin: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              // Image
              Image.network(
                project.showCaseImage ?? '',
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
              // Overlay gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              // Text overlay
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            project.locationName ?? '',
                            style: const TextStyle(
                              color: Colors.white,
              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

