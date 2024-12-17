import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class PaymentScheduleGenerator extends StatefulWidget {
  final Lead? lead;
  final Flat? flat;

  const PaymentScheduleGenerator({super.key, this.lead, this.flat});

  @override
  _PaymentScheduleGeneratorState createState() =>
      _PaymentScheduleGeneratorState();
}

class _PaymentScheduleGeneratorState extends State<PaymentScheduleGenerator> {
  final TextEditingController flatNoController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController allInclusiveController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController carpetAreaController = TextEditingController();
  String selectedSlab = '1';
  String stampDuty = "5";
  String? pdfFilePath;

  List<Map<String, String>> slabs = [
    {'value': '1', 'name': 'On Booking'},
    {'value': '2', 'name': 'On Registration'},
    {'value': '3', 'name': 'Commencement of Work'},
    {'value': '4', 'name': 'On Completion of Foundation upto Plinth Level'},
    {'value': '5', 'name': 'On Commencement of 1st Slab'},
    {'value': '6', 'name': 'On Commencement of 2nd Slab'},
    {'value': '7', 'name': 'On Commencement of 3rd Slab'},
    {'value': '8', 'name': 'On Commencement of 4th Slab'},
    {'value': '9', 'name': 'On Commencement of 5th Slab'},
    {'value': '10', 'name': 'On Commencement of 6th Slab'},
    {'value': '11', 'name': 'On Commencement of 7th Slab'},
    {'value': '12', 'name': 'On Commencement of 8th Slab'},
    {'value': '13', 'name': 'On Commencement of 9th Slab'},
    {'value': '14', 'name': 'On Commencement of 10th Slab'},
    {'value': '15', 'name': 'On Commencement of 11th Slab'},
    {'value': '16', 'name': 'On Commencement of 12th Slab'},
    {'value': '17', 'name': 'On Commencement of 13th Slab'},
    {'value': '18', 'name': 'On Commencement of 14th Slab'},
    {'value': '19', 'name': 'On Commencement of 15th Slab'},
    {'value': '20', 'name': 'On Commencement of 16th Slab'},
    {'value': '21', 'name': 'On Commencement of 17th Slab'},
    {'value': '22', 'name': 'On Commencement of 18th Slab'},
    {'value': '23', 'name': 'On Commencement of 19th Slab'},
    {'value': '24', 'name': 'On Commencement of 20th Slab'},
    {'value': '25', 'name': 'On Commencement of 21th Slab'},
    {'value': '26', 'name': 'On Commencement of 22th Slab'},
    {'value': '27', 'name': 'On Commencement of 23th Slab'},
    {'value': '28', 'name': 'On Commencement of 24th Slab'},
    {'value': '29', 'name': 'On Commencement of 25th Slab'},
    {'value': '30', 'name': 'On Commencement of 26th Slab'},
    {'value': '31', 'name': 'On Commencement of Plumbing of Building'},
    {'value': '32', 'name': 'On Commencement of Flooring & Tiling'},
    {'value': '33', 'name': 'On Commencement of External Painting'},
    {'value': '34', 'name': 'On Possession'},
  ];

  Future<void> generatePDF() async {
    final pdf = pw.Document();
    final formatter = NumberFormat("#,##,###");
    double allInclusiveAmount = double.parse(allInclusiveController.text);
    double stampDutyPercentage = double.parse(stampDuty);
    double gstPercentage = 5.0;
    double registrationCharges = 30000;
    double agreementValue = (allInclusiveAmount - registrationCharges) /
        (((stampDutyPercentage + gstPercentage) / 100) + 1);
    double stampDutyValue = agreementValue * (stampDutyPercentage / 100);
    double gstValue = agreementValue * (gstPercentage / 100);
    double totalValue = agreementValue + gstValue;
    int selectedSlabIndex = int.parse(selectedSlab);
    double selectedSlabPercentage = _getSlabPercentage(selectedSlabIndex);
    double selectedSlabAmount = totalValue * (selectedSlabPercentage / 100);
    final List<List<String>> paymentSchedule = [
      ['1', 'On Booking', '9.5 %', formatter.format(totalValue * 0.095)],
      ['2', 'On Registration', '15.5 %', formatter.format(totalValue * 0.155)],
      [
        '3',
        'Commencement of Work',
        '10 %',
        formatter.format(totalValue * 0.10)
      ],
      [
        '4',
        'On Completion of Foundation upto Plinth Level',
        '5 %',
        formatter.format(totalValue * 0.05)
      ],
    ];
    for (int i = 5; i <= 30; i++) {
      paymentSchedule.add([
        '$i',
        'On Commencement of ${i - 4}${_getOrdinalSuffix(i - 4)} Slab',
        '2 %',
        formatter.format(totalValue * 0.02)
      ]);
    }
    paymentSchedule.addAll([
      [
        '31',
        'On Commencement of Plumbing of Building',
        '2 %',
        formatter.format(totalValue * 0.02)
      ],
      [
        '32',
        'On Commencement of Flooring & Tiling',
        '2 %',
        formatter.format(totalValue * 0.02)
      ],
      [
        '33',
        'On Commencement of External Painting',
        '2 %',
        formatter.format(totalValue * 0.02)
      ],
      ['34', 'On Possession', '2 %', formatter.format(totalValue * 0.02)],
      ['', 'TOTAL', '100 %', formatter.format(agreementValue + gstValue)],
      [
        '',
        'Before Registration (Stamp Duty & Registration Charges)',
        '',
        formatter.format(stampDutyValue + registrationCharges)
      ],
      ['', 'GRAND TOTAL', '', formatter.format(allInclusiveAmount)],
    ]);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.legal,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('PAYMENT SCHEDULE',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Flat No: ${flatNoController.text}'),
              pw.Text('Phone: ${phoneController.text}'),
              pw.Text('Client Name: ${clientNameController.text}'),
              pw.Text('Carpet Area: ${carpetAreaController.text} sq. ft.'),
              pw.Text(
                  'All Inclusive Amount: ${formatter.format(allInclusiveAmount)}'),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                columnWidths: {
                  0: const pw.FlexColumnWidth(0.5),
                  1: const pw.FlexColumnWidth(3),
                  2: const pw.FlexColumnWidth(0.7),
                  3: const pw.FlexColumnWidth(1.2),
                },
                children: [
                  pw.TableRow(
                    children: ['No.', 'Stage', '%', 'Amount']
                        .map((header) => pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              child: pw.Text(header,
                                  style: pw.TextStyle(
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.bold)),
                            ))
                        .toList(),
                  ),
                  ...paymentSchedule.asMap().entries.expand((entry) {
                    int index = entry.key;
                    List<String> row = entry.value;
                    if (index == selectedSlabIndex - 1) {
                      return [
                        pw.TableRow(
                          children: row
                              .map((cell) => pw.Padding(
                                    padding: const pw.EdgeInsets.all(2),
                                    child: pw.Text(cell,
                                        style:
                                            const pw.TextStyle(fontSize: 10)),
                                  ))
                              .toList(),
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(2),
                                child: pw.Text('')),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              child: pw.Text('Total up to selected slab',
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              child: pw.Text(
                                  '${selectedSlabPercentage.toStringAsFixed(1)} %',
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              child: pw.Text(
                                  formatter.format(selectedSlabAmount),
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold)),
                            ),
                          ],
                        ),
                      ];
                    } else {
                      return [
                        pw.TableRow(
                          children: row
                              .map((cell) => pw.Padding(
                                    padding: const pw.EdgeInsets.all(2),
                                    child: pw.Text(cell,
                                        style:
                                            const pw.TextStyle(fontSize: 10)),
                                  ))
                              .toList(),
                        ),
                      ];
                    }
                  }),
                ],
              ),
            ],
          );
        },
      ),
    );
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/payment_schedule.pdf');
    await file.writeAsBytes(await pdf.save());
    setState(() {
      pdfFilePath = file.path;
    });
    OpenFile.open(file.path);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF generated successfully')),
    );
  }

  double _getSlabPercentage(int slabIndex) {
    List<double> percentages = [
      9.5, // On Booking
      15.5, // On Registration
      10.0, // Commencement of Work
      5.0, // On Completion of Foundation upto Plinth Level
    ];

    // Add 2% for each subsequent slab
    for (int i = 5; i <= 34; i++) {
      percentages.add(2.0);
    }

    // Calculate cumulative percentage up to the selected slab
    return percentages.sublist(0, slabIndex).reduce((a, b) => a + b);
  }

  String _getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) {
      return 'th';
    }
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  Future<void> downloadPdf() async {
    if (pdfFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please generate the PDF first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final status = await Permission.storage.request();
    if (status.isGranted) {
      final downloadDir = Directory('/storage/emulated/0/Download');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      String pdfName = 'Payment_Schedule_${flatNoController.text}.pdf';
      final downloadPath = '${downloadDir.path}/$pdfName';

      await File(pdfFilePath!).copy(downloadPath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF downloaded to $downloadPath'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission denied to access storage'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.lead != null) {
      clientNameController.text =
          '${widget.lead?.firstName ?? ""} ${widget.lead?.lastName ?? ""}';
      phoneController.text = widget.lead?.phoneNumber?.toString() ?? '0';
    }
    if (widget.flat != null) {
      flatNoController.text = widget.flat?.flatNo ?? "";

      carpetAreaController.text = widget.flat?.carpetArea.toString() ?? "";
      allInclusiveController.text =
          widget.flat?.allInclusiveValue.toString() ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.lightBlueAccent],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Enter Payment Schedule Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: flatNoController,
                    label: 'Flat Number',
                    icon: Icons.home,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: clientNameController,
                    label: 'Client Name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: carpetAreaController,
                    label: 'Carpet Area (sq. ft.)',
                    icon: Icons.square_foot,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    value: selectedSlab,
                    label: 'Select Slab',
                    icon: Icons.layers,
                    items: slabs.map((Map<String, String> slab) {
                      return DropdownMenuItem<String>(
                        value: slab['value'],
                        child: Text(slab['name']!),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedSlab = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: allInclusiveController,
                    label: 'All Inclusive Amount',
                    icon: Icons.monetization_on,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    value: stampDuty,
                    label: 'Stamp Duty',
                    icon: Icons.local_offer,
                    items: ['5', '6'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text('$value %'),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        stampDuty = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: generatePDF,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Generate PDF'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: pdfFilePath != null ? downloadPdf : null,
                    icon: const Icon(Icons.download),
                    label: const Text('Download PDF'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String label,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      items: items,
      onChanged: onChanged,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      dropdownColor: Colors.white,
      menuMaxHeight: 300,
    );
  }
}
