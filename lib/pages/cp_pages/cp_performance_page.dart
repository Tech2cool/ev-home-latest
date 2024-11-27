import 'package:ev_homes/components/cp_funnel_chart.dart';
import 'package:ev_homes/components/cp_timeline.dart';
import 'package:ev_homes/core/models/cp_chart_data.dart';
import 'package:ev_homes/core/models/tagging_form_model.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
// import 'package:provider/provider.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  bool showTimeline = false;
  bool showTimeline2 = false;
  List<TaggingForm> leads = [];
  final List<String> marqueeTexts = [
    'Mayur just shared a Lead.',
    'Aktarul just shared a Lead.',
    'Mahek just shared a Lead.',
    'Shreya just shared a Lead.',
    'Dhanashri just shared a Lead.',
    'Mohan just shared a Lead.',
    'Ram just shared a Lead.',
    'Priya just shared a Lead.',
    'Amit just shared a Lead.',
    'Shreyas just shared a Lead.',
  ];

  final List<cpFunnelData> initialcpFunnelData = [
    cpFunnelData('Booking Done', 80),
    cpFunnelData('Site Visits Done', 10),
    cpFunnelData('Leads Contacted', 15),
    cpFunnelData('Leads Received', 20),
  ];

  void toggleTimeline() {
    setState(() {
      showTimeline = !showTimeline;
    });
  }

  void toggleTimeline2() {
    setState(() {
      showTimeline2 = !showTimeline2;
    });
  }

  // Widget _buildPerformerCard(String cpName) {
  //   return Stack(
  //     children: [
  //       // AnimatedGradient(),
  //       Container(
  //         padding: const EdgeInsets.all(8.0),
  //         width: MediaQuery.of(context).size.width * 0.6,
  //         decoration: BoxDecoration(
  //           color: Color(0xFFF4E9E0),
  //           // border: Border.all(),
  //           // borderRadius: BorderRadius.circular(15.0),
  //           borderRadius: BorderRadius.circular(20),
  //           border: Border.all(width: 0.5, color: Colors.black26),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Color.fromARGB(255, 133, 0, 0).withOpacity(0.4),
  //               offset: Offset(3, 3),
  //               blurRadius: 8,
  //               spreadRadius: 0,
  //             ),
  //           ],
  //         ),
  //         child: Row(
  //           children: [
  //             Stack(
  //               children: [
  //                 // User image with smaller size
  //                 Image.asset(
  //                   'assets/images/crown.png',
  //                   width: 70, // reduced width
  //                   height: 70, // reduced height
  //                 ),
  //                 // Crown image with larger size and positioned at the bottom right
  //                 Positioned(
  //                   bottom: 17,
  //                   right: 18,
  //                   child: Image.asset(
  //                     'assets/images/profile.png',
  //                     width: 30, // increased width
  //                     height: 30, // increased height
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(width: 10.0),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   children: [
  //                     Text(
  //                       "CP Firm Name: ",
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                     const Text(
  //                       "-",
  //                       style: TextStyle(color: Colors.black),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 4.0),
  //                 Row(
  //                   children: [
  //                     Text(
  //                       "CP Name: ",
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                     Text(
  //                       cpName,
  //                       style: TextStyle(color: Colors.black),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // final settingProvider = Provider.of<SettingProvider>(context);
    // final leads = leads;
    String clientId = "1";
    String clientName = "Client Name";
    String clientId2 = "2";
    String clientName2 = "Client Name";
    String combinedMarqueeText = marqueeTexts.join('  ');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Performance',
          style: TextStyle(
            color: Color.fromARGB(255, 133, 0, 0),
          ),
        ),
      ),
      body: Stack(
        children: [
          // AnimatedGradient(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 15),
                  //   child: const Text(
                  //     'Top 5 Performers of this Month',
                  //     style: TextStyle(
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.w500,
                  //         fontFamily: 'Manrope',
                  //         color: Colors.white),
                  //   ),
                  // ),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  //         child: _buildPerformerCard("Mayur"),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.only(right: 8.0),
                  //         child: _buildPerformerCard("Mahek"),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.only(right: 8.0),
                  //         child: _buildPerformerCard("Aktar"),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.only(right: 8.0),
                  //         child: _buildPerformerCard("Karan"),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.only(right: 8.0),
                  //         child: _buildPerformerCard("Rahul"),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFf4e9e0),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 0.4, color: Colors.black26),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 133, 0, 0)
                              .withOpacity(0.4),
                          offset: const Offset(3, 3),
                          blurRadius: 8,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 40,
                      child: Marquee(
                        text: combinedMarqueeText,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        blankSpace: 20, // Space between the text scroll
                        velocity: 100, // Scrolling speed
                        startPadding: 20, // Padding at the start
                        accelerationCurve: Curves.linear,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8), // Optional padding
                    decoration: BoxDecoration(
                      color: const Color(0xFFf4e9e0), // Background color
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                      border: Border.all(
                          width: 0.4, color: Colors.black26), // Border
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 133, 0, 0)
                              .withOpacity(0.4), // Shadow color
                          offset: const Offset(3, 3), // Shadow offset
                          blurRadius: 8, // Blur effect
                          spreadRadius: 3, // Shadow spread
                        ),
                      ],
                    ),
                    child: CpFunnelChart(
                      title: "Leads Funnel",
                      initialcpFunnelData: initialcpFunnelData,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFf4e9e0),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 0.4, color: Colors.black26),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 133, 0, 0)
                              .withOpacity(0.4), // Grey shadow color
                          offset: const Offset(3, 3), // Position the shadow
                          blurRadius: 8, // Blur effect
                          spreadRadius: 3, // Spread the shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            'Booking',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Manrope',
                                color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: toggleTimeline,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              '$clientId - $clientName',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (showTimeline)
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(120),
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(width: 0.4, color: Colors.black26),
                            ),
                            child: const Column(
                              children: [
                                // Start timeline
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 50.0),
                                  child: MyTimelineTile(
                                    isFirst: true,
                                    isLast: false,
                                    isPast: true,
                                    eventCard: Text("Token received"),
                                  ),
                                ),

                                // Middle timeline
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 50.0),
                                  child: MyTimelineTile(
                                    isFirst: false,
                                    isLast: false,
                                    isPast: true,
                                    eventCard: Text("Payment received"),
                                  ),
                                ),

                                // Middle timeline
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 50.0),
                                  child: MyTimelineTile(
                                    isFirst: false,
                                    isLast: false,
                                    isPast: false,
                                    eventCard: Text("Registration done"),
                                  ),
                                ),

                                // End timeline
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 50.0),
                                  child: MyTimelineTile(
                                    isFirst: false,
                                    isLast: true,
                                    isPast: false,
                                    eventCard: Text("Payout done"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: toggleTimeline2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              '$clientId2 - $clientName2',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (showTimeline2)
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(120),
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(width: 0.4, color: Colors.black26),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Start timeline
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 50.0),
                                  child: MyTimelineTile(
                                    isFirst: true,
                                    isLast: false,
                                    isPast: true,
                                    eventCard: Text("Token received"),
                                  ),
                                ),

                                // Middle timeline
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 50.0),
                                  child: MyTimelineTile(
                                    isFirst: false,
                                    isLast: false,
                                    isPast: true,
                                    eventCard: Text("Payment received"),
                                  ),
                                ),

                                // Middle timeline
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 50.0),
                                  child: MyTimelineTile(
                                    isFirst: false,
                                    isLast: false,
                                    isPast: false,
                                    eventCard: Text("Registration done"),
                                  ),
                                ),

                                // End timeline
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 50.0),
                                  child: MyTimelineTile(
                                    isFirst: false,
                                    isLast: true,
                                    isPast: false,
                                    eventCard: Text("Payout done"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FunnelChartDemo extends StatefulWidget {
  final List<TaggingForm> leads;

  const FunnelChartDemo({super.key, required this.leads});

  @override
  State<FunnelChartDemo> createState() => _FunnelChartDemoState();
}

class _FunnelChartDemoState extends State<FunnelChartDemo> {
  String _selectedFilter = "Last Week";
  late Map<String, List<Map<String, String>>> _funnelData;
  String? _selectedLabel;
  String? _selectedValue;

  bool _isCardVisible = false;

  @override
  void initState() {
    super.initState();
    _funnelData = _generateFunnelData();
  }

  Map<String, List<Map<String, String>>> _generateFunnelData() {
    return {
      "Last Week": _getFunnelDataForPeriod(
          DateTime.now().subtract(const Duration(days: 7))),
      "Last Month": _getFunnelDataForPeriod(
          DateTime.now().subtract(const Duration(days: 30))),
      "Last Year": _getFunnelDataForPeriod(
          DateTime.now().subtract(const Duration(days: 365))),
    };
  }

  List<Map<String, String>> _getFunnelDataForPeriod(DateTime startDate) {
    int noresponse = 22;
    int notInterested = 33;
    int pipelined = 30;
    int siteVisited = 10;
    int booked = 40;
    int total = noresponse + notInterested + pipelined + siteVisited + booked;

    for (var lead in widget.leads) {
      DateTime leadDate = DateTime.parse(lead.startDate);

      if (leadDate.isAfter(startDate)) {
        total++;
        if (lead.taggingStatus == 'NoResponse') noresponse++;
        if (lead.taggingStatus == 'NotInterested') notInterested++;
        if (lead.taggingStatus == 'Pipelined') pipelined++;
        if (lead.taggingStatus == 'Site visited') siteVisited++;
        if (lead.taggingStatus == 'Booked') booked++;
      }
    }

    return [
      {"label": "Total", "value": total.toString()},
      {"label": "NoResponse", "value": noresponse.toString()},
      {"label": "NotInterested", "value": notInterested.toString()},
      {"label": "Pipelined", "value": pipelined.toString()},
      {"label": "Site visited", "value": siteVisited.toString()},
      {"label": "Booked", "value": booked.toString()},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4E9E0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 0.5, color: Colors.black26),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 133, 0, 0)
                .withOpacity(0.4), // Grey shadow color
            offset: const Offset(0, 5), // Position the shadow
            blurRadius: 8, // Blur effect
            spreadRadius: 3, // Spread the shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Leads Statistics',
                style: TextStyle(
                  color: Colors.black87,
                  fontFamily: 'Manrope',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              DropdownButton<String>(
                value: _selectedFilter,
                icon: const Icon(Icons.arrow_drop_down),
                items: _funnelData.keys
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFilter = newValue!;
                    _selectedLabel = null;
                    _selectedValue = null;
                    _isCardVisible = false; // Hide the card when filter changes
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 5),
          // Wrap the Row in a SingleChildScrollView for horizontal scrolling
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _funnelData[_selectedFilter]!.map((data) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: FunnelStage(
                    label: data["label"]!,
                    value: data["value"]!,
                    onTap: () {
                      setState(() {
                        _selectedLabel = data["label"]!;
                        _selectedValue = data["value"]!;
                        _isCardVisible =
                            true; // Show the card when a label is clicked
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          // Step 3: Add the DetailCard below the funnel stages
          if (_isCardVisible &&
              _selectedLabel != null &&
              _selectedValue != null)
            DetailCard(
              label: _selectedLabel!,
              value: _selectedValue!,
              onClose: () {
                setState(() {
                  _isCardVisible =
                      false; // Hide the card when close icon is pressed or double tapped
                });
              },
            ), // Show the card
        ],
      ),
    );
  }
}

class FunnelStage extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const FunnelStage({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            MainAxisAlignment.center, // Center the content vertically
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          FunnelSegment(value: double.parse(value)), // Pass the value directly
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Color.fromARGB(221, 0, 0, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FunnelSegment extends StatelessWidget {
  final double value; // Changed from percentage to value

  const FunnelSegment({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0), // Add left padding here
      child: Container(
        width: 60, // Fixed width for all segments
        height: value, // Adjust height based on value
        margin: const EdgeInsets.only(top: 4.0), // Optional: margin on top
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(199, 248, 85, 4),
              Color(0xFFFFB22C),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0), // Set top radius here
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          value.toString(), // Display the value
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class DetailCard extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onClose; // Add a callback for closing the card

  const DetailCard(
      {super.key,
      required this.label,
      required this.value,
      required this.onClose});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Wrap the card with a GestureDetector for double tap
      onDoubleTap: onClose, // Call the onClose callback on double tap
      child: SizedBox(
        height: 400,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.only(
                top: 16, left: 16, right: 16), // Padding from the top
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                // Use a Stack to position the close icon
                children: [
                  SingleChildScrollView(
                    // Make content scrollable
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row with label on the left and value on the right
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              label,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              value,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors
                                    .blue, // You can change the color here
                              ),
                            ),
                            IconButton(
                              // Add a close icon button
                              icon: const Icon(Icons.close),
                              onPressed:
                                  onClose, // Call the onClose callback on icon press
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

// Additional fields
                        ...List.generate(12, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0), // Reduced vertical padding
                            child: Container(
                              padding: const EdgeInsets.only(
                                  bottom: 6.0), // Padding only at the bottom
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey), // Underline only
                                ),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text to start
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                          width:
                                              8), // Reduced space between image and text
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start, // Align text to the left
                                        children: [
                                          Text(
                                            '29/10/2024', // Phone number
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors
                                                    .grey), // Phone number style
                                          ),
                                          Text(
                                            'Sample Name', // Name of the person
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight
                                                    .bold), // Bold name
                                          ),
                                          SizedBox(height: 4),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
