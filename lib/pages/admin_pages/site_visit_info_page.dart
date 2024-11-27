import 'package:ev_homes/core/models/site_visit.dart';
import 'package:flutter/material.dart';

class SiteVisitInfoPage extends StatelessWidget {
  final SiteVisit visit;
  const SiteVisitInfoPage({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Site Visit Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NamedCard(heading: "Client Name", value: visit.firstName ?? 'NA'),
            const SizedBox(height: 5),
            NamedCard(
                heading: "Client Phone", value: visit.phoneNumber.toString()),
            const SizedBox(height: 5),
            NamedCard(heading: "Client Email", value: visit.email ?? "NA"),
          ],
        ),
      ),
    );
  }
}

class NamedCard extends StatelessWidget {
  final String heading;
  final String value;
  const NamedCard({
    super.key,
    required this.heading,
    required this.value,
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
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
