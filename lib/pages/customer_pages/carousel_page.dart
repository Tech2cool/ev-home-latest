import 'package:carousel_slider/carousel_slider.dart';
import 'package:ev_homes/core/constant/constant.dart';

import 'package:flutter/material.dart';

class CarouselPage extends StatelessWidget {
  const CarouselPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider(
        options: CarouselOptions(
          height: 220, // Adjust height as needed
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 2.0,
          viewportFraction: 0.8,
        ),
        items: [
          // Replace these images with your actual assets
          'http://cdn.evhomes.tech/074b8d14-4026-4a58-9e6d-5a9b6ced8b9a-IMG-20241204-WA0013.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjA3NGI4ZDE0LTQwMjYtNGE1OC05ZTZkLTVhOWI2Y2VkOGI5YS1JTUctMjAyNDEyMDQtV0EwMDEzLmpwZyIsImlhdCI6MTczMzMxMTY4N30.rpTErQ8AjcA0trXr0s3nqrw-QU1juctPNWRIVaIIttM', // Image 1
          'http://cdn.evhomes.tech/b5c3df96-d7bd-4e87-9525-25615654d688-IMG-20241204-WA0014.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImI1YzNkZjk2LWQ3YmQtNGU4Ny05NTI1LTI1NjE1NjU0ZDY4OC1JTUctMjAyNDEyMDQtV0EwMDE0LmpwZyIsImlhdCI6MTczMzMxMTc3MH0.OVLnPp4mCfiHMgTtuGODn3yMQB_sXecQS9pYg643gw4',
          'http://cdn.evhomes.tech/7420619e-26c3-4814-b029-ebf32441441b-IMG-20241204-WA0015.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6Ijc0MjA2MTllLTI2YzMtNDgxNC1iMDI5LWViZjMyNDQxNDQxYi1JTUctMjAyNDEyMDQtV0EwMDE1LmpwZyIsImlhdCI6MTczMzMxMTg3MH0.I5HRbn-nd8QJNMYb5OuD5x4M8M9K971sCj7XvMFUyIU',
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
                                child: Image.network(
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
                      child: Image.network(
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
