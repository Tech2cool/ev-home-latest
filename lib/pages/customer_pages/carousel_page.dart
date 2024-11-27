import 'package:carousel_slider/carousel_slider.dart';
import 'package:ev_homes/core/constant/constant.dart';
// import 'package:ev_homes_customer/core/constant.dart';
// import 'package:ev_homes_crm_v7/core/constant/constant.dart';
import 'package:flutter/material.dart';

class CarouselPage extends StatelessWidget {
  const CarouselPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider(
        options: CarouselOptions(
          height: 120, // Adjust height as needed
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 2.0,
          viewportFraction: 0.8,
        ),
        items: [
          // Replace these images with your actual assets
          'assets/images/whats_new_1.jpeg', // Image 1
          'assets/images/whats_new_2.jpeg',
          'assets/images/whats_new_3.jpeg',
        ]
            .map((item) => GestureDetector(
                  onTap: () {
                    // Show image in a popup when tapped
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor:
                              Colors.transparent, // Transparent background
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pop(); // Close the dialog when tapped
                            },
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Optional: Rounded corners
                                child: Image.asset(
                                  item,
                                  fit: BoxFit.cover, // Show image in full size
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6.0),
                    decoration: BoxDecoration(
                        color: Constant.bgColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 26, 25, 25)
                                .withOpacity(0.6),
                            offset: const Offset(0, 6),
                            blurRadius: 2,
                            spreadRadius: 1,
                          )
                        ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        item,
                        fit: BoxFit.cover,
                        width: double.infinity, // Adjust width
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
