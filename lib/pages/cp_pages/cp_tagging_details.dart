import 'package:flutter/material.dart';

class CpTaggingDeatils extends StatefulWidget {
  final Map<String, String> client; // Accept client details

  const CpTaggingDeatils({super.key, required this.client});

  @override
  State<CpTaggingDeatils> createState() => _CpTaggingDeatilsState();
}

class _CpTaggingDeatilsState extends State<CpTaggingDeatils> {
  @override
  Widget build(BuildContext context) {
    final client = widget.client;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 238, 218),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.orange,
            title: const Text(
              'Tagging Details',
              style: TextStyle(
                color: Colors.black,
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
                  color: Colors.orange,
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
                            value: "John Deo"),
                        const SizedBox(height: 5),
                        NamedCard(
                          icon: Icons.phone,
                          heading: "Client Phone",
                          value: "9100668899",
                        ),
                        const SizedBox(height: 8),
                        NamedCard(
                          icon: Icons.phone_android,
                          heading: "Alternate Number",
                          value: "0987654321",
                        ),
                        const SizedBox(height: 8),
                        NamedCard(
                            icon: Icons.email,
                            heading: "Client Email",
                            value: "example@gmail.com"),
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
                  color: Colors.orange,
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
                          value: "2BHK",
                        ),
                        const SizedBox(height: 5),
                        NamedCard(
                          icon: Icons.calendar_today,
                          heading: "Start Date",
                          value: "11/12/2024",
                        ),
                        const SizedBox(height: 8),
                        NamedCard(
                          icon: Icons.calendar_month,
                          heading: "Valid Till Date",
                          value: "11/5/2025",
                        ),
                        const SizedBox(height: 8),
                        NamedCard(
                          icon: Icons.verified,
                          heading: "Remark",
                          value: "Progress",
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
          Icon(icon, size: 24, color: Color(0xFF9CA777)),
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
