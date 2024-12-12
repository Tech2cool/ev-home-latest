import 'package:ev_homes/core/models/site_visit.dart';
import 'package:flutter/material.dart';
import 'package:ev_homes/core/helper/helper.dart';

class SiteVisitInfoPage extends StatelessWidget {
  final SiteVisit visit;
  const SiteVisitInfoPage({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Site Visit Info",
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Client Information"),
            NamedCard(
                icon: Icons.person,
                heading: "Client Name",
                value: "${visit.firstName ?? ''} ${visit.lastName ?? ''}"),
            const SizedBox(height: 5),
            NamedCard(
                icon: Icons.phone,
                heading: "Client Phone",
                value: visit.phoneNumber.toString()),
            const SizedBox(height: 5),
            NamedCard(
                icon: Icons.email,
                heading: "Client Email",
                value: visit.email ?? "NA"),
            const SizedBox(height: 5),
            const Divider(thickness: 1, height: 20),
            _buildSectionTitle("Visit Details"),
            NamedCard(
              icon: Icons.calendar_today,
              heading: "Date",
              value: Helper.formatDate(
                visit.date.toString(),
              ),
            ),
            const SizedBox(height: 5),
            NamedCard(
              icon: Icons.work,
              heading: "Projects",
              value: visit.projects.isNotEmpty
                  ? visit.projects.map((proj) => proj.name).join(", ")
                  : "NA",
            ),
            const SizedBox(height: 5),
            NamedCard(
              icon: Icons.home_work,
              heading: "Requirements",
              value: visit.choiceApt.isNotEmpty
                  ? visit.choiceApt.join(", ")
                  : "NA",
            ),
            const SizedBox(height: 5),
            const Divider(thickness: 1, height: 20),
            _buildSectionTitle("Management"),
            NamedCard(
              icon: Icons.manage_accounts,
              heading: "Closing manager",
              value: visit.closingManager != null
                  ? "${visit.closingManager?.firstName ?? ''} ${visit.closingManager?.lastName}"
                  : "NA",
            ),
            const SizedBox(height: 5),
            NamedCard(
              icon: Icons.verified,
              heading: "Status",
              value: visit.verified ? "Verfied" : "Not verified",
            ),
            const SizedBox(height: 5),
            NamedCard(
              icon: Icons.group,
              heading: "AttendedBy",
              value: visit.closingTeam
                  .map((ele) => "${ele.firstName} ${ele.lastName}\n")
                  .join(),
              ignoreLength: true,
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
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
          Icon(icon, size: 24, color: Colors.orange),
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

Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
    ),
  );
}
