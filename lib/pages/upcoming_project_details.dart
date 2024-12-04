import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/pages/customer_pages/featured_project_screen.dart';
import 'package:flutter/material.dart';
// Import the AnimatedGradient widget

class UpcomingProjectsList extends StatelessWidget {
  final List<Map<String, String>> properties = [
    {
      'image':
          'http://cdn.evhomes.tech/ce70c405-62f5-4d02-93cf-832057bb7415-IMG-20241204-WA0006.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImNlNzBjNDA1LTYyZjUtNGQwMi05M2NmLTgzMjA1N2JiNzQxNS1JTUctMjAyNDEyMDQtV0EwMDA2LmpwZyIsImlhdCI6MTczMzMxMDM4OX0.quENnILJOMndzI7hmDNaije6-2WEAfI_v_2V9ag9Ojk',
      'title': 'Flamingo Bay',
      'location': 'Nerul',
    },
    {
      'image':
          'https://cdn.evhomes.tech/4d697ef5-a002-45ef-a60e-de4b8e1eb5e4-IMG-20241204-WA0011.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjRkNjk3ZWY1LWEwMDItNDVlZi1hNjBlLWRlNGI4ZTFlYjVlNC1JTUctMjAyNDEyMDQtV0EwMDExLmpwZyIsImlhdCI6MTczMzMxMDY1M30.LDzn0EMHDWLx7NugQPbjp2EKzuTcTBDfEW8xSXWkjsk',
      'title': 'The Venetian',
      'location': 'Vashi',
    },
    {
      'image':
          'https://cdn.evhomes.tech/61dc2e7c-5c4d-4811-9187-4c1e4dc67725-IMG-20241204-WA0003.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjYxZGMyZTdjLTVjNGQtNDgxMS05MTg3LTRjMWU0ZGM2NzcyNS1JTUctMjAyNDEyMDQtV0EwMDAzLmpwZyIsImlhdCI6MTczMzMxMDI2NH0.zTiefzfkBHEJ_Jxie1L7NlwSWx4o1Kdpui-tuEQ_iIE',
      'title': '23 Miami',
      'location': 'Koperkhairane',
    },
    {
      'image':
          'http://cdn.evhomes.tech/323a295f-4f2a-4391-8318-35ef225f41fa-IMG-20241204-WA0002.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjMyM2EyOTVmLTRmMmEtNDM5MS04MzE4LTM1ZWYyMjVmNDFmYS1JTUctMjAyNDEyMDQtV0EwMDAyLmpwZyIsImlhdCI6MTczMzMxMDA0MX0.XNVqEs2TLnETnbFeLN7th90AH4Tjlvf_pcR7Nebzc_4',
      'title': '23 Malibu West',
      'location': 'Koperkhairane',
    },
  ];

  final List<String> featuredProjectImages = [
    'http://cdn.evhomes.tech/35f6aa26-96e5-479a-b417-bef7ddd1a7c5-IMG-20241204-WA0005.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjM1ZjZhYTI2LTk2ZTUtNDc5YS1iNDE3LWJlZjdkZGQxYTdjNS1JTUctMjAyNDEyMDQtV0EwMDA1LmpwZyIsImlhdCI6MTczMzMxMDQ2OH0.jNqZsVFjrL7MMmtQqE3UNdit4Q6iACLaBF2s2tSNg7U',
    'http://cdn.evhomes.tech/2e04b32c-fc3d-4ae6-af96-81ab87537586-IMG-20241204-WA0012.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjJlMDRiMzJjLWZjM2QtNGFlNi1hZjk2LTgxYWI4NzUzNzU4Ni1JTUctMjAyNDEyMDQtV0EwMDEyLmpwZyIsImlhdCI6MTczMzMxMDU2MH0.WKBtN2NAhorF_SNSw86DlkY7PwTx0NTfeKw-NkmiDFY',
    'http://cdn.evhomes.tech/b582784e-82b0-410d-ba8a-01639dcf9710-IMG-20241204-WA0004.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImI1ODI3ODRlLTgyYjAtNDEwZC1iYThhLTAxNjM5ZGNmOTcxMC1JTUctMjAyNDEyMDQtV0EwMDA0LmpwZyIsImlhdCI6MTczMzMxMDE3Mn0.gUznkJek1dqNhc_poPRiblVd-6VaQKdGLbcHsdZ9ZEs',
    'http://cdn.evhomes.tech/d293473a-9ce0-4778-82c6-906afb01cf2d-IMG-20241204-WA0001.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImQyOTM0NzNhLTljZTAtNDc3OC04MmM2LTkwNmFmYjAxY2YyZC1JTUctMjAyNDEyMDQtV0EwMDAxLmpwZyIsImlhdCI6MTczMzMwOTc4Nn0.AkwLUKfeu3diSCi6mNHBl1szuXk8mJgTl3pBGRxwndI',
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
                          child: Image.network(
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
