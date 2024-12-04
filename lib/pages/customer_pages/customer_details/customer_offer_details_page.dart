import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/pages/customer_pages/customer_details/offer_description_page.dart';
import 'package:ev_homes/pages/customer_pages/customer_offers/navratri_offer_page.dart';
import 'package:ev_homes/wrappers/customer_home_wrapper.dart';
import 'package:flutter/material.dart';

// import '../../wrappers/home_wrapper.dart';

class Offer {
  final String title;
  final List<String> images;
  final String description;
  final String terms;

  Offer({
    required this.title,
    required this.images,
    required this.description,
    required this.terms,
  });
}

class OfferDetailPage extends StatefulWidget {
  final bool showDiolog;
  const OfferDetailPage({super.key, required this.showDiolog});

  @override
  _OfferDetailPageState createState() => _OfferDetailPageState();
}

class _OfferDetailPageState extends State<OfferDetailPage> {
  // Example data for ongoing offers
  final List<Offer> offers = [
    Offer(
      title: "New Project!!",
      images: [
        'http://cdn.evhomes.tech/074b8d14-4026-4a58-9e6d-5a9b6ced8b9a-IMG-20241204-WA0013.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjA3NGI4ZDE0LTQwMjYtNGE1OC05ZTZkLTVhOWI2Y2VkOGI5YS1JTUctMjAyNDEyMDQtV0EwMDEzLmpwZyIsImlhdCI6MTczMzMxMTY4N30.rpTErQ8AjcA0trXr0s3nqrw-QU1juctPNWRIVaIIttM',
        'http://cdn.evhomes.tech/b5c3df96-d7bd-4e87-9525-25615654d688-IMG-20241204-WA0014.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImI1YzNkZjk2LWQ3YmQtNGU4Ny05NTI1LTI1NjE1NjU0ZDY4OC1JTUctMjAyNDEyMDQtV0EwMDE0LmpwZyIsImlhdCI6MTczMzMxMTc3MH0.OVLnPp4mCfiHMgTtuGODn3yMQB_sXecQS9pYg643gw4',
        'assets/images/mb3.jpg'
      ],
      description: "Grab the opportunity and win high offers on booking.",
      terms: "Terms and conditions apply. Valid until 30th September only.",
    ),
    Offer(
      title: "Get 20% off on booking",
      images: [
        'http://cdn.evhomes.tech/b5c3df96-d7bd-4e87-9525-25615654d688-IMG-20241204-WA0014.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImI1YzNkZjk2LWQ3YmQtNGU4Ny05NTI1LTI1NjE1NjU0ZDY4OC1JTUctMjAyNDEyMDQtV0EwMDE0LmpwZyIsImlhdCI6MTczMzMxMTc3MH0.OVLnPp4mCfiHMgTtuGODn3yMQB_sXecQS9pYg643gw4',
        'http://cdn.evhomes.tech/b5c3df96-d7bd-4e87-9525-25615654d688-IMG-20241204-WA0014.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImI1YzNkZjk2LWQ3YmQtNGU4Ny05NTI1LTI1NjE1NjU0ZDY4OC1JTUctMjAyNDEyMDQtV0EwMDE0LmpwZyIsImlhdCI6MTczMzMxMTc3MH0.OVLnPp4mCfiHMgTtuGODn3yMQB_sXecQS9pYg643gw4',
      ],
      description: "Grab the opportunity and win high offers on booking.",
      terms: "Terms and conditions apply. Valid until 30th September only",
    ),
    // Add more offers as needed
  ];

  @override
  void initState() {
    super.initState();

    // Trigger the CelebratePopup when this page is loaded
    if (widget.showDiolog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) => const NavratriOfferPopup(),
        );
      });
    }
  }

  Future<bool> _onWillPop() async {
    // Override the back button to navigate to HomeWrapper
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CustomerHomeWrapper()),
    );
    return false; // Prevent default back action
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Handle back button press
      child: Stack(
        children: [
          const AnimatedGradientBg(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text("Ongoing Offers"),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back), // Back button icon
                onPressed: () {
                  // Navigate back to HomeWrapper using pushReplacement
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CustomerHomeWrapper()),
                  );
                },
              ),
            ),
            body: ListView.builder(
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];
                return GestureDetector(
                  onTap: () {
                    // Add custom transition and back navigation using pushReplacement
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (_, __, ___) =>
                            const OfferPage(), // Navigate to OfferPage
                        transitionsBuilder: (_, animation, __, child) {
                          const begin =
                              Offset(1.0, 0.0); // Slide from the right
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          final tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          final offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                              position: offsetAnimation, child: child);
                        },
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Circular corners
                    ),
                    margin: const EdgeInsets.all(12),
                    elevation: 5, // Slight shadow effect
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(
                              10.0), // Gap between image and card
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // Slight rounding of image
                            child: Image.network(
                              offer.images[0],
                              height: 120, // Adjust the height of the image
                              width: 120, // Adjust the width of the image
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                            width: 10), // Add some space between image and text
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              offer.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
        ],
      ),
    );
  }
}
