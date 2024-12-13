import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/amenity.dart';
import 'package:ev_homes/core/models/our_project.dart';

import 'package:flutter/material.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

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
  } else if (name.toLowerCase().contains("yoga") ||
      name.toLowerCase().contains("yoga") ||
      name.toLowerCase().contains("yoga")) {
    icon = FluentIcons.flow_16_filled;
  } else if (name.toLowerCase().contains("sport") ||
      name.toLowerCase().contains("garden") ||
      name.toLowerCase().contains("ball")) {
    icon = FluentIcons.sport_24_regular;
  } else if (name.toLowerCase().contains("lounge") ||
      name.toLowerCase().contains("party") ||
      name.toLowerCase().contains("party")) {
    icon = FluentIcons.music_note_2_16_filled;
  } else if (name.toLowerCase().contains("area") ||
      name.toLowerCase().contains("kids") ||
      name.toLowerCase().contains("kids")) {
    icon = FluentIcons.people_community_28_regular;
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
  final String brochureLink =
      "https://cdn.evhomes.tech/a9e1f771-8e1c-4963-8ce2-1fddf29634ed-nine%20square%20s_compressed-compressed.pdf?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImE5ZTFmNzcxLThlMWMtNDk2My04Y2UyLTFmZGRmMjk2MzRlZC1uaW5lIHNxdWFyZSBzX2NvbXByZXNzZWQtY29tcHJlc3NlZC5wZGYiLCJpYXQiOjE3MzM1NjQwMjF9.MoPvglY_wCRkW28PiwtEo4mBgB_YNrJ3-KPxFi6BhHU";
  // final String locationLink = 'https://maps.app.goo.gl/DqUfxcX63SAxCWMK8';

  Future<void> _downloadBrochure(BuildContext context) async {
    try {
      final req = await Permission.storage.request();
      if (req.isGranted) {
        Directory? downloadsDirectory =
            Directory('/storage/emulated/0/Download');

        if (downloadsDirectory.existsSync()) {
          final filePath = "${downloadsDirectory.path}/brochure.pdf";

          Dio dio = Dio();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Downloading brochure...')),
          );

          await dio.download(brochureLink, filePath);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Download complete. Opening brochure...')),
          );

          OpenResult result = await OpenFile.open(filePath);

          if (result.type != ResultType.done) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Failed to open brochure: ${result.message}')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Downloads folder not found.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied.')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });

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
          widget.project.name ?? "",
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
                      widget.project.description ?? "",
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        color: Color(0xff424d51),
                      ),
                    ),
                  )
                ],
              ),
              AmenitiesSection(
                amenities: widget.project.amenities,
                selectedAmenity: selectedAmenity,
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
                              .map((ele) => ele.configuration)
                              .toSet()
                              .map(
                            (uniqueConfig) {
                              final isSelected =
                                  selectedConfiguration == uniqueConfig;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedConfiguration =
                                        isSelected ? "All" : uniqueConfig;
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
                                    color: isSelected
                                        ? const Color.fromARGB(199, 248, 85, 4)
                                        : Colors.orangeAccent,
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
                                      Icon(
                                        FluentIcons
                                            .subtract_circle_arrow_back_16_filled,
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.black, // Icon color
                                        size: 16.0,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        uniqueConfig,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.black, // Text color
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

                  //TODO: hero fix
                  SizedBox(
                    width: double.infinity,
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: filteredBhkList.length,
                      itemBuilder: (context, i) {
                        return Hero(
                          tag:
                              'configuration-${filteredBhkList[i].configuration}-$i', // Unique tag
                          child: Container(
                            width: 290,
                            height: 80,
                            margin: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
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
                                              color: Colors.black),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Carpet Area: ${filteredBhkList[i].carpetArea}',
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Price: ${Helper.formatIndianNumber(filteredBhkList[i].price)}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          filteredBhkList[i].configuration,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
              color: Colors.orangeAccent,
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
                            // if (brochureLink.isEmpty) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //       content: Text(
                            //         'No Brochure available at the moment.',
                            //       ),
                            //     ),
                            //   );
                            //   return;
                            // }
                            _downloadBrochure(context);
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
                            // backgroundColor: const Color(
                            //     0xfff4e9e0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // side: const BorderSide(
                            //     color: Color(0xfff4e9e0), width: 1.0),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FluentIcons.arrow_download_24_regular,
                                size: 18,
                                color: Colors.orangeAccent,
                              ),
                              SizedBox(width: 5), // Space between icon and text
                              Text(
                                'Brochure',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  color: Colors.black,
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
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FluentIcons.call_24_regular,
                                size: 18,
                                color: Colors.orangeAccent,
                              ),
                              SizedBox(width: 5), // Space between icon and text
                              Text(
                                'Contact Us',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  color: Colors.black,
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
                  color: Colors.orangeAccent,
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
                onPressed: () {
                  _openMap(widget.project.locationLink!);
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
                  color: Colors.orangeAccent,
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
                onPressed: () async {
                  const appLink =
                      'https://evgroup.in/ev-marina-bay-apartments-mumbai.html';
                  await Share.share('Check out this amazing project: $appLink');
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
    try {
      final Uri parsedUri = Uri.parse(locationUrl);

      // Debug log for parsed URL
      print('Parsed URI: $parsedUri');

      if (await canLaunchUrl(parsedUri)) {
        await launchUrl(parsedUri, mode: LaunchMode.externalApplication);
        print('Map opened successfully.');
      } else {
        // Debug log for failure to open URL
        print('Cannot launch URL: $parsedUri');
        Helper.showCustomSnackBar('Could not open the map');
      }
    } catch (e) {
      // Log exception details
      print('Error occurred while opening the map: $e');
      Helper.showCustomSnackBar('An error occurred: $e');
    }
  }

  Future<void> _makePhoneCall(BuildContext context) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '8879342777',
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
    final String message = 'Check out this amazing project: $appLink';

    try {
      // Try to launch WhatsApp directly
      final whatsappUrl =
          "whatsapp://send?text=${Uri.encodeComponent(message)}";
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        // If direct launch fails, try web version
        final webWhatsappUrl =
            "https://api.whatsapp.com/send?text=${Uri.encodeComponent(message)}";
        if (await canLaunchUrl(Uri.parse(webWhatsappUrl))) {
          await launchUrl(
            Uri.parse(webWhatsappUrl),
            mode: LaunchMode.externalApplication,
          );
        } else {
          throw 'Could not launch WhatsApp';
        }
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Error: $e. Please make sure WhatsApp is installed and try again."),
          duration: Duration(seconds: 5),
        ),
      );
      print("Error launching WhatsApp: $e");
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
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _shareViaWhatsApp(context);
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
  final String selectedAmenity;
  final Function(String) onAmenitySelected;

  const AmenitiesSection({
    super.key,
    required this.amenities,
    required this.selectedAmenity,
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
                      color: widget.selectedAmenity == "All"
                          ? const Color.fromARGB(199, 248, 85, 4)
                          : Colors.orangeAccent,
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
                        Icon(
                          FluentIcons.people_24_regular,
                          color: widget.selectedAmenity == "All"
                              ? Colors.black
                              : Colors.black,
                          size: 16.0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          "All",
                          style: TextStyle(
                            color: widget.selectedAmenity == "All"
                                ? Colors.black
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Dynamic Amenity Buttons
                ...List.generate(filteredAmenities.length, (index) {
                  final amenity = filteredAmenities[index];
                  final isSelected = widget.selectedAmenity == amenity.name;

                  return GestureDetector(
                    onTap: () {
                      widget.onAmenitySelected(amenity.name);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15, 10, 15, 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color.fromARGB(199, 248, 85, 4)
                            : Colors.orangeAccent,
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
                          Icon(
                            getIconData(amenity.name),
                            color: isSelected ? Colors.black : Colors.black,
                            size: 16.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            amenity.name,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.black,
                            ),
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
          selectedAmenity: widget.selectedAmenity,
          amenities: widget.amenities,
        ),
        const SizedBox(
          height: 10,
        ),
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
                        insetPadding: EdgeInsets.all(0),
                        backgroundColor: Colors.transparent,
                        child: InteractiveViewer(
                          maxScale: 2.2,
                          child: Container(
                            height: MediaQuery.sizeOf(context).height / 3,
                            color: Colors.transparent,
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.network(
                                newImages[index].image,
                                width: double.infinity,
                                height: 250,
                                fit: BoxFit.contain,
                              ),
                            ),
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
