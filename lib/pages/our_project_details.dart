// import 'package:ev_homes/components/animated_gradient_bg.dart';
// import 'package:ev_homes/components/lottie/lottie1_page.dart';
// import 'package:ev_homes/components/lottie/lottie_page.dart';
// import 'package:ev_homes/core/models/our_project.dart';
// import 'package:ev_homes/core/providers/setting_provider.dart';
// import 'package:ev_homes/pages/customer_pages/description_screen.dart';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class OurProjectList extends StatelessWidget {
//   const OurProjectList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final settingProvider = Provider.of<SettingProvider>(context);
//     final projects = settingProvider.ourProject;

//     return SizedBox(
//       height: 280,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: projects.length,
//         itemBuilder: (context, index) {
//           final project = projects[index];
//           return PropertyCard(
//             project: project,
//           );
//         },
//       ),
//     );
//   }
// }

// class PropertyCard extends StatelessWidget {
//   final OurProject project;

//   const PropertyCard({
//     super.key,
//     required this.project,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//      builder: (context) => DescriptionScreen(
//               project: project,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.all(10),
//         width: 220,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(25),
//           color: Colors.white,
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(15),
//           child: Stack(
//             children: [
//               const Positioned.fill(
//                 child: AnimatedGradientBg(),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(7.0),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Stack(
//                         children: [
//                           Image.network(
//                             project.showCaseImage!,
//                             width: 250,
//                             height: 190,
//                             fit: BoxFit.cover,
//                           ),
//                           Positioned(
//                             bottom: 0,
//                             child: Container(
//                               width: 250,
//                               height: 20,
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Colors.black.withOpacity(0.6),
//                                     Colors.transparent,
//                                   ],
//                                   begin: Alignment.bottomCenter,
//                                   end: Alignment.topCenter,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           project.name ?? '',
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             shadows: [
//                               Shadow(
//                                 offset: Offset(1.5, 1.5),
//                                 blurRadius: 2,
//                                 color: Colors.black38,
//                               ),
//                             ],
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.location_on,
//                               color: Color(0xFF4B5945),
//                               size: 18,
//                             ),
//                             const SizedBox(width: 2),
//                             Text(
//                               project.locationName!,
//                               style: const TextStyle(
//                                 color: Color(0xFF4B5945),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
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
        autoplay: true,
        autoplayDelay: 3000,
        autoplayDisableOnInteraction: true,
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
