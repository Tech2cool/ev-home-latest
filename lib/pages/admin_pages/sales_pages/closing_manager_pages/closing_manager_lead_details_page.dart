import 'package:ev_homes/components/loading/loading_square.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ClosingManagerLeadDetailsPage extends StatefulWidget {
  final Lead lead;
  const ClosingManagerLeadDetailsPage({
    super.key,
    required this.lead,
  });

  @override
  State<ClosingManagerLeadDetailsPage> createState() =>
      _ClosingManagerLeadDetailsPageState();
}

class _ClosingManagerLeadDetailsPageState
    extends State<ClosingManagerLeadDetailsPage> {
  List<Lead> similarLeads = [];
  bool checkingSimilarLead = false;
  bool isUpdating = false;
  int currentStep = 0;
  bool isLoading = false;
  Employee? selectedExecutive;

  @override
  void initState() {
    super.initState();
    getSimilarLead();
    onRefresh();
  }

  Future<void> onRefresh() async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    final loggedAdmin = settingProvider.loggedAdmin;
    try {
      setState(() {
        isLoading = true;
      });

      await settingProvider.getPreSaleExForTL(widget.lead.teamLeader!.id!);
    } catch (e) {
      //
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getSimilarLead() async {
    setState(() {
      checkingSimilarLead = true;
    });
    try {
      final resp = await ApiService().getSimilarLeads(widget.lead.id);
      setState(() {
        similarLeads = resp;
      });
    } catch (e) {
      setState(() {
        checkingSimilarLead = false;
      });
    }
    setState(() {
      checkingSimilarLead = false;
    });
  }

  void _showAssignDialog(
    BuildContext context,
    SettingProvider settingProvider,
    Employee? selectedExecutive,
  ) {
    // final List<String> executives = ['Kiran', 'Rohan'];
    final preSalesExecutive = settingProvider.preSaleExecutives;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Assign Lead to'),
          content: DropdownButtonFormField<Employee>(
            decoration: const InputDecoration(
              labelText: 'Executive',
              border: OutlineInputBorder(),
            ),
            value: selectedExecutive,
            items: preSalesExecutive.map((preSalesExecutive) {
              // print(
              //     "Executive: ${preSalesExecutive.firstName} ${preSalesExecutive.lastName}");
              return DropdownMenuItem<Employee>(
                value: preSalesExecutive,
                child: Text(
                    "${preSalesExecutive.firstName} ${preSalesExecutive.lastName}"),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedExecutive = newValue!;
                // print(selectedExecutive);
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Implement the assign functionality here
                await settingProvider.leadAssignToPresaleExcutive(
                  widget.lead.id,
                  selectedExecutive?.id ?? '',
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Assign',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Tagging Details'),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Edit') {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => EditTaggingPage(
                    //       lead: widget.lead,
                    //     ),
                    //   ),
                    // );
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'Edit',
                    child: Text('Edit'),
                  ),
                ],
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: onRefresh,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyTextCard(
                                heading: "Client Name: ",
                                value:
                                    "${widget.lead.firstName} ${widget.lead.lastName}",
                              ),
                              const SizedBox(height: 8),
                              MyTextCard(
                                  heading: "Phone: ",
                                  value:
                                      "${widget.lead.countryCode} ${widget.lead.phoneNumber}"),
                              const SizedBox(height: 8),
                              MyTextCard(
                                  heading: "Alternate Number: ",
                                  value: widget.lead.altPhoneNumber != null
                                      ? "${widget.lead.countryCode} ${widget.lead.altPhoneNumber}"
                                      : "NA"),
                              const SizedBox(height: 8),
                              MyTextCard(
                                heading: "Email: ",
                                value: (widget.lead.email != null &&
                                        widget.lead.email!.isNotEmpty)
                                    ? widget.lead.email!
                                    : "NA",
                              ),
                              const SizedBox(height: 8),
                              MyTextCard(
                                heading: "Requirement: ",
                                value: widget.lead.requirement.isNotEmpty
                                    ? widget.lead.requirement.join()
                                    : "NA",
                              ),
                              const SizedBox(height: 8),
                              MyTextCard(
                                heading: "Lead Status: ",
                                value: widget.lead.approvalStatus ?? "",
                                valueColor: _getStatusColor(
                                  widget.lead.approvalStatus ?? "",
                                ),
                              ),
                              const SizedBox(height: 8),
                              MyTextCard(
                                heading: "Interested: ",
                                value: widget.lead.interestedStatus ?? "",
                                valueColor: _getIntrestedColor(
                                  widget.lead.interestedStatus ?? "",
                                ),
                              ),
                              const SizedBox(height: 8),
                              MyTextCard(
                                heading: "Remark: ",
                                value: widget.lead.remark ?? 'NA',
                              ),
                              const SizedBox(height: 8),
                              MyTextCard(
                                heading: "Team Leader: ",
                                value: widget.lead.teamLeader != null
                                    ? "${widget.lead.teamLeader?.firstName ?? ""} ${widget.lead.teamLeader?.lastName ?? ""}"
                                    : "NA",

                                // valueColor: _getIntrestedColor(
                                //   widget.lead.interestedStatus,
                                // ),
                              ),
                              const SizedBox(height: 8),
                              MyTextCard(
                                heading: "Data Analyzer: ",
                                value: widget.lead.dataAnalyzer != null
                                    ? "${widget.lead.dataAnalyzer?.firstName ?? ""} ${widget.lead.dataAnalyzer?.lastName ?? ""}"
                                    : "NA",

                                // valueColor: _getIntrestedColor(
                                //   widget.lead.interestedStatus,
                                // ),
                              ),
                              const SizedBox(height: 8),
                              MyTextCard(
                                heading: "Pre Sale Executive: ",
                                value: widget.lead.preSalesExecutive != null
                                    ? "${widget.lead.preSalesExecutive?.firstName ?? ""} ${widget.lead.preSalesExecutive?.lastName ?? ""}"
                                    : "NA",

                                // valueColor: _getIntrestedColor(
                                //   widget.lead.interestedStatus,
                                // ),
                              ),
                              const SizedBox(height: 8),
                              MyTextCard(
                                heading: "Start Date: ",
                                value: Helper.formatDate(
                                  widget.lead.startDate.toString(),
                                ),
                                // valueColor: _getIntrestedColor(
                                //   widget.lead.interestedStatus,
                                // ),
                              ),
                              const SizedBox(height: 8),
                              MyTextCard(
                                heading: "Project: ",
                                value: widget.lead.project
                                    .map((pr) => pr.name)
                                    .join(", "),
                              ),
                              const SizedBox(height: 8),
                              MyTextCard(
                                heading: "Requirement: ",
                                value: widget.lead.requirement.join(", "),
                              ),
                              const SizedBox(height: 8),
                              MyTextCard(
                                heading: widget.lead.cycle != null
                                    ? "${Helper.capitalize(widget.lead.cycle?.stage ?? "")} Deadline: "
                                    : "Visit Deadline: ",
                                value: Helper.formatDateOnly(
                                  widget.lead.cycle?.validTill!.toString() ??
                                      '',
                                ),
                                valueColor: Colors.red,
                              ),
                              const SizedBox(height: 8),
                              MyTextCard(
                                heading: widget.lead.cycle != null
                                    ? "${Helper.capitalize(widget.lead.cycle?.stage ?? "")} Deadline: "
                                    : "Visit Deadline: ",
                                value: Helper.formatDateOnly(
                                  widget.lead.cycle?.validTill!.toString() ??
                                      '',
                                ),
                                valueColor: Colors.red,
                              ),

                              // MyTextCard(
                              //   heading: "Visit Deadline: ",
                              //   value: Helper.formatDateOnly(
                              //     widget.lead.cycle?.validTill!.toString() ??
                              //         '',
                              //   ),
                              // ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Channel Partner Details',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.lead.channelPartner != null) ...[
                                MyTextCard(
                                  heading: "Name: ",
                                  value: (widget.lead.channelPartner!.firstName!
                                              .isEmpty &&
                                          widget.lead.channelPartner!.lastName!
                                              .isEmpty)
                                      ? "NA"
                                      : "${widget.lead.channelPartner?.firstName ?? ''} ${widget.lead.channelPartner?.lastName ?? ''}",
                                ),
                                const SizedBox(height: 8),
                                MyTextCard(
                                  heading: "Firm Name: ",
                                  value: widget.lead.channelPartner?.firmName ??
                                      "NA",
                                ),
                                const SizedBox(height: 8),
                                MyTextCard(
                                  heading: "Rera Registration: ",
                                  value: widget.lead.channelPartner
                                              ?.haveReraRegistration ==
                                          true
                                      ? "Yes"
                                      : "NO",
                                ),
                                const SizedBox(height: 8),
                                MyTextCard(
                                  heading: "Rera Id: ",
                                  value:
                                      widget.lead.channelPartner?.reraNumber ??
                                          "NA",
                                ),
                              ] else
                                const MyTextCard(
                                  heading: "No Channel Partner",
                                  value: "",
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 400, // Constrained height for the stepper
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(5.0),
                    //     child: ListView(
                    //       children: const [
                    //         CustomTimelineTile(
                    //           title: "Approved",
                    //           date: "10/10/2024",
                    //           description: "welcome to ev home",
                    //           color: Colors.orange,
                    //           isFirst: true,
                    //         ),
                    //         CustomTimelineTile(
                    //           title: "Contacted",
                    //           date: "10/10/2024",
                    //           description: "welcome to ev home",
                    //           color: Colors.orange,
                    //         ),
                    //         CustomTimelineTile(
                    //           title: "Follow Up",
                    //           date: "10/10/2024",
                    //           description: "welcome to ev home",
                    //           color: Colors.orange,
                    //         ),
                    //         CustomTimelineTile(
                    //           title: "Site Visit",
                    //           date: "10/10/2024",
                    //           description: "welcome to ev home",
                    //           color: Colors.orange,
                    //         ),
                    //         CustomTimelineTile(
                    //           title: "Revisit",
                    //           date: "10/10/2024",
                    //           description: "welcome to ev home",
                    //           color: Colors.orange,
                    //         ),
                    //         CustomTimelineTile(
                    //           title: "Booking",
                    //           date: "10/10/2024",
                    //           description: "welcome to ev home",
                    //           color: Colors.orange,
                    //         ),
                    //         CustomTimelineTile(
                    //           title: "Registration",
                    //           date: "10/10/2024",
                    //           description: "welcome to ev home",
                    //           color: Color.fromARGB(255, 255, 223, 174),
                    //           isLast: true,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 24),
                    const Text(
                      'Additional Information',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      // height: 250,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (checkingSimilarLead)
                                const Text(
                                  "Checking Similar Leads....",
                                )
                              else ...[
                                if (similarLeads.isNotEmpty) ...[
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Date',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'CP Firm',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Status',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ...List.generate(
                                          similarLeads.length,
                                          (i) {
                                            final sLead = similarLeads[i];
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ClosingManagerLeadDetailsPage(
                                                      lead: sLead,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  _buildDummyLeadRow(
                                                    Helper.formatDate(
                                                      sLead.startDate
                                                          .toString(),
                                                    ),
                                                    sLead.channelPartner
                                                            ?.firmName ??
                                                        "NA",
                                                    sLead.approvalStatus ?? "",
                                                  ),
                                                  const Divider(),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  )
                                ] else
                                  const Text(
                                    "No Similar Leads",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (widget.lead.approvalHistory.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'Approval History',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(
                        widget.lead.approvalHistory.length,
                        (i) {
                          final appl = widget.lead.approvalHistory[i];
                          return CustomTimelineTile(
                            title: appl.employee != null
                                ? "${appl.employee?.firstName ?? ""} ${appl.employee?.lastName ?? ''}"
                                : "NA",
                            date: Helper.formatDate(
                                appl.approvedAt?.toString() ?? ''),
                            description: appl.remark ?? "NA",
                            color: Colors.red.withOpacity(0.8),
                            isFirst: i == 0,
                            isLast: i == widget.lead.approvalHistory.length - 1,
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
                    if (widget.lead.callHistory.isNotEmpty) ...[
                      const Text(
                        'Follow-up History',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(
                        widget.lead.callHistory.length,
                        (i) {
                          final appl = widget.lead.callHistory[i];
                          return CustomTimelineTile(
                            title: appl.caller != null
                                ? "${appl.caller?.firstName ?? ''} ${appl.caller?.lastName ?? ''}"
                                : "NA",
                            date: Helper.formatDate(
                                appl.callDate?.toString() ?? ''),
                            description: appl.remark ?? "NA",
                            color: Colors.red.withOpacity(0.8),
                            isFirst: i == 0,
                            isLast: i == widget.lead.callHistory.length - 1,
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
                    if (widget.lead.cycleHistory.isNotEmpty) ...[
                      const Text(
                        'Follow-up History',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(
                        widget.lead.cycleHistory.length,
                        (i) {
                          final appl = widget.lead.cycleHistory[i];
                          return CustomTimelineTile(
                            title: appl.teamLeader != null
                                ? "${appl.teamLeader?.firstName ?? ''} ${appl.teamLeader?.lastName ?? ''}"
                                : "NA",
                            date:
                                "${Helper.formatDate(appl.startDate?.toString() ?? '')} to ${Helper.formatDate(appl.validTill?.toString() ?? '')}",
                            description: appl.stage ?? "NA",
                            color: Colors.red.withOpacity(0.8),
                            isFirst: i == 0,
                            isLast: i == widget.lead.callHistory.length - 1,
                          );
                        },
                      ),
                    ],

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        children: [
                          // Expanded for Button 1
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _showAssignDialog(
                                  context,
                                  settingProvider,
                                  selectedExecutive,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.green, // Background color
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: const Text(
                                'Assign',
                                style: TextStyle(
                                  color: Colors.white, // Text color
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16), // Space between buttons
                          // Expanded for Button 2
                          // Expanded(
                          //   child: ElevatedButton(
                          //     onPressed: () {
                          //       _showEditBottomSheet(context);
                          //     },
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: Colors.amberAccent,
                          //       padding: const EdgeInsets.symmetric(vertical: 10.0),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(12.0),
                          //       ),
                          //     ),
                          //     child: const Text(
                          //       'Edit',
                          //       style: TextStyle(
                          //         color: Colors.white, // Text color
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),

                    // if (widget.lead.approvalStatus?.toLowerCase() !=
                    //     "approved")
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 16.0,
                    //       vertical: 12.0,
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         // Expanded for Button 1
                    //         Expanded(
                    //           child: ElevatedButton(
                    //             onPressed: () {
                    //               Helper.showCustomSnackBar(
                    //                 "Recall functionality coming soon.",
                    //                 Colors.green,
                    //               );
                    //             },
                    //             style: ElevatedButton.styleFrom(
                    //               backgroundColor: Colors.green, // Background color
                    //               padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //               shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(12.0),
                    //               ),
                    //             ),
                    //             child: const Text(
                    //               'Recall',
                    //               style: TextStyle(
                    //                 color: Colors.white, // Text color
                    //                 fontSize: 16,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         const SizedBox(width: 16), // Space between buttons
                    //         // Expanded for Button 2
                    //         Expanded(
                    //           child: ElevatedButton(
                    //             onPressed: () {
                    //               //TODO: DTA Comment Review Page
                    //               GoRouter.of(context).push(
                    //                 '/data-analyzer-lead-review',
                    //                 extra: {
                    //                   "lead": widget.lead,
                    //                   "similarLeads": similarLeads,
                    //                 },
                    //               );
                    //               // Navigator.push(
                    //               //   context,
                    //               //   MaterialPageRoute(
                    //               //     builder: (context) => AnalyserCommentReviewPage(
                    //               //       lead: widget.lead,
                    //               //       similarLeads: similarLeads,
                    //               //     ),
                    //               //   ),
                    //               // );
                    //             },
                    //             style: ElevatedButton.styleFrom(
                    //               backgroundColor: Colors.orange, // Background color
                    //               padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //               shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(12.0),
                    //               ),
                    //             ),
                    //             child: const Text(
                    //               'Review',
                    //               style: TextStyle(
                    //                 color: Colors.white, // Text color
                    //                 fontSize: 16,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isLoading) const LoadingSquare(),
      ],
    );
  }

  Widget _buildDummyLeadRow(String date, String firmNo, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(date),
        Text(firmNo),
        Text(
          status,
          style: TextStyle(color: _getStatusColor(status)),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
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

  Color _getIntrestedColor(String status) {
    switch (status.toLowerCase()) {
      case 'cold':
        return Colors.blue;
      case 'hot':
        return Colors.red;
      case 'warm':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}

class MyTextCard extends StatelessWidget {
  final String heading;
  final String value;
  final Color? headingColor;
  final Color? valueColor;
  const MyTextCard({
    super.key,
    required this.heading,
    required this.value,
    this.headingColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          heading,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: headingColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 15, color: valueColor),
        ),
      ],
    );
  }
}

class CustomTimelineTile extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final Color color;
  final bool isFirst;
  final bool isLast;

  const CustomTimelineTile({
    Key? key,
    required this.title,
    required this.date,
    required this.description,
    required this.color,
    this.isFirst = false,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(color: color),
      indicatorStyle: IndicatorStyle(
        width: 30,
        color: color,
        iconStyle: IconStyle(iconData: Icons.done, color: Colors.white),
      ),
      endChild: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
