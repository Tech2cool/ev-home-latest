import 'dart:async';
import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/core/models/post_sale_lead.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PostsaleexecutiveTaggingListPage extends StatefulWidget {
  final String status;
  final String? id;
  const PostsaleexecutiveTaggingListPage({
    super.key,
    required this.status,
    this.id,
  });

  @override
  State<PostsaleexecutiveTaggingListPage> createState() =>
      _PostsaleexecutiveTaggingListPageState();
}

class _PostsaleexecutiveTaggingListPageState
    extends State<PostsaleexecutiveTaggingListPage> {
  bool isLoading = false;
  bool isFetchingMore = false;
  String searchQuery = '';
  List<PostSaleLead> leads = [];
  int currentPage = 1;
  int totalPages = 1;
  Timer? _debounce;

  List<PostSaleLead> getFilteredLeads() {
    // if (widget.status == "Approved") {
    //   return leads.where((lead) => lead.approvalStatus == "Approved").toList();
    // } else if (widget.status == "Rejected") {
    //   return leads.where((lead) => lead.approvalStatus == "Rejected").toList();
    // } else if (widget.status == "Pending") {
    //   return leads
    //       .where(
    //         (lead) =>
    //             lead.approvalStatus == "Pending" ||
    //             lead.approvalStatus == "In Progress",
    //       )
    //       .toList();
    // }
    return leads;
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

    final visitsResp = await settingProvider.getPostSalesExecutiveLeads(
      widget.id ?? settingProvider.loggedAdmin!.id!,
      searchQuery,
      currentPage,
      10,
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

  @override
  void initState() {
    super.initState();
    getLeads(resetPage: true); // Fetch initial leads
  }

  @override
  Widget build(BuildContext context) {
    final filteredLeads = getFilteredLeads();

    return Stack(
      children: [
        const Positioned.fill(
          child: AnimatedGradientBg(),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text("Tagging Report - ${widget.status}"),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 6,
              ),
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
                      getLeads(
                          resetPage: true); // Fetch leads on new search query
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search Lead',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
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
                      return _buildLeadCard(context, lead);
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
    case 'Approved':
      return Colors.green;
    case 'Rejected':
      return Colors.red;
    case 'In Progress':
    case 'Pending':
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
              color: Colors.grey.shade700,
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

Widget _buildLeadCard(BuildContext context, PostSaleLead lead) {
  return Padding(
    padding: const EdgeInsets.symmetric(
        vertical: 10, horizontal: 10), // Adds space around the card
    child: GestureDetector(
      onTap: () {
        GoRouter.of(context).pushReplacement(
          "/post-sales-lead-details",
          extra: lead,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.3),
          //     spreadRadius: 0.3,
          //     blurRadius: 2,
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lead.bookingStatus?.type ?? '',
              style: TextStyle(
                fontSize: 12,
                color: _getStatusColor(lead.bookingStatus?.type ?? ''),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NamedCard(
                        heading: "Client Name",
                        value: "${lead.firstName} ${lead.lastName}" ?? 'N/A',
                      ),
                      const SizedBox(height: 5),
                      NamedCard(
                        heading: "Client Phone",
                        value: "+91 ${lead.phoneNumber}",
                      ),
                      const SizedBox(height: 5),
                      NamedCard(
                        heading: "Booking Date",
                        value: lead.date ?? 'N/A',
                      ),
                      const SizedBox(height: 5),
                      NamedCard(
                        heading: "Project",
                        value: lead.project?.name ?? 'N/A',
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NamedCard(
                        heading: "Booking Status",
                        value: lead.bookingStatus != null
                            ? lead.bookingStatus?.type ?? "NA"
                            : 'N/A',
                      ),
                      const SizedBox(height: 5),
                      NamedCard(
                        heading: "Closing Manager",
                        value: lead.closingManager != null
                            ? "${lead.closingManager?.firstName} ${lead.closingManager?.lastName}"
                            : 'N/A',
                      ),
                      const SizedBox(height: 5),
                      NamedCard(
                        heading: "Post Sales Executive",
                        value: lead.postSaleExecutive != null
                            ? "${lead.postSaleExecutive?.firstName} ${lead.postSaleExecutive?.lastName}"
                            : 'N/A',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
