import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/components/loading/loading_square.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/site_visit.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/admin_pages/site_visit_info_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:async';

class MySiteVisitPage extends StatefulWidget {
  const MySiteVisitPage({
    super.key,
  });

  @override
  State<MySiteVisitPage> createState() => _ManageSiteVisitPageState();
}

class _ManageSiteVisitPageState extends State<MySiteVisitPage> {
  String searchQuery = '';
  TextEditingController nameController = TextEditingController();
  List<SiteVisit> visits = [];
  bool isLoading = false;
  bool isFetchingMore = false;
  int currentPage = 1;
  Timer? _debounce; // Declare a Timer
  String? selectedSiteVisit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    getVisits(currentPage);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        fetchMoreVisits();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> getVisits(int page) async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    print("yes");
    if (settingProvider.loggedAdmin?.id == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    print("yes1");
    setState(() {
      isLoading = true;
    });
    print("yes2");
    try {
      final visitsResp = await settingProvider.getClosingManagerSiteVisitById(
        settingProvider.loggedAdmin?.id ?? "",
        searchQuery,
        page,
        10,
        selectedSiteVisit ?? "all",
      );
      print(visitsResp);
      print("yes3");

      final tes2 = visitsResp.data;

      setState(() {
        visits = tes2;
        print('Number of visits fetched: ${visits.length}');
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching visits: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchMoreVisits() async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    final totalPage = settingProvider.searchSiteVisit.totalPages;

    if (currentPage < totalPage && !isFetchingMore) {
      setState(() {
        isFetchingMore = true;
        currentPage++;
      });
      final visitsResp = await settingProvider.getClosingManagerSiteVisitById(
          settingProvider.loggedAdmin!.id!,
          searchQuery,
          currentPage,
          10,
          selectedSiteVisit ?? "all");
      final tes2 = visitsResp.data;

      setState(() {
        visits.addAll(tes2);
        isFetchingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    // settingProvider
    //     .getClosingManagerSiteVisitById(settingProvider.loggedAdmin?.id ?? "");
    // final visits = settingProvider.searchSiteVisit.data;
    final filteredLocalSiteVisits = visits;
    // String visitType = 'All';

    // final filteredLocalSiteVisits = visits.where((visit) {
    //   final nameLower = visit.firstName?.toLowerCase() ?? '';
    //   final searchLower = searchQuery.toLowerCase();
    //   return nameLower.contains(searchLower);
    // }).toList();

    return Stack(
      children: [
        const AnimatedGradientBg(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Manage Site Visit'),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  setState(() {
                    selectedSiteVisit = value;
                    // Update the visit type based on selection
                  });
                  getVisits(1);
                  settingProvider.getClosingManagerSiteVisitById(
                      settingProvider.loggedAdmin!.id ?? "");
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'Visit',
                      child: const Text('Visit'),
                      // onTap: () {
                      //   setState(() {
                      //     selectedSiteVisit = visitType;
                      //   });

                      //   // fetchMoreVisits();
                      // }
                    ),
                    const PopupMenuItem<String>(
                      value: 'Revisit',
                      child: Text('Revisit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'virtual-meeting',
                      child: Text('Virtual Meeting'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'All',
                      child: Text('All Visits'),
                    ),
                  ];
                },
                icon: const Icon(Icons.filter_list), // Filter icon
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (query) {
                    if (_debounce?.isActive ?? false) _debounce?.cancel();
                    setState(() {
                      searchQuery = query;
                    });
                    _debounce = Timer(const Duration(seconds: 1), () {
                      getVisits(1); // Fetch results after the delay
                    });
                    // getVisits(1); // Reset to page 1 for a new search
                  },
                  onEditingComplete: () {},
                  decoration: InputDecoration(
                    labelText: 'Search Site Visit',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: filteredLocalSiteVisits.isEmpty
                      ? const Center(child: Text('No Site visit found.'))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: filteredLocalSiteVisits.length + 1,
                          itemBuilder: (context, index) {
                            if (index == filteredLocalSiteVisits.length) {
                              return isFetchingMore
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : const SizedBox.shrink();
                            }
                            final visit = filteredLocalSiteVisits[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SiteVisitInfoPage(
                                      visit: visit,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 0.3,
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            NamedCard(
                                              heading: "Date",
                                              value: Helper.formatDate(
                                                visit.date.toString(),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            NamedCard(
                                              heading: "Client Name",
                                              value:
                                                  "${visit.firstName ?? ''} ${visit.lastName ?? ''}",
                                            ),
                                            const SizedBox(height: 5),
                                            NamedCard(
                                              heading: "Client Phone",
                                              value:
                                                  "${visit.countryCode} ${visit.phoneNumber}",
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              visit.verified
                                                  ? "Verfied"
                                                  : "Not verified",
                                              style: TextStyle(
                                                color: visit.verified
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),

                                            NamedCard(
                                              heading: "Closing manager",
                                              value: visit.closingManager !=
                                                      null
                                                  ? "${visit.closingManager?.firstName ?? ''} ${visit.closingManager?.lastName}"
                                                  : "NA",
                                            ),
                                            const SizedBox(height: 5),
                                            NamedCard(
                                              heading: "AttendedBy",
                                              value: visit.closingTeam
                                                  .map((ele) =>
                                                      "${ele.firstName} ${ele.lastName}\n")
                                                  .join(),
                                              ignoreLength: true,
                                            ),
                                            // ...visit.closingTeam.map(
                                            //   (ele) => NamedCard(
                                            //     heading: "AttendedBy",
                                            //     value:
                                            //         "${ele?.firstName ?? ''} ${ele?.lastName ?? ''}",
                                            //   ),
                                            // )
                                            // NamedCard(
                                            //   heading: "AttendedBy",
                                            //   value: visit.attendedBy != null
                                            //       ? "${visit.attendedBy?.firstName ?? ''} ${visit.attendedBy?.lastName ?? ''}"
                                            //       : "NA",
                                            // ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          "Projects: ",
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 11,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            visit.projects.isNotEmpty
                                                ? visit.projects
                                                    .map((proj) => proj.name)
                                                    .join(", ")
                                                : "NA",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          "Requirements: ",
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 11,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            visit.choiceApt.isNotEmpty
                                                ? visit.choiceApt.join(", ")
                                                : "NA",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ],
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
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.2),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}

class NamedCard extends StatelessWidget {
  final String heading;
  final String value;
  final bool ignoreLength;
  const NamedCard({
    super.key,
    required this.heading,
    required this.value,
    this.ignoreLength = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 11,
          ),
        ),
        Text(
          ignoreLength
              ? value
              : value.length > 18
                  ? "${value.substring(0, 15)}..."
                  : value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}


// import 'package:ev_home_beta/components/animated_gradient_screen.dart';
// import 'package:ev_home_beta/core/helper/helper.dart';
// import 'package:ev_home_beta/core/models/site_visit.dart';
// import 'package:ev_home_beta/core/provider/setting_provider.dart';
// import 'package:ev_home_beta/pages/site_visit_info_page.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ManageSiteVisitPage extends StatefulWidget {
//   const ManageSiteVisitPage({super.key});

//   @override
//   State<ManageSiteVisitPage> createState() => _ManageSiteVisitPageState();
// }

// class _ManageSiteVisitPageState extends State<ManageSiteVisitPage> {
//   String searchQuery = '';
//   TextEditingController nameController = TextEditingController();
//   List<SiteVisit> visits = [];
//   bool isLoading = false;
//   @override
//   void initState() {
//     super.initState();
//     getvisits(1);
//   }

//   Future<void> getvisits(int page) async {
//     final settingProvider = Provider.of<SettingProvider>(
//       context,
//       listen: false,
//     );
//     setState(() {
//       isLoading = true;
//     });
//     await settingProvider.searchSiteVisits(searchQuery, page, 10);
//     setState(() {
//       isLoading = false;
//     });
//     // final serv = await ApiService().getSiteVisit();

//     // setState(() {
//     //   visits = serv;
//     // });
//   }


//   @override
//   Widget build(BuildContext context) {
//     // Filter site visits based on the search query
//     final settingProvider = Provider.of<SettingProvider>(context);
//     final visits = settingProvider.searchSiteVisit;
//     final page = settingProvider.searchSiteVisit.page;
//     final totalPage = settingProvider.searchSiteVisit.totalPages;

//     final filteredLocalSiteVisits = visits.data.where((visit) {
//       final nameLower = visit.firstName?.toLowerCase() ?? '';
//       // final phone = visit.phoneNumber;
//       final searchLower = searchQuery.toLowerCase();
//       return nameLower.contains(searchLower);
//     }).toList();

//     return Stack(
//       children: [
//         const AnimatedGradientScreen(),
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             title: const Text('Manage Site Visit'),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 // Search field
//                 TextField(
//                   onChanged: (query) {
//                     setState(() {
//                       searchQuery = query;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     labelText: 'Search Site Visit',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     prefixIcon: const Icon(Icons.search),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         if (page > 1) {
//                           getvisits(page - 1);
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             page > 1 ? Colors.orange : Colors.grey.shade500,
//                       ),
//                       child: const Text(
//                         "Prev",
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.orange,
//                       ),
//                       child: Text(
//                         page.toString(),
//                         style: const TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         getvisits(page + 1);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: totalPage > page
//                             ? Colors.orange
//                             : Colors.grey.shade500,
//                       ),
//                       child: const Text(
//                         "Next",
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     // ElevatedButton(
//                     //   onPressed: () {},
//                     //   child: Text("Last"),
//                     // ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),

//                 // List of site visits
//                 Expanded(
//                   child: filteredLocalSiteVisits.isEmpty
//                       ? const Center(child: Text('No Site visit found.'))
//                       : ListView.builder(
//                           itemCount: filteredLocalSiteVisits.length,
//                           itemBuilder: (context, index) {
//                             final visit = filteredLocalSiteVisits[index];
//                             return GestureDetector(
//                               onTap: () {
//                                 Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                     builder: (context) => SiteVisitInfoPage(
//                                       visit: visit,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(10),
//                                 margin: const EdgeInsets.symmetric(
//                                   vertical: 10,
//                                   horizontal: 5,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(10),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.3),
//                                       spreadRadius: 0.3,
//                                       blurRadius: 2,
//                                     ),
//                                   ],
//                                 ),
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             NamedCard(
//                                               heading: "Client Name",
//                                               value:
//                                                   "${visit.firstName ?? ''} ${visit.lastName ?? ''}",
//                                             ),
//                                             const SizedBox(height: 5),
//                                             NamedCard(
//                                               heading: "Client Phone",
//                                               value:
//                                                   "${visit.countryCode} ${visit.phoneNumber}",
//                                             ),
//                                             const SizedBox(height: 5),
//                                             // NamedCard(
//                                             //   heading: "Source",
//                                             //   value: visit['source'],
//                                             // ),
//                                           ],
//                                         ),
//                                         const Spacer(),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             NamedCard(
//                                               heading: "Date",
//                                               value: Helper.formatDate(
//                                                 visit.date.toString(),
//                                               ),
//                                             ),

//                                             const SizedBox(height: 5),
//                                             NamedCard(
//                                               heading: "Closing manager",
//                                               value: visit.closingManager !=
//                                                       null
//                                                   ? "${visit.closingManager?.firstName ?? ''} ${visit.closingManager?.lastName}"
//                                                   : "NA",
//                                             ),
//                                             const SizedBox(height: 5),
//                                             NamedCard(
//                                               heading: "AttendedBy",
//                                               value: visit.attendedBy != null
//                                                   ? "${visit.attendedBy?.firstName ?? ''} ${visit.attendedBy?.lastName ?? ''}"
//                                                   : "NA",
//                                             ),
//                                             // const SizedBox(height: 5),
//                                             // NamedCard(
//                                             //   heading: "Team Leader",
//                                             //   value: visit['teamLeader']['name'] ??
//                                             //       "NA",
//                                             // ),
//                                           ],
//                                         )
//                                       ],
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           "Projects: ",
//                                           style: TextStyle(
//                                             color: Colors.grey.shade600,
//                                             fontSize: 11,
//                                           ),
//                                         ),
//                                         Flexible(
//                                           child: Text(
//                                             visit.projects.isNotEmpty
//                                                 ? visit.projects.join(", ")
//                                                 : "NA",
//                                             style: const TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 11,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           "Requirements: ",
//                                           style: TextStyle(
//                                             color: Colors.grey.shade600,
//                                             fontSize: 11,
//                                           ),
//                                         ),
//                                         Flexible(
//                                           child: Text(
//                                             visit.choiceApt.isNotEmpty
//                                                 ? visit.choiceApt.join(", ")
//                                                 : "NA",
//                                             style: const TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 11,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         if (isLoading)
//           Container(
//             color: Colors.black.withOpacity(0.2),
//             child: Center(
//               child: CircularProgressIndicator(),
//             ),
//           )
//       ],
//     );
//   }
// }

// class NamedCard extends StatelessWidget {
//   final String heading;
//   final String value;
//   const NamedCard({
//     super.key,
//     required this.heading,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           heading,
//           style: TextStyle(
//             color: Colors.grey.shade600,
//             fontSize: 11,
//           ),
//         ),
//         Text(
//           value.length > 18 ? "${value.substring(0, 15)}..." : value,
//           style: const TextStyle(
//             color: Colors.black,
//             fontSize: 12,
//           ),
//         ),
//       ],
//     );
//   }
// }