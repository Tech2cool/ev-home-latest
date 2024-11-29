// lib/tagging_list_page.dart
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PreSalesExecutiveLeadListPage extends StatefulWidget {
  final String status;
  final String? id;
  const PreSalesExecutiveLeadListPage(
      {super.key, required this.status, this.id});

  @override
  State<PreSalesExecutiveLeadListPage> createState() =>
      _PreSalesExecutiveLeadListPageState();
}

class _PreSalesExecutiveLeadListPageState
    extends State<PreSalesExecutiveLeadListPage> {
  List<Lead> getLeads(SettingProvider settingProvider, String status) {
    final leads = settingProvider.leadsPreSaleExecutive.data;

    // if (status == "Contacted") {
    //   return leads.where((lead) => lead.status == "Contacted").toList();
    // } else if (status == "Followup") {
    //   return leads.where((lead) => lead.status == "Followup").toList();
    // } else if (status == "Pending") {
    //   return leads
    //       .where((lead) => lead.status == "Pending" || lead.status == "Pending")
    //       .toList();
    // }

    return leads;
  }

  Future<void> _onRefresh() async {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    try {
      await settingProvider.getPreSalesExecutiveLeads(
        widget.id ?? settingProvider.loggedAdmin!.id!,
      );
    } catch (e) {
      //
    } finally {
      //
    }
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final leads = settingProvider.leadsPreSaleExecutive;
    // final leads = settingProvider.leadsPreSaleExecutive;
    final filteredLeads = getLeads(settingProvider, widget.status);

    return Scaffold(
      appBar: AppBar(
        title: Text("Lead Report - ${widget.status}"),
        actions: [
          IconButton(
            onPressed: () {
              // Implement filter functionality if needed
            },
            icon: const Icon(Icons.filter_alt),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return constraint.maxWidth > 500
              ? GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: filteredLeads.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisExtent: 200,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, i) {
                    final lead = filteredLeads[i];
                    return GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push(
                          "/pre-sales-executive-lead-details",
                          extra: lead,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
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
                            Text(
                              lead.status ?? "",
                              style: TextStyle(
                                fontSize: 12,
                                color: _getStatusColor(lead.status ?? ''),
                              ),
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
                                        headingSize: 12,
                                        valueSize: 13,
                                        heading: "Client Name",
                                        value:
                                            "${lead.firstName}${lead.lastName}",
                                      ),
                                      const SizedBox(height: 5),
                                      NamedCard(
                                        heading: "Client Phone",
                                        value: "+91 ${lead.phoneNumber}",
                                      ),
                                      const SizedBox(height: 5),
                                      NamedCard(
                                        heading: "Tagging Date",
                                        value: lead.startDate.toString(),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      NamedCard(
                                        heading: "Valid Till",
                                        value: lead.validTill.toString(),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
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
                                        value: lead.channelPartner?.firmName ??
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
                                            ? "${lead.teamLeader?.firstName} ${lead.teamLeader?.lastName}"
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
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: filteredLeads.length,
                  itemBuilder: (context, i) {
                    final lead = filteredLeads[i];
                    return GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push(
                            "/pre-sales-executive-lead-details",
                            extra: lead);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 15),
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
                            Text(
                              lead.status ?? "",
                              style: TextStyle(
                                fontSize: 12,
                                color: _getStatusColor(lead.status ?? ""),
                              ),
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
                                        value: "+91 ${lead.phoneNumber}",
                                      ),
                                      const SizedBox(height: 5),
                                      NamedCard(
                                        heading: "Tagging Date",
                                        value: lead.startDate.toString(),
                                      ),
                                      const SizedBox(width: 5),
                                      NamedCard(
                                        heading: "Valid Till",
                                        value: lead.validTill.toString(),
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
                                        value: lead.channelPartner?.firmName ??
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
                                        value: lead.dataAnalyzer != null
                                            ? "${lead.dataAnalyzer?.firstName} ${lead.dataAnalyzer?.lastName}"
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
                );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Contacted':
        return Colors.green;
      case 'Followup':
        return Colors.red;

      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
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
