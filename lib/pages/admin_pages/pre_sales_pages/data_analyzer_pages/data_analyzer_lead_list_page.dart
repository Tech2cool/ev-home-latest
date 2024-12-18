import 'dart:async';
import 'package:ev_homes/components/date_filter_screen_leads.dart';
import 'package:ev_homes/components/searchable_dropdown.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/channel_partner.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DataAnalyzerLeadListPage extends StatefulWidget {
  final String status;
  const DataAnalyzerLeadListPage({super.key, required this.status});

  @override
  State<DataAnalyzerLeadListPage> createState() =>
      _DataAnalyzerLeadListPageState();
}

class _DataAnalyzerLeadListPageState extends State<DataAnalyzerLeadListPage> {
  bool isLoading = false;
  bool isFetchingMore = false;
  String searchQuery = '';
  List<Lead> leads = [];
  int currentPage = 1;
  int totalPages = 1;
  Timer? _debounce;
  ChannelPartner? selectedChannelPartner;
  String? stage;
  List<Lead> _getFilteredLeads() {
    if (widget.status == "approved") {
      return leads.where((lead) => lead.approvalStatus == "approved").toList();
    } else if (widget.status == "rejected") {
      return leads.where((lead) => lead.approvalStatus == "rejected").toList();
    } else if (widget.status == "pending") {
      return leads
          .where(
            (lead) =>
                lead.approvalStatus == "pending" ||
                lead.approvalStatus == "in progress",
          )
          .toList();
    }
    return leads;
  }

  Future<void> onRefresh() async {
    try {
      final settingProvider = Provider.of<SettingProvider>(
        context,
        listen: false,
      );

      setState(() {
        isLoading = true;
      });
      await settingProvider.getChannelPartners();
    } catch (e) {
      //
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onTapFilter(String? status) {
    setState(() {
      stage = status;
    });
    getLeads(resetPage: true);
  }

  // Fetch initial leads or leads based on a new search
  Future<void> getLeads({bool resetPage = false}) async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );

    if (resetPage) {
      setState(() {
        currentPage = 1; // Reset to first page
        leads = []; // Clear current leads
        isLoading = true;
      });
    } else {
      setState(() {
        isFetchingMore = true; // Show loading more indicator
      });
    }

    final visitsResp = await settingProvider.searchLead(
      searchQuery,
      currentPage,
      10,
      widget.status.toLowerCase() == "total"
          ? null
          : widget.status.toLowerCase(),
      stage,
      selectedChannelPartner?.id,
    );

    if (mounted) {
      setState(() {
        if (resetPage) {
          leads = visitsResp.data; // Set new leads
        } else {
          leads.addAll(visitsResp.data); // Append more leads
        }
        totalPages = visitsResp.totalPages; // Update total pages
        isLoading = false; // Hide loading
        isFetchingMore = false; // Hide loading more
      });
    }
  }

  String? getStatus(Lead lead) {
    if (lead.stage == "approval") {
      return lead.approvalStatus;
    } else if (lead.stage == "visit") {
      return lead.visitStatus;
    } else if (lead.stage == "revisit") {
      return lead.revisitStatus;
    } else if (lead.stage == "booking") {
      return lead.bookingStatus;
    } else if (lead.stage == "tagging-over") {
      return lead.stage;
    }
    return lead.approvalStatus;
  }

  @override
  void initState() {
    super.initState();
    getLeads(resetPage: true); // Fetch initial leads
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final filteredLeads = leads;
    final settingProvider = Provider.of<SettingProvider>(context);
    final loggedDesg = settingProvider.loggedAdmin?.designation;
    final channelPartners = settingProvider.channelPartners;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("Tagging Report - ${widget.status}"),
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
                            value: 'all',
                            child: const Text('All'),
                            onTap: () => onTapFilter('all'),
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
                  PopupMenuItem<String>(
                    value: 'channel-partner',
                    child: const Text('Channel Partner'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SearchableDropdown<ChannelPartner>(
                              initialSelection: selectedChannelPartner,
                              items: channelPartners,
                              labelBuilder: (ChannelPartner? emp) {
                                if (emp == null) {
                                  return "";
                                }
                                final name =
                                    "${emp.firstName} ${emp.lastName} (${emp.firmName ?? ''})";
                                return name;
                              },
                              label: "Channel Partner",
                              onChanged: (value) {
                                setState(() {
                                  selectedChannelPartner = value!;
                                });
                              },
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[300],
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 30),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[300],
                                    ),
                                    onPressed: () {
                                      getLeads(resetPage: true);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                      );
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => DateFilterScreenLeads(
                      //       onSelect: (start, end) {},
                      //       onSubmit: () {},
                      //     ),
                      //   ),
                      // );
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

                      final lead = filteredLeads[i];

                      return GestureDetector(
                        onTap: () {
                          // TODO: details page Lead DTA
                          GoRouter.of(context).push(
                            '/data-analyzer-lead-details',
                            extra: lead,
                          );

                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         AnalyserInternalTaggingDetails(lead: lead),
                          //   ),
                          // );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(240),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Helper.capitalize(
                                      getStatus(lead) ?? "",
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _getStatusColor(
                                        lead.approvalStatus ?? "",
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(height: 5),
                                  // Column(
                                  //   children: [
                                  //     Text(
                                  //       Helper.capitalize(
                                  //         lead.stage ?? "",
                                  //       ),
                                  //       style: const TextStyle(
                                  //         fontSize: 12,
                                  //         color: Colors.orangeAccent,
                                  //       ),
                                  //     ),
                                  //     const Text(
                                  //       "stage",
                                  //       style: TextStyle(
                                  //         fontSize: 9,
                                  //         color: Colors.grey,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        NamedCard(
                                          heading: "Client Name",
                                          value:
                                              "${lead.firstName} ${lead.lastName}",
                                        ),
                                        const SizedBox(height: 5),
                                        NamedCard(
                                          heading: "Client Phone",
                                          value:
                                              "${lead.countryCode} ${lead.phoneNumber}",
                                        ),
                                        const SizedBox(height: 5),
                                        NamedCard(
                                          heading: "Tagging Date",
                                          value: Helper.formatDate(
                                            lead.startDate.toString(),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        NamedCard(
                                          heading: "Valid Till",
                                          value: Helper.formatDate(
                                            lead.validTill.toString(),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        NamedCard(
                                          heading: "CP Firm Name",
                                          value:
                                              lead.channelPartner?.firmName ??
                                                  "NA",
                                        ),
                                        const SizedBox(height: 5),
                                        NamedCard(
                                          heading: "Data Analyser",
                                          value: lead.dataAnalyzer != null
                                              ? "${lead.dataAnalyzer?.firstName} ${lead.dataAnalyzer?.lastName}"
                                              : "NA",
                                        ),
                                        NamedCard(
                                          heading: "Team Leader",
                                          value: lead.teamLeader != null
                                              ? '${lead.teamLeader?.firstName} ${lead.teamLeader?.lastName}'
                                              : "NA",
                                        ),
                                      ],
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
  switch (status) {
    case 'approved':
      return Colors.green;
    case 'rejected':
      return Colors.red;
    case 'in progress':
    case 'pending':
      return Colors.orange;
    default:
      return Colors.grey;
  }
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
