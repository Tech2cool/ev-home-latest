import 'dart:io';
import 'package:ev_homes/pages/admin_pages/admin_forms/edit_site_visit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/site_visit.dart';
import 'package:ev_homes/components/loading/loading_generate_pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;

class SiteVisitInfoPage extends StatefulWidget {
  final SiteVisit visit;
  const SiteVisitInfoPage({Key? key, required this.visit}) : super(key: key);
  @override
  State<SiteVisitInfoPage> createState() => _SiteVisitInfoPageState();
}

class _SiteVisitInfoPageState extends State<SiteVisitInfoPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Site Visit Info"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'generatePdf') {
                _generatePdf(context);
              }
              if (value == 'edit') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditSiteVisitPage(visit: widget.visit)));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'generatePdf',
                child: Text('Generate PDF'),
              ),
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('Edit'),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Client Information"),
                NamedCard(
                  icon: Icons.person,
                  heading: "Client Name",
                  value:
                      "${widget.visit.firstName ?? ''} ${widget.visit.lastName ?? ''}",
                ),
                const SizedBox(height: 5),
                NamedCard(
                  icon: Icons.phone,
                  heading: "Client Phone",
                  value:
                      "${widget.visit.countryCode} ${widget.visit.phoneNumber ?? "NA"}",
                ),
                const SizedBox(height: 5),
                NamedCard(
                  icon: Icons.email,
                  heading: "Client Email",
                  value: widget.visit.email ?? "NA",
                ),
                const SizedBox(height: 5),
                const Divider(thickness: 1, height: 20),
                _buildSectionTitle("Visit Details"),
                NamedCard(
                  icon: Icons.type_specimen_rounded,
                  heading: "Visit Type",
                  value: widget.visit.visitType ?? "",
                ),
                const SizedBox(height: 5),
                NamedCard(
                  icon: Icons.calendar_today,
                  heading: "Date",
                  value: Helper.formatDate(widget.visit.date.toString()),
                ),
                const SizedBox(height: 5),
                NamedCard(
                  icon: Icons.work,
                  heading: "Projects",
                  value: widget.visit.projects.isNotEmpty
                      ? widget.visit.projects
                          .map((proj) => proj.name)
                          .join(", ")
                      : "NA",
                ),
                const SizedBox(height: 5),
                NamedCard(
                  icon: Icons.home_work,
                  heading: "Requirements",
                  value: widget.visit.choiceApt.isNotEmpty
                      ? widget.visit.choiceApt.join(", ")
                      : "NA",
                ),
                const SizedBox(height: 5),
                const Divider(thickness: 1, height: 20),
                _buildSectionTitle("Management"),
                NamedCard(
                  icon: Icons.manage_accounts,
                  heading: "Closing manager",
                  value: widget.visit.closingManager != null
                      ? "${widget.visit.closingManager?.firstName ?? ''} ${widget.visit.closingManager?.lastName}"
                      : "NA",
                ),
                const SizedBox(height: 5),
                NamedCard(
                  icon: Icons.verified,
                  heading: "Status",
                  value: widget.visit.verified ? "Verified" : "Not verified",
                ),
                const SizedBox(height: 5),
                NamedCard(
                  icon: Icons.group,
                  heading: "AttendedBy",
                  value: widget.visit.closingTeam
                      .map((ele) => "${ele.firstName} ${ele.lastName}\n")
                      .join(),
                  ignoreLength: true,
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          if (isLoading) const LoadingGeneratePdf()
        ],
      ),
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final pdf = pw.Document();

    try {
      // Load the background image
      final backgroundImageBytes =
          await rootBundle.load('assets/images/background.jpg');
      final backgroundImage =
          pw.MemoryImage(backgroundImageBytes.buffer.asUint8List());

      // Load the logo
      final logoUrl = widget.visit.projects.any((project) =>
              project.id == "project-ev-10-marina-bay-vashi-sector-10")
          ? 'https://cdn.evhomes.tech/699c315b-fa87-4b33-b61d-ec2386a222a3-10%20marina%20bay%20logo%20golden.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjY5OWMzMTViLWZhODctNGIzMy1iNjFkLWVjMjM4NmEyMjJhMy0xMCBtYXJpbmEgYmF5IGxvZ28gZ29sZGVuLnBuZyIsImlhdCI6MTczNDE2ODg3M30.PrRg3BAlKJOElB46rWGrzmq_Msgk3Bzw3ov7fR4aXQA'
          : 'https://cdn.evhomes.tech/dd1e1584-95b3-404d-a710-eb87d02d928f-NINE%20SQUARE%20new%20logo%20final%20%C3%A0%C2%A5%C2%A7.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6ImRkMWUxNTg0LTk1YjMtNDA0ZC1hNzEwLWViODdkMDJkOTI4Zi1OSU5FIFNRVUFSRSBuZXcgbG9nbyBmaW5hbCDDoMKlwqcucG5nIiwiaWF0IjoxNzM0MTY4ODgwfQ.1ad0P7Wy4HhwwRmJTwpUPNukNzZRrMJjKos_MUcYDuA';

      final http.Response logoResponse = await http.get(Uri.parse(logoUrl));
      final logoImage = pw.MemoryImage(logoResponse.bodyBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Stack(
              children: [
                // Background image
                pw.Positioned.fill(
                  child: pw.Image(backgroundImage, fit: pw.BoxFit.cover),
                ),
                // Semi-transparent overlay to improve readability
                pw.Positioned.fill(
                  child: pw.Container(
                    color: PdfColors.black.withOpacity(0.3),
                  ),
                ),
                // Content
                pw.Positioned.fill(
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Logo
                        pw.Center(
                          child: pw.Image(logoImage, width: 100, height: 100),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Center(
                          child: pw.Text(
                            'Site Visit Info',
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        _buildPdfSection('Client Information'),
                        _buildPdfNamedItem('Client Name',
                            "${widget.visit.firstName ?? ''} ${widget.visit.lastName ?? ''}"),
                        _buildPdfNamedItem('Client Phone',
                            "${widget.visit.countryCode} ${widget.visit.phoneNumber ?? "NA"}"),
                        _buildPdfNamedItem(
                            'Client Email', widget.visit.email ?? "NA"),
                        pw.SizedBox(height: 5),
                        _buildPdfSection('Visit Details'),
                        _buildPdfNamedItem('Date',
                            Helper.formatDate(widget.visit.date.toString())),
                        _buildPdfNamedItem(
                          'Projects',
                          widget.visit.projects.isNotEmpty
                              ? widget.visit.projects
                                  .map((proj) => proj.name)
                                  .join(", ")
                              : "NA",
                        ),
                        _buildPdfNamedItem(
                          'Requirements',
                          widget.visit.choiceApt.isNotEmpty
                              ? widget.visit.choiceApt.join(", ")
                              : "NA",
                        ),
                        pw.SizedBox(height: 5),
                        _buildPdfSection('Management'),
                        _buildPdfNamedItem(
                          'Closing manager',
                          widget.visit.closingManager != null
                              ? "${widget.visit.closingManager?.firstName ?? ''} ${widget.visit.closingManager?.lastName}"
                              : "NA",
                        ),
                        _buildPdfNamedItem(
                            'Status',
                            widget.visit.verified
                                ? "Verified"
                                : "Not verified"),
                        _buildPdfNamedItem(
                          'AttendedBy',
                          widget.visit.closingTeam
                              .map((ele) => "${ele.firstName} ${ele.lastName}")
                              .join(", "),
                        ),
                        pw.SizedBox(height: 5),
                        _buildPdfSection('Feedback'),
                        pw.Container(
                          height: 80,
                          width: 400,
                          color: PdfColors.white,
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/site_visit_info.pdf");
      await file.writeAsBytes(await pdf.save());

      setState(() {
        isLoading = false;
      });

      await OpenFile.open(file.path);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF generated')),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
    }
  }
}

extension on PdfColor {
  withOpacity(double d) {}
}

pw.Widget _buildPdfSection(String title) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 10, top: 10),
    padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    decoration: pw.BoxDecoration(
      color: PdfColors.orange,
      borderRadius: pw.BorderRadius.circular(5),
    ),
    child: pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 18,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
    ),
  );
}

pw.Widget _buildPdfNamedItem(String heading, String value) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 5),
    padding: const pw.EdgeInsets.all(8),
    decoration: pw.BoxDecoration(
      color: PdfColors.white.withOpacity(0.8),
      borderRadius: pw.BorderRadius.circular(5),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Text(
            heading,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
        ),
        pw.Expanded(
          flex: 3,
          child: pw.Text(
            value,
            style: pw.TextStyle(fontSize: 14, color: PdfColors.black),
          ),
        ),
      ],
    ),
  );
}

class NamedCard extends StatelessWidget {
  final String heading;
  final String value;
  final bool ignoreLength;
  final IconData icon;

  const NamedCard({
    Key? key,
    required this.heading,
    required this.value,
    this.ignoreLength = false,
    required this.icon,
  }) : super(key: key);

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
