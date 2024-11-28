import 'package:carousel_slider/carousel_slider.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/amenity.dart';
import 'package:ev_homes/core/models/our_project.dart';

import 'package:flutter/material.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';

// Icon mapping remains unchanged
final Map<String, IconData> fluentIconMap = {
  'people_24_regular': FluentIcons.people_24_regular,
  'swimming_pool_24_regular': FluentIcons.swimming_pool_24_regular,
  'dumbbell_24_regular': FluentIcons.dumbbell_24_regular,
  'leaf_one_24_regular': FluentIcons.leaf_one_24_regular,
  'desktop_24_regular': FluentIcons.desktop_24_regular,
  'sparkle_24_regular': FluentIcons.sparkle_24_regular,
  'premium_24_filled': FluentIcons.premium_24_regular,
  'sport_24_regular': FluentIcons.sport_24_regular,
  'person_running_20_regular': FluentIcons.person_running_20_regular,
  'building_24_regular': FluentIcons.building_24_regular,
  'sport_basketball_24_regular': FluentIcons.sport_basketball_24_regular,
};

// Function to get icon data based on amenity name
IconData getIconData(String name) {
  IconData icon = FluentIcons.people_24_regular;

  if (name.toLowerCase().contains("swim") ||
      name.toLowerCase().contains("pool")) {
    icon = FluentIcons.swimming_pool_24_regular;
  } else if (name.toLowerCase().contains("gym") ||
      name.toLowerCase().contains("summit")) {
    icon = FluentIcons.dumbbell_24_regular;
  } else if (name.toLowerCase().contains("hall") ||
      name.toLowerCase().contains("banquet") ||
      name.toLowerCase().contains("banquet")) {
    icon = FluentIcons.sparkle_24_regular;
  } else if (name.toLowerCase().contains("sport") ||
      name.toLowerCase().contains("garden") ||
      name.toLowerCase().contains("ball")) {
    icon = FluentIcons.sport_24_regular;
  }

  return icon;
}

class DescriptionScreen extends StatefulWidget {
  final OurProject project;
  const DescriptionScreen({
    super.key,
    required this.project,
  });

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  String selectedConfiguration = 'All';
  String selectedAmenity = 'All';

  // Dummy project data
  final String brochureLink = 'https://example.com/brochure.pdf';
  final String locationLink = 'https://www.google.com/maps';

  @override
  Widget build(BuildContext context) {
    final filteredBhkList = selectedConfiguration == "All"
        ? widget.project.configurations // Show all configurations
        : widget.project.configurations
            .where((config) => config.configuration == selectedConfiguration)
            .toList();

    // String configurationsString = filteredBhkList
    //     .map((config) => config.configuration)
    //     .toList()
    //     .join(', ');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xff424d51)),
        title: Text(
          widget.project.name,
          style: const TextStyle(color: Color(0xff424d51)),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              // Updated to pass a list instead of multiple string arguments
              MyCarousel(
                imageUrls: [
                  ...widget.project.carouselImages,
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
                    child: Text(
                      'Description',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff424d51),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                    child: Text(
                      widget.project.description,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        color: Color(0xff424d51),
                      ),
                    ),
                  )
                ],
              ),
              AmenitiesSection(
                amenities: widget.project.amenities,
                selectedAme: selectedAmenity,
                onAmenitySelected: (amenity) {
                  setState(() {
                    selectedAmenity = amenity;
                  });
                },
              ),

              // Configuration Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
                    child: Text(
                      'Configuration',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff424d51),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...widget.project.configurations
                              .map((ele) => ele
                                  .configuration) // Extract configuration names
                              .toSet() // Remove duplicates
                              .map(
                            (uniqueConfig) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedConfiguration == uniqueConfig) {
                                      selectedConfiguration = "All";
                                    } else {
                                      selectedConfiguration = uniqueConfig;
                                    }
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8.0),
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xfff4e9e0),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        blurRadius: 2,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        FluentIcons
                                            .subtract_circle_arrow_back_16_filled,
                                        color: Color(0xff80b4ab),
                                        size: 16.0,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        uniqueConfig,
                                        style: const TextStyle(
                                          color: Color(0xff80b4ab),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 160,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: filteredBhkList.length,
                        itemBuilder: (context, i) {
                          return Container(
                            width: 290,
                            height: 80,
                            margin: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                                color: const Color(0xfff4e9e0),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                  )
                                ]),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Show dialog with the large image
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            insetPadding: EdgeInsets.zero,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  Navigator.of(context).pop(),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Expanded(
                                                    child: Image.network(
                                                      filteredBhkList[i].image,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Image.network(
                                      filteredBhkList[i].image,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'RERA ID: ${filteredBhkList[i].reraId}',
                                          style: const TextStyle(
                                              color: Color(0xff80b4ab)),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Carpet Area: ${filteredBhkList[i].carpetArea}',
                                          style: const TextStyle(
                                              color: Color(0xff80b4ab)),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Price: ${Helper.formatIndianNumber(filteredBhkList[i].price)}',
                                          style: const TextStyle(
                                            color: Color(0xff80b4ab),
                                          ),
                                        ),
                                        Text(
                                          filteredBhkList[i].configuration,
                                          style: const TextStyle(
                                            color: Color(0xff80b4ab),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ],
          ),
          // Bottom Buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: const Color(0xfff4e9e0),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 2,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (brochureLink.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'No Brochure available at the moment.',
                                  ),
                                ),
                              );
                              return;
                            }
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         CustomPdfViewer(link: brochureLink),
                            //   ),
                            // );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            backgroundColor: const Color(
                                0xfff4e9e0), // Matches the background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            side: const BorderSide(
                                color: Color(0xfff4e9e0), width: 1.0),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FluentIcons.arrow_download_24_regular,
                                size: 12,
                                color: Color(0xff80b4ab),
                              ),
                              SizedBox(width: 5), // Space between icon and text
                              Text(
                                'Brochure',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  color: Color(0xff80b4ab),
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 2,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () => _makePhoneCall(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FluentIcons.call_24_regular,
                                size: 12,
                                color: Color(0xff80b4ab),
                              ),
                              SizedBox(width: 5), // Space between icon and text
                              Text(
                                'Contact Us',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  color: Color(0xff80b4ab),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Floating Action Buttons
          Positioned(
            bottom: 70,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xff80b4ab),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 2,
                      spreadRadius: 1,
                    )
                  ]),
              child: FloatingActionButton.small(
                mouseCursor: MouseCursor.defer,
                focusElevation: 4,
                foregroundColor: const Color(0xff424d51),
                backgroundColor: const Color(0xfff4e9e0),
                onPressed: () async {
                  _openMap(locationLink);
                },
                child: const Icon(
                  FluentIcons.compass_northwest_20_regular,
                  size: 20,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 130,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xff80b4ab),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 2,
                      spreadRadius: 1,
                    )
                  ]),
              child: FloatingActionButton.small(
                foregroundColor: const Color(0xff424d51),
                backgroundColor: const Color(0xfff4e9e0),
                onPressed: () {
                  _showShareDialog(context);
                },
                child: const Icon(FluentIcons.share_20_regular, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openMap(String locationUrl) async {
    if (await canLaunchUrl(Uri.parse(locationUrl))) {
      await launchUrl(Uri.parse(locationUrl));
    } else {
      Helper.showCustomSnackBar('Could not open the map');
    }
  }

  Future<void> _makePhoneCall(BuildContext context) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '554545487',
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'Could not launch phone dialer';
      }
    } catch (e) {
      if (!context.mounted) return;
      Helper.showCustomSnackBar('Could not launch phone dialer');
    }
  }

  Future<void> _shareViaWhatsApp(BuildContext context) async {
    const String appLink =
        'https://evgroup.in/ev-marina-bay-apartments-mumbai.html';

    final Uri whatsappUri = Uri.parse(appLink);

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("WhatsApp is not installed on this device")),
      );
    }
  }

  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Share App"),
          content: const Text(
              "Do you want to share this app with your friends via WhatsApp?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _shareViaWhatsApp(context); // Proceed to share
              },
              child: const Text("Share"),
            ),
          ],
        );
      },
    );
  }
}

class MyCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const MyCarousel({
    super.key,
    required this.imageUrls,
  });

  @override
  State<MyCarousel> createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarousel> {
  final CarouselSliderController _carouselSliderController =
      CarouselSliderController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselSliderController,
          itemCount: widget.imageUrls.length,
          itemBuilder: (context, index, realIndex) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.imageUrls[index],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          },
          options: CarouselOptions(
            height: 350,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 2),
            autoPlayCurve: Curves.easeInOut,
            enlargeCenterPage: true,
            viewportFraction: 0.8,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageUrls.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselSliderController.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.white)
                      .withOpacity(_currentIndex == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class AmenitiesSection extends StatefulWidget {
  final List<Amenity> amenities;
  final String selectedAme;
  final Function(String) onAmenitySelected;

  const AmenitiesSection({
    super.key,
    required this.amenities,
    required this.selectedAme,
    required this.onAmenitySelected,
  });

  @override
  State<AmenitiesSection> createState() => _AmenitiesSectionState();
}

class _AmenitiesSectionState extends State<AmenitiesSection> {
  @override
  Widget build(BuildContext context) {
    // Remove duplicates based on amenity name
    final uniqueAmenities = widget.amenities.toSet().toList();
    final seenNames = <String>{};

    final filteredAmenities = uniqueAmenities.where((amenity) {
      if (seenNames.contains(amenity.name)) {
        return false;
      } else {
        seenNames.add(amenity.name);
        return true;
      }
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
          child: Text(
            'Amenities',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff424d51),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // "All" Amenity Button
                GestureDetector(
                  onTap: () {
                    widget.onAmenitySelected("All");
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(15, 10, 15, 10),
                    decoration: BoxDecoration(
                        color: const Color(0xfff4e9e0),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 2,
                            spreadRadius: 1,
                          )
                        ]),
                    child: const Row(
                      children: [
                        Icon(
                          FluentIcons.people_24_regular,
                          color: Color(0xff80b4ab),
                          size: 16.0,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          "All",
                          style: TextStyle(color: Color(0xff80b4ab)),
                        ),
                      ],
                    ),
                  ),
                ),
                // Dynamic Amenity Buttons
                ...List.generate(filteredAmenities.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      widget.onAmenitySelected(filteredAmenities[index].name);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15, 10, 15, 10),
                      decoration: BoxDecoration(
                          color: const Color(0xfff4e9e0),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 2,
                              spreadRadius: 1,
                            )
                          ]),
                      child: Row(
                        children: [
                          Icon(
                            getIconData(filteredAmenities[index].name),
                            color: const Color(0xff80b4ab),
                            size: 16.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            filteredAmenities[index].name,
                            style: const TextStyle(color: Color(0xff80b4ab)),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        HorizontalStaggeredGallery(
          selectedAmenity: widget.selectedAme,
          amenities: widget.amenities,
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class HorizontalStaggeredGallery extends StatelessWidget {
  final List<Amenity> amenities;
  final String selectedAmenity;

  const HorizontalStaggeredGallery({
    super.key,
    required this.amenities,
    required this.selectedAmenity,
  });

  @override
  Widget build(BuildContext context) {
    List<Amenity> newImages = selectedAmenity != "All"
        ? amenities.where((ele) => ele.name == selectedAmenity).toList()
        : amenities;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 300,
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          children: List.generate(newImages.length, (index) {
            return StaggeredGridTile.fit(
              crossAxisCellCount: 1,
              child: GestureDetector(
                onTap: () {
                  // Show dialog with the large image
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              16), // Adjust the radius here
                          child: Image.network(
                            newImages[index].image,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Card(
                  // color: Colors.transparent,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(8), // Small radius for gallery
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            8), // Same radius for consistency
                      ),
                      child: Image.network(
                        newImages[index].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
