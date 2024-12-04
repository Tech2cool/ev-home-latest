import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class PaymentScheduleGenerators extends StatefulWidget {
  const PaymentScheduleGenerators({super.key});

  @override
  _PaymentScheduleGeneratorState createState() =>
      _PaymentScheduleGeneratorState();
}

class _PaymentScheduleGeneratorState extends State<PaymentScheduleGenerators> {
  final TextEditingController flatNoController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController allInclusiveController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController carpetAreaController = TextEditingController();
  String selectedSlab = '52';
  String stampDuty = "5";
  String? pdfFilePath;
  List<Map<String, String>> slabs = [
    {'value': '1', 'name': 'On Booking'},
    {'value': '2', 'name': 'On Execution of Agreement'},
    {'value': '3', 'name': 'On Completion of Plinth level'},
    {'value': '4', 'name': 'On Completion of 1st Slab (Ground)'},
    {'value': '5', 'name': 'On Completion of 2nd Slab (Podium 1)'},
    {'value': '6', 'name': 'On Completion of 3rd Slab (Podium 2)'},
    {'value': '7', 'name': 'On Completion of 4th Slab (Podium 3)'},
    {'value': '8', 'name': 'On Completion of 5th Slab (Podium 4)'},
    {'value': '9', 'name': 'On Completion of 6th Slab (Podium 5)'},
    {'value': '10', 'name': 'On Completion of 7th Slab (Podium 6)'},
    {'value': '11', 'name': 'On Completion of 8th Slab (Podium 7)'},
    {'value': '12', 'name': 'On Completion of 9th Slab (Podium 8)'},
    {'value': '13', 'name': 'On Completion of 10th Slab'},
    {'value': '14', 'name': 'On Completion of 11th Slab'},
    {'value': '15', 'name': 'On Completion of 12th Slab'},
    {'value': '16', 'name': 'On Completion of 13th Slab'},
    {'value': '17', 'name': 'On Completion of 14th Slab'},
    {'value': '18', 'name': 'On Completion of 15th Slab'},
    {'value': '19', 'name': 'On Completion of 16th Slab'},
    {'value': '20', 'name': 'On Completion of 17th Slab'},
    {'value': '21', 'name': 'On Completion of 18th Slab'},
    {'value': '22', 'name': 'On Completion of 19th Slab'},
    {'value': '23', 'name': 'On Completion of 20th Slab'},
    {'value': '24', 'name': 'On Completion of 21st Slab'},
    {'value': '25', 'name': 'On Completion of 22nd Slab'},
    {'value': '26', 'name': 'On Completion of 23rd Slab'},
    {'value': '27', 'name': 'On Completion of 24th Slab'},
    {'value': '28', 'name': 'On Completion of 25th Slab'},
    {'value': '29', 'name': 'On Completion of 26th Slab'},
    {'value': '30', 'name': 'On Completion of 27th Slab'},
    {'value': '31', 'name': 'On Completion of 28th Slab'},
    {'value': '32', 'name': 'On Completion of walls'},
    {'value': '33', 'name': 'On Completion of internal plaster'},
    {'value': '34', 'name': 'On Completion of Flooring'},
    {'value': '35', 'name': 'On Completion of Doors'},
    {'value': '36', 'name': 'On Completion of windows'},
    {'value': '37', 'name': 'On Completion of Sanitary fittings'},
    {'value': '38', 'name': 'On Completion of Staircase'},
    {'value': '39', 'name': 'On Completion of Lift well'},
    {'value': '40', 'name': 'On Completion of Lobbies'},
    {'value': '41', 'name': 'On Completion of external plumbing'},
    {'value': '42', 'name': 'On Completion of External plaster'},
    {'value': '43', 'name': 'On Completion of elevation'},
    {'value': '44', 'name': 'On Completion of waterproofing'},
    {'value': '45', 'name': 'On Completion of terrace'},
    {'value': '46', 'name': 'On Completion of Lift'},
    {'value': '47', 'name': 'On Completion of water pumps'},
    {'value': '48', 'name': 'On Completion of electrical fittings'},
    {
      'value': '49',
      'name':
          'On Completion of electro, mechanical and environmental requirements'
    },
    {'value': '50', 'name': 'On completion of entrance lobby'},
    {'value': '51', 'name': 'On completion of plinth protection and paving'},
    {'value': '52', 'name': 'On Possession'},
  ];

  Future<void> generatePDF() async {
    final pdf = pw.Document();
    final formatter = NumberFormat("#,##,###");

    double allInclusiveAmount =
        double.tryParse(allInclusiveController.text) ?? 0;
    double stampDutyPercentage = double.tryParse(stampDuty) ?? 5;
    double gstPercentage = 5.0;
    double registrationCharges = 30000;

    if (allInclusiveAmount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid All Inclusive Amount')),
      );
      return;
    }

    double agreementValue = (allInclusiveAmount - registrationCharges) /
        (((stampDutyPercentage + gstPercentage) / 100) + 1);
    double stampDutyValue = agreementValue * (stampDutyPercentage / 100);
    double gstValue = agreementValue * (gstPercentage / 100);
    double totalValue = agreementValue + gstValue;

    int selectedSlabIndex = int.parse(selectedSlab);
    double selectedSlabPercentage = _getSlabPercentage(selectedSlabIndex);
    double selectedSlabAmount = totalValue * (selectedSlabPercentage / 100);

    final List<List<String>> paymentSchedule = _generatePaymentSchedule(
        agreementValue,
        gstValue,
        stampDutyValue,
        registrationCharges,
        allInclusiveAmount,
        totalValue);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('PAYMENT SCHEDULE',
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold)),
              // pw.SizedBox(height: 10),
              pw.Text('Flat No: ${flatNoController.text}'),
              pw.Text('Phone: ${phoneController.text}'),
              pw.Text('Client Name: ${clientNameController.text}'),
              pw.Text('Carpet Area: ${carpetAreaController.text} sq. ft.'),
              pw.Text(
                  'All Inclusive Amount: ${formatter.format(allInclusiveAmount)}'),
              pw.SizedBox(height: 1),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5),
                columnWidths: {
                  0: const pw.FlexColumnWidth(0.5),
                  1: const pw.FlexColumnWidth(2.5),
                  2: const pw.FlexColumnWidth(0.5),
                  3: const pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                    children: ['No.', 'Stage', '%', 'Amount']
                        .map((header) => pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              child: pw.Text(header,
                                  style: pw.TextStyle(
                                      fontSize: 8,
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
                                        style: const pw.TextStyle(fontSize: 6)),
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
                                      fontSize: 6,
                                      fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              child: pw.Text(
                                  '${selectedSlabPercentage.toStringAsFixed(1)} %',
                                  style: pw.TextStyle(
                                      fontSize: 6,
                                      fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              child: pw.Text(
                                  formatter.format(selectedSlabAmount),
                                  style: pw.TextStyle(
                                      fontSize: 6,
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
                                        style: const pw.TextStyle(fontSize: 6)),
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
      const SnackBar(
        content: Text('PDF generated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  double _getSlabPercentage(int slabIndex) {
    List<double> percentages = [
      10.0, 20.0, 15.0, 3.0, // Slabs 1-4
      3.0, 3.0, 3.0, 3.0, // Slabs 5-8
      0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
      0.5, 0.5, 0.5, // Slabs 9-26
      0.2, 0.2, 0.2, 0.2, 0.2, // Slabs 27-31
      1.0, 1.0, 1.0, 1.0, 1.0, 1.25, 1.25, 1.25, 1.25, 1.0, 1.0, 1.0, 1.0, 1.0,
      4.0, 1.0, 2.0, 1.0, 2.0, 1.0, 5.0 // Slabs 32-52
    ];
    double total = percentages.sublist(0, slabIndex).reduce((a, b) => a + b);
    return total > 100 ? 100 : total;
  }

  String _getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) return 'th';
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

  List<List<String>> _generatePaymentSchedule(
      double agreementValue,
      double gstValue,
      double stampDutyValue,
      double registrationCharges,
      double allInclusiveAmount,
      double totalValue) {
    final formatter = NumberFormat("#,##,###");

    List<List<String>> schedule = [
      ['1', 'On Booking', '10 %', formatter.format(totalValue * 0.10)],
      [
        '2',
        'On Execution of Agreement',
        '20 %',
        formatter.format(totalValue * 0.20)
      ],
      [
        '3',
        'On Completion of Plinth level',
        '15 %',
        formatter.format(totalValue * 0.15)
      ],
      [
        '4',
        'On Completion of 1st Slab (Ground)',
        '3 %',
        formatter.format(totalValue * 0.03)
      ],
    ];

    for (int i = 5; i <= 8; i++) {
      schedule.add([
        '$i',
        'On Completion of ${i - 3}${_getOrdinalSuffix(i - 3)} Slab (Podium ${i - 3})',
        '3 %',
        formatter.format(totalValue * 0.03)
      ]);
    }
    for (int i = 9; i <= 26; i++) {
      schedule.add([
        '$i',
        'On Completion of ${i - 3}${_getOrdinalSuffix(i - 3)} Slab',
        '0.5 %',
        formatter.format(totalValue * 0.005)
      ]);
    }

    for (int i = 27; i <= 31; i++) {
      schedule.add([
        '$i',
        'On Completion of ${i - 3}${_getOrdinalSuffix(i - 3)} Slab',
        '0.2 %',
        formatter.format(totalValue * 0.002)
      ]);
    }

    List<List<String>> finishingStages = [
      [
        '32',
        'On Completion of walls',
        '1 %',
        formatter.format(totalValue * 0.01)
      ],
      [
        '33',
        'On Completion of internal plaster',
        '1 %',
        formatter.format(totalValue * 0.01)
      ],
      [
        '34',
        'On Completion of Flooring',
        '1 %',
        formatter.format(totalValue * 0.01)
      ],
      [
        '35',
        'On Completion of Doors',
        '1 %',
        formatter.format(totalValue * 0.01)
      ],
      [
        '36',
        'On Completion of windows',
        '1 %',
        formatter.format(totalValue * 0.01)
      ],
      [
        '37',
        'On Completion of Sanitary fittings',
        '1.25 %',
        formatter.format(totalValue * 0.0125)
      ],
      [
        '38',
        'On Completion of Staircase',
        '1.25 %',
        formatter.format(totalValue * 0.0125)
      ],
      [
        '39',
        'On Completion of Lift well',
        '1.25 %',
        formatter.format(totalValue * 0.0125)
      ],
      [
        '40',
        'On Completion of Lobbies',
        '1.25 %',
        formatter.format(totalValue * 0.0125)
      ],
      [
        '41',
        'On Completion of external plumbing',
        '1 %',
        formatter.format(totalValue * 0.01)
      ],
      [
        '42',
        'On Completion of External plaster',
        '1 %',
        formatter.format(totalValue * 0.01)
      ],
      [
        '43',
        'On Completion of elevation',
        '1 %',
        formatter.format(totalValue * 0.01)
      ],
      [
        '44',
        'On Completion of waterproofing',
        '1 %',
        formatter.format(totalValue * 0.01)
      ],
      [
        '45',
        'On Completion of terrace',
        '1 %',
        formatter.format(totalValue * 0.01)
      ],
      [
        '46',
        'On Completion of Lift',
        '4 %',
        formatter.format(totalValue * 0.04)
      ],
      [
        '47',
        'On Completion of water pumps',
        '1 %',
        formatter.format(totalValue * 0.01)
      ],
      [
        '48',
        'On Completion of electrical fittings',
        '2 %',
        formatter.format(totalValue * 0.02)
      ],
      [
        '49',
        'On completion of electro mechanical and environmental requirements',
        '1 %',
        formatter.format(totalValue * 0.01)
      ],
      [
        '50',
        'On completion of entrance lobby',
        '2 %',
        formatter.format(totalValue * 0.02)
      ],
      [
        '51',
        'On completion of plinth protection and paving',
        '1 %',
        formatter.format(totalValue * 0.01)
      ],
      ['52', 'On Possession', '5 %', formatter.format(totalValue * 0.05)],
    ];

    schedule.addAll(finishingStages);
    schedule.add(
        ['', 'TOTAL', '100 %', formatter.format(agreementValue + gstValue)]);
    schedule.add([
      '',
      'Before Registration (Stamp Duty & Registration Charges)',
      '',
      formatter.format(stampDutyValue + registrationCharges)
    ]);
    schedule.add(['', 'GRAND TOTAL', '', formatter.format(allInclusiveAmount)]);
    return schedule;
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

      String pdfName = 'Payment Schedule 02 - ${flatNoController.text}.pdf';
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
                    icon: Icons.currency_rupee_sharp,
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
                        child: Text(value),
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
      menuMaxHeight: 300,
      selectedItemBuilder: (BuildContext context) {
        return items.map<Widget>((DropdownMenuItem<String> item) {
          return Container(
            alignment: Alignment.centerLeft,
            constraints: const BoxConstraints(minWidth: 100),
            child: Text(
              item.value!,
              style: const TextStyle(color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList();
      },
    );
  }
}
