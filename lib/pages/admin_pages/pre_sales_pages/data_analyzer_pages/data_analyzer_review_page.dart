import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/admin_pages/pre_sales_pages/data_analyzer_pages/data_analyzer_lead_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataAnalyzerReviewPage extends StatefulWidget {
  final Lead lead;
  final List<Lead> similarLeads;
  const DataAnalyzerReviewPage(
      {super.key, required this.lead, required this.similarLeads});

  @override
  State<DataAnalyzerReviewPage> createState() => _CommentReviewPageState();
}

class _CommentReviewPageState extends State<DataAnalyzerReviewPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _showCards = false;
  bool isLoading = false;
  Employee? _selectedTeamLeader;
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() {
      _showCards = !_showCards;
    });
  }

  void showDialogOnSubmit(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.only(
          top: 12,
          bottom: 5,
          right: 10,
          left: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(message),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.all(0),
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Ok",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showSelectTeamLeaderDialog() {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.only(
          top: 12,
          bottom: 5,
          right: 10,
          left: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Select Team Leader",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Employee>(
              value: _selectedTeamLeader,
              decoration: InputDecoration(
                labelText: 'Team Leader',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: settingProvider.closingManagers.map((teamleader) {
                return DropdownMenuItem<Employee>(
                  value: teamleader,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${teamleader.firstName} ${teamleader.lastName}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          "(${teamleader.designation?.designation ?? "NA"})",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedTeamLeader = newValue;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a Team Leader';
                }
                return null;
              },
              isExpanded: true,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 40),
                ElevatedButton(
                  onPressed: () async {
                    if (_selectedTeamLeader == null) return;
                    try {
                      await settingProvider.leadApproveAndAssignTL(
                        widget.lead.id,
                        _selectedTeamLeader!.id!,
                        _commentController.text,
                      );
                    } catch (e) {
                      //
                    } finally {
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                      showDialogOnSubmit("Lead Approved");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onPressReject() async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    try {
      setState(() {
        isLoading = true;
      });
      try {
        await settingProvider.leadRejectDataAnalyzer(
          widget.lead.id,
          _commentController.text,
        );
      } catch (e) {
        //
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> onPressApprove() async {
    // setState(() {
    //   isLoading = true;
    // });
    showSelectTeamLeaderDialog();
    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Comments'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Comment Box with attachment icon
                MyTextCard(
                  heading: "Client Name: ",
                  value: "${widget.lead.firstName} ${widget.lead.lastName}",
                ),
                const SizedBox(height: 8),
                MyTextCard(
                  heading: "Phone: ",
                  value:
                      "${widget.lead.countryCode} ${widget.lead.phoneNumber}",
                ),
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
                  heading: "Project: ",
                  value: widget.lead.project.map((pr) => pr.name).join(", "),
                ),

                const SizedBox(height: 8),

                MyTextCard(
                  heading: "Requirement: ",
                  value: widget.lead.requirement.isNotEmpty
                      ? widget.lead.requirement.join(", ")
                      : "NA",
                ),

                const SizedBox(height: 8),
                MyTextCard(
                  heading: "Remark: ",
                  value: widget.lead.remark ?? 'NA',
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Enter your comments here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.attachment),
                      onPressed:
                          _toggleVisibility, // Toggles the card visibility
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: onPressReject,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 249, 7, 7),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        child: const Text(
                          'Reject',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: onPressApprove,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 1, 116, 24),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        child: const Text(
                          'Approve',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                if (_showCards) ...[
                  if (widget.similarLeads.isNotEmpty)
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: List.generate(
                                      widget.similarLeads.length,
                                      (index) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          elevation: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // PDF box
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color: Colors.blue,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    'PDF',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "${widget.similarLeads[index].firstName} ${widget.similarLeads[index].lastName}",
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Text(
                                                            widget
                                                                        .similarLeads[
                                                                            index]
                                                                        .channelPartner !=
                                                                    null
                                                                ? widget
                                                                        .similarLeads[
                                                                            index]
                                                                        .channelPartner
                                                                        ?.firmName ??
                                                                    "NA"
                                                                : "NA",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        "${widget.similarLeads[index].countryCode} ${widget.similarLeads[index].phoneNumber}",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Status (Approved/Rejected alternating)
                                                Text(
                                                  widget
                                                          .similarLeads[index]
                                                          .approvalStage
                                                          ?.status ??
                                                      "",
                                                  style: TextStyle(
                                                    color: _getStatusColor(
                                                      widget
                                                              .similarLeads[
                                                                  index]
                                                              .approvalStage
                                                              ?.status ??
                                                          "",
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    Text("No Similar Leads")
                ],
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
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
}
