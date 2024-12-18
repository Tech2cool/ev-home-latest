import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:flutter/material.dart';

class CpTaggingDeatils extends StatefulWidget {
  final Lead lead;
  const CpTaggingDeatils({
    required this.lead,
    super.key,
  });

  @override
  State<CpTaggingDeatils> createState() => _CpTaggingDeatilsState();
}

class _CpTaggingDeatilsState extends State<CpTaggingDeatils> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 240, 246),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            automaticallyImplyLeading: true,
            backgroundColor: Color(0xFF042630),
            title: const Text(
              'Tagging Details',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Client Information',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF042630),
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
                        NamedCard(
                            icon: Icons.person,
                            heading: "Client Name",
                            value:
                                '${widget.lead.firstName ?? ""} ${widget.lead.lastName ?? ""}'),
                        const SizedBox(height: 5),
                        NamedCard(
                          icon: Icons.phone,
                          heading: "Client Phone",
                          value: widget.lead.phoneNumber.toString(),
                        ),
                        const SizedBox(height: 8),
                        NamedCard(
                            icon: Icons.email,
                            heading: "Client Email",
                            value: widget.lead.email ?? "NA"),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              const Text(
                'Lead Details',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF042630),
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
                        NamedCard(
                          icon: Icons.home_work,
                          heading: "Requirements",
                          value: widget.lead.requirement.join(", ") ?? "",
                        ),
                        const SizedBox(height: 5),
                        NamedCard(
                          icon: Icons.calendar_today,
                          heading: "Start Date",
                          value: widget.lead.startDate.toString(),
                        ),
                        const SizedBox(height: 8),
                        NamedCard(
                          icon: Icons.calendar_month,
                          heading: "Valid Till Date",
                          value: widget.lead.validTill.toString(),
                        ),
                        const SizedBox(height: 8),
                        NamedCard(
                          icon: Icons.verified,
                          heading: "Remark",
                          value: getStatus1(widget.lead),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String getStatus1(Lead lead) {
  if (lead.stage == "visit") {
    return "${Helper.capitalize(lead.stage ?? "")} ${Helper.capitalize(lead.visitStatus ?? '')}";
  } else if (lead.stage == "revisit") {
    return "${Helper.capitalize(lead.stage ?? "")} ${Helper.capitalize(lead.revisitStatus ?? '')}";
  } else if (lead.stage == "approval") {
    return "${Helper.capitalize(lead.stage ?? "")} ${Helper.capitalize(lead.approvalStatus ?? '')}";
  } else if (lead.stage == "booking") {
    return "${Helper.capitalize(lead.stage ?? "")} ${Helper.capitalize(lead.bookingStatus ?? '')}";
  }
  return "${Helper.capitalize(lead.stage ?? "")} ${Helper.capitalize(lead.visitStatus ?? '')}";
}

class NamedCard extends StatelessWidget {
  final String heading;
  final String value;
  final bool ignoreLength;
  final IconData icon;
  const NamedCard({
    super.key,
    required this.heading,
    required this.value,
    this.ignoreLength = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24,
            color: Color(0xFF005254),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  heading,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
