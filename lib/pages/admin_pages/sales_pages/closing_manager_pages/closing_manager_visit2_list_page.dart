import 'dart:async';
import 'package:ev_homes/components/date_filter_screen_leads.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/models/site_visit.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/admin_pages/site_visit_info_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class ClosingManagerVisit2ListPage extends StatefulWidget {
  final String status;
  final String? id;
  const ClosingManagerVisit2ListPage({
    super.key,
    required this.status,
    this.id,
  });

  @override
  State<ClosingManagerVisit2ListPage> createState() =>
      _ClosingManagerVisit2ListPageState();
}

class _ClosingManagerVisit2ListPageState
    extends State<ClosingManagerVisit2ListPage> {
  bool isLoading = false;
  bool isFetchingMore = false;
  bool showExport = false;
  String searchQuery = '';
  List<SiteVisit> leads = [];
  int currentPage = 1;
  int totalPages = 1;
  Timer? _debounce;
  String? _selectedStatus;

  final List<DropdownMenuItem<String>> listOfStatus = const [
    DropdownMenuItem(
      value: "active",
      child: Text("Active"),
    ),
    DropdownMenuItem(
      value: "inactive",
      child: Text("In-active"),
    ),
  ];

  Future<void> saveCSVToDownloads(List<Map<String, dynamic>> data) async {
    try {
      // Check and request storage permission
      if (await Permission.storage.request().isGranted) {
        // Define headers and rows
        List<List<dynamic>> rows = [];
        if (data.isNotEmpty) {
          // Add headers
          rows.add(data.first.keys.toList());

          // Add data rows
          for (var row in data) {
            rows.add(row.values.toList());
          }
        }

        // Convert to CSV format
        String csv = const ListToCsvConverter().convert(rows);

        // Get the Downloads directory
        Directory? downloadsDirectory =
            Directory('/storage/emulated/0/Download');
        if (!downloadsDirectory.existsSync()) {
          downloadsDirectory = await getExternalStorageDirectory();
        }

        final path =
            "${downloadsDirectory!.path}/data_${DateTime.now().millisecondsSinceEpoch}.csv";

        // Write CSV to file
        final file = File(path);
        await file.writeAsString(csv);

        // Notify the user
        print("File saved at: $path");
        // For download manager notification
        if (Platform.isAndroid) {
          print("You can integrate DownloadManager notification if needed.");
        }
      } else {
        print("Permission not granted to write to storage.");
      }
    } catch (e) {
      print("Error saving CSV to Downloads: $e");
    }
  }

  // Fetch initial leads or leads based on a new search
  Future<void> getLeads({bool resetPage = false}) async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );

    if (resetPage) {
      setState(() {
        currentPage = 1;
        leads = [];
        isLoading = true;
      });
    } else {
      setState(() {
        isFetchingMore = true;
      });
    }

    final visitsResp = await settingProvider.getClosingManagerSiteVisitById(
      widget.id ?? settingProvider.loggedAdmin!.id!,
      searchQuery,
      currentPage,
      10,
      widget.status,
    );

    if (mounted) {
      setState(() {
        if (resetPage) {
          leads = visitsResp.data;
        } else {
          leads.addAll(visitsResp.data);
        }
        totalPages = visitsResp.totalPages;
        isLoading = false;
        isFetchingMore = false;
      });
    }
  }

  String? getStatus(Lead lead) {
    if (lead.stage == "visit") {
      return lead.visitStatus;
    } else if (lead.stage == "revisit") {
      return lead.revisitStatus;
    } else if (lead.stage == "booking") {
      return lead.bookingStatus;
    }
    return lead.status;
  }

  // String getStatus1(SiteVisit lead) {
  //   if (lead.stage == "visit") {
  //     return "${Helper.capitalize(lead.stage ?? "")} ${Helper.capitalize(lead.visitStatus ?? '')}";
  //   } else if (lead.stage == "revisit") {
  //     return "${Helper.capitalize(lead.stage ?? "")} ${Helper.capitalize(lead.revisitStatus ?? '')}";
  //   } else if (lead.stage == "booking") {
  //     return "${Helper.capitalize(lead.stage ?? "")} ${Helper.capitalize(lead.bookingStatus ?? '')}";
  //   }

  //   return "${Helper.capitalize(lead.stage ?? "")} ${Helper.capitalize(lead.visitStatus ?? '')}";
  // }

  void onTapFilter(String status) {
    setState(() {
      _selectedStatus = status;
    });
    getLeads(resetPage: true);
  }

  @override
  void initState() {
    super.initState();
    getLeads(resetPage: true);
  }

  @override
  Widget build(BuildContext context) {
    final filteredLeads = leads;
    final settingProvider = Provider.of<SettingProvider>(context);
    final loggedDesg = settingProvider.loggedAdmin?.designation;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              "Tagging Report - ${_selectedStatus ?? widget.status}",
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'generatePdf') {
                    // _generatePdf(context);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'filter',
                    child: const Text('Filter'),
                    onTap: () {
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          MediaQuery.of(context).size.width - 50,
                          kToolbarHeight + 12,
                          12,
                          0,
                        ),
                        items: [
                          PopupMenuItem(
                            value: 'total',
                            child: const Text('All'),
                            onTap: () => onTapFilter("total"),
                          ),
                          PopupMenuItem(
                            value: 'visit-done',
                            child: const Text('Visit Done'),
                            onTap: () => onTapFilter("visit-done"),
                          ),
                          PopupMenuItem(
                            value: 'revisit-done',
                            child: const Text('Revisit Done'),
                            onTap: () => onTapFilter("revisit-done"),
                          ),
                          PopupMenuItem(
                            value: 'booking-done',
                            child: const Text('Booking Done'),
                            onTap: () => onTapFilter("booking-done"),
                          ),
                          PopupMenuItem(
                            value: 'visit-pending',
                            child: const Text('Visit Pending'),
                            onTap: () => onTapFilter("visit-pending"),
                          ),
                          PopupMenuItem(
                            value: 'revisit-pending',
                            child: const Text('Revisit Pending'),
                            onTap: () => onTapFilter("revisit-pending"),
                          ),
                          PopupMenuItem(
                            value: 'pending',
                            child: const Text('Both Pending'),
                            onTap: () => onTapFilter("pending"),
                          ),
                          PopupMenuItem(
                            value: 'tagging-over',
                            child: const Text('Tagging Over'),
                            onTap: () => onTapFilter("tagging-over"),
                          ),
                        ],
                      );
                    },
                  ),
                  if (loggedDesg!.id == "desg-post-sales-head" ||
                      loggedDesg!.id == "desg-app-developer" ||
                      loggedDesg!.id == "desg-site-head")
                    PopupMenuItem<String>(
                      value: 'export',
                      child: const Text('Export'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DateFilterScreenLeads(
                              onSelect: (start, end) {},
                              onSubmit: () {},
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                child: TextField(
                  onChanged: (query) {
                    if (_debounce?.isActive ?? false) _debounce?.cancel();
                    _debounce = Timer(const Duration(seconds: 1), () {
                      setState(() {
                        searchQuery = query;
                      });
                      getLeads(resetPage: true);
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search Lead',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              // ElevatedButton(
              //     onPressed: () => saveCSVToDownloads(
              //           filteredLeads.map((ele) => ele.toExportJson()).toList(),
              //         ),
              //     child: Text("export csv")),
              if (!isLoading && filteredLeads.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "No leads found",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!isFetchingMore &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      if (currentPage < totalPages) {
                        currentPage++;
                        getLeads(); // Fetch more leads
                      }
                    }
                    return true;
                  },
                  child: ListView.builder(
                    itemCount: filteredLeads.length + (isFetchingMore ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i == filteredLeads.length) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // final lead = filteredLeads[i];
                      final visit = filteredLeads[i];

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
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                                        value: visit.closingManager != null
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
                                        // ignoreLength: true,
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
              ),
            ],
          ),
        ),
        // if (showExport)
        //   DateFilterScreenLeads(
        //     onSelect: (start, end) {},
        //     onSubmit: () {},
        //   ),
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

Color _getStatusColor(String status) {
  if (status.toLowerCase().contains("booked")) {
    return Colors.green;
  } else if (status.toLowerCase().contains("rejected")) {
    return const Color.fromARGB(255, 255, 248, 248);
  } else if (status.toLowerCase().contains("pending") ||
      status.toLowerCase().contains("in progress")) {
    return Colors.orange;
  }
  return Colors.grey;
}

class NamedCard extends StatelessWidget {
  final String heading;
  final String value;
  final double? headingSize;
  final double? valueSize;

  const NamedCard({
    super.key,
    required this.heading,
    required this.value,
    this.headingSize,
    this.valueSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            heading,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: headingSize ?? 11,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value.length > 18 ? "${value.substring(0, 15)}..." : value,
            style: TextStyle(
              color: Colors.black,
              fontSize: valueSize ?? 12,
            ),
          ),
        ),
      ],
    );
  }
}
