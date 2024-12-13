import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/pages/customer_pages/featured_project_screen.dart';
import 'package:flutter/material.dart';
// import 'property_card_vertical.dart';

class UpcomingProjectsList extends StatelessWidget {
  final List<Map<String, String>> properties = [
    {
      'image':
          'http://cdn.evhomes.tech/323a295f-4f2a-4391-8318-35ef225f41fa-IMG-20241204-WA0002.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjMyM2EyOTVmLTRmMmEtNDM5MS04MzE4LTM1ZWYyMjVmNDFmYS1JTUctMjAyNDEyMDQtV0EwMDAyLmpwZyIsImlhdCI6MTczMzMxMDA0MX0.XNVqEs2TLnETnbFeLN7th90AH4Tjlvf_pcR7Nebzc_4',
      'title': '23 Malibu West',
      'location': 'Koperkhairane',
    },
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
  ];
  final List<String> featuredProjectImages = [
    'http://cdn.evhomes.tech/9263da1e-5f99-4edb-8279-308c9047a9fd-2.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjkyNjNkYTFlLTVmOTktNGVkYi04Mjc5LTMwOGM5MDQ3YTlmZC0yLnBuZyIsImlhdCI6MTczMzU3MzYyMH0.LX31wFrhZ_YZGpjgwKxzyji-MXDdL4DS064BFeBtTzw',
    'http://cdn.evhomes.tech/b2fad3d2-fe68-4aa7-9aa1-b07f7c8ff633-1.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImIyZmFkM2QyLWZlNjgtNGFhNy05YWExLWIwN2Y3YzhmZjYzMy0xLnBuZyIsImlhdCI6MTczMzU3MzU4NX0.GikGyZBlNqJXlrHfuuEQPaYspxcxaTuzIqfFhBDDvXE',
    "http://cdn.evhomes.tech/ff1a991f-8ee8-4f6d-962f-4fcf8626d4fa-4.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImZmMWE5OTFmLThlZTgtNGY2ZC05NjJmLTRmY2Y4NjI2ZDRmYS00LnBuZyIsImlhdCI6MTczMzU3MzY0MX0.NX4RgWfkYtzgcqHgOBMFWQjUUjmXSEMP6DwOVeGO-FM",
    'http://cdn.evhomes.tech/87f30262-d0fc-41da-bc4a-75558764c7d6-3.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6Ijg3ZjMwMjYyLWQwZmMtNDFkYS1iYzRhLTc1NTU4NzY0YzdkNi0zLnBuZyIsImlhdCI6MTczMzU3MzYzNn0.1EZwUCBFLD4Lrbi0lQk9BuE5HfZksODh1XVuT_-AiN8',
  ];

  UpcomingProjectsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(properties.length, (index) {
        return PropertyCardVertical(
          property: properties[index],
          featuredImage: featuredProjectImages[index],
        );
      }),
    );
  }
}

class PropertyCardVertical extends StatefulWidget {
  final Map<String, String> property;
  final String featuredImage;

  const PropertyCardVertical({
    Key? key,
    required this.property,
    required this.featuredImage,
  }) : super(key: key);

  @override
  _PropertyCardVerticalState createState() => _PropertyCardVerticalState();
}

class _PropertyCardVerticalState extends State<PropertyCardVertical>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeaturedProjectScreen(
              logoImagePath: widget.featuredImage,
              title: widget.property['title']!,
            ),
          ),
        );
      },

      child: MouseRegion(
        onEnter: (_) => _controller.forward(),
        onExit: (_) => _controller.reverse(),
        child: Container(
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 133, 0, 0).withOpacity(0.6),
                offset: const Offset(3, 3),
                blurRadius: 8,
                spreadRadius: 3,
              ),
            ],
          ),
          height: 120,
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
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _animation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          const Color.fromARGB(255, 26, 25, 25)
                                              .withOpacity(0.6),
                                      offset: const Offset(0, 6),
                                      blurRadius: 7,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    widget.property['image']!,
                                    height: 200,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
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
                                widget.property['title']!,
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
                                    widget.property['location']!,
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
      ),
    );
  }
}
