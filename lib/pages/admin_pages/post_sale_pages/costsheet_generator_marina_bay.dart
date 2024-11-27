import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class CostGenerator extends StatefulWidget {
  const CostGenerator({super.key});

  @override
  State<CostGenerator> createState() => _CostGeneratorState();
}

class _CostGeneratorState extends State<CostGenerator> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController unitNoController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController carpetAreaController = TextEditingController();
  final TextEditingController allInclusiveAmountController = TextEditingController();
  final TextEditingController additionalNameController = TextEditingController();
  final TextEditingController floorController = TextEditingController();

  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  String stampDuty = '5';
  String clientPrefix = 'Mr.';
  bool photoUploaded = false;
  String? pdfFilePath;
  File? _image;

  final double gstPercentage = 5.0;

  List<Map<String, String>> additionalNames = [];

  Map<String, double> calculatedValues = {
    'agreementValue': 0.0,
    'registrationAmount': 30000.0,
    'gstAmount': 0.0,
    'stampDutyAmount': 0.0,
    'stampDutyRounded': 0.0,
  };
  bool showAdditionalNameInput = false;

  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##,###');
    return formatter.format(amount.round());
  }

  String formatAllInclusiveValue(double amount) {
    final formatter = NumberFormat('#,##,###');
    return '${formatter.format(amount.round())}/-';
  }

  void calculateValues() {
    final allInclusiveAmount = double.tryParse(allInclusiveAmountController.text) ?? 0;
    final stamp = double.tryParse(stampDuty) ?? 0;

    if (allInclusiveAmount > 0 && stamp > 0) {
      final agreementValue = (allInclusiveAmount - 30000) / (((stamp + gstPercentage) / 100) + 1);
      final gstAmount = agreementValue * (gstPercentage / 100);
      final stampDutyAmount = agreementValue * (stamp / 100);

      setState(() {
        calculatedValues = {
          'agreementValue': agreementValue,
          'registrationAmount': 30000,
          'gstAmount': gstAmount,
          'stampDutyAmount': stampDutyAmount,
          'stampDutyRounded': (stampDutyAmount / 10).ceil() * 10,
        };
      });
    }
  }

  Future<void> handlePhotoUpload() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
        photoUploaded = true;
      });
    }
  }

  Map<String, Map<String, String>> getAccountDetails(String projectName) {
    return {
      'booking': {
        'accountNo': '923020034471092',
        'ifscCode': 'UTIB0000072',
        'micrCode': '',
        'bankName': 'Axis Bank',
      },
      'tax': {
        'accountNo': '0123102000043254',
        'ifscCode': 'IBKL0000123',
        'micrCode': '',
        'bankName': 'IDBI Bank',
      },
    };
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final accountDetails = getAccountDetails('10 Marina Bay');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          // Calculate total number of clients
          int totalClients = 1 + additionalNames.length; // Main client + additional names

          // Determine the greeting
          String greeting = totalClients > 2 ? 'Dear Sir/Ma\'am,' : (clientPrefix == 'Mr.' ? 'Dear Sir,' : 'Dear Ma\'am,');

          return [
            pw.SizedBox(height: 65),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Ref.: ${referenceController.text}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                pw.Text('Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('To,'),
            pw.Text('$clientPrefix ${clientNameController.text}'),
            if (additionalNames.isNotEmpty) ...[
              ...additionalNames.map((name) => pw.Text('${name['prefix']} ${name['name']}')),
            ],
            pw.Text(addressLine1Controller.text),
            pw.Text(addressLine2Controller.text),
            pw.Text(landmarkController.text),
            pw.Text('${cityController.text} - ${pincodeController.text}'),
            pw.SizedBox(height: 20),
            pw.Text(greeting),
            pw.Text(
              'Subject: Cost Sheet for Flat No. ${unitNoController.text}, ${floorController.text}th Floor, EV 10 Marina Bay',
              style: const pw.TextStyle(decoration: pw.TextDecoration.underline),
            ),
            pw.SizedBox(height: 10),
            pw.Text('Please find below given cost details for the flat booked by you in our project, EV 10 Marina Bay, Plot no 10, sector-10, vashi, Navi Mumbai 400703'),
            pw.SizedBox(height: 10),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  const pw.TextSpan(text: 'Value of Flat '),
                  pw.TextSpan(
                    text: formatAllInclusiveValue(double.parse(allInclusiveAmountController.text)),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  const pw.TextSpan(text: ' inclusive of all.'),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            _buildCostTable(),
            pw.SizedBox(height: 10),
            _buildPayableTable(accountDetails),
            pw.SizedBox(height: 10),
            pw.Text('Kindly make arrangements for the payments as agreed by you.'),
            pw.SizedBox(height: 10),
            pw.Text('Thanking you,'),
            pw.Text('Yours faithfully,'),
            pw.SizedBox(height: 10),
            pw.Text('For E V Homes Constructions Pvt. Ltd.'),
            pw.SizedBox(height: 35),
            pw.Text('Authorized Signature', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final pdfName = 'Cost Sheet 01 - Unit ${unitNoController.text}.pdf';
    final file = File('${output.path}/$pdfName');
    await file.writeAsBytes(await pdf.save());
    setState(() {
      pdfFilePath = file.path;
    });
    OpenFile.open(file.path);
  }

  pw.Widget _buildCostTable() {
    return pw.Container(
      width: 400,
      child: pw.Table(
        border: pw.TableBorder.all(width: 0.5),
        columnWidths: {
          0: const pw.FlexColumnWidth(2),
          1: const pw.FlexColumnWidth(1),
          2: const pw.FlexColumnWidth(1),
        },
        children: [
          _buildTableHeader(['Particulars', 'Amount', 'Rounded']),
          _buildTableRow('Agreement Value', calculatedValues['agreementValue']!),
          _buildTableRow('Stamp duty @ $stampDuty%', calculatedValues['stampDutyAmount']!, rounded: calculatedValues['stampDutyRounded']!),
          _buildTableRow('Registration', calculatedValues['registrationAmount']!),
          _buildTableRow('GST @ 5% inclusive', calculatedValues['gstAmount']!),
          _buildTableRow('Total', double.parse(allInclusiveAmountController.text), isBold: true),
          _buildTableRow('Adjusted for Stampduty', calculatedValues['stampDutyAmount']!, rounded: calculatedValues['stampDutyRounded']! - calculatedValues['stampDutyAmount']!, isBold: true),
        ],
      ),
    );
  }

  pw.TableRow _buildTableHeader(List<String> cells) {
    return pw.TableRow(
      children: cells.map((cell) => pw.Padding(
        padding: const pw.EdgeInsets.all(2),
        child: pw.Text(cell, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
      )).toList(),
    );
  }

  pw.TableRow _buildTableRow(String particular, double amount, {double? rounded, bool isBold = false}) {
    final textStyle = pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: 9);
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text(particular, style: textStyle)),
        pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Align(alignment: pw.Alignment.center, child: pw.Text(formatCurrency(amount), style: textStyle)),
        ),
        rounded != null
            ? pw.Padding(
                padding: const pw.EdgeInsets.all(2),
                child: pw.Align(alignment: pw.Alignment.center, child: pw.Text(formatCurrency(rounded), style: textStyle)),
              )
            : pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('')),
      ],
    );
  }

  pw.Widget _buildPayableTable(Map<String, Map<String, String>> accountDetails) {
    final bookingAmount = calculatedValues['agreementValue']! * 0.1;
    final gstAmount = bookingAmount * 0.05;
    final tdsAmount = calculatedValues['agreementValue']! * 0.01;

    return pw.Container(
      width: 400,
      child: pw.Table(
        border: pw.TableBorder.all(width: 0.5),
        columnWidths: {
          0: const pw.FlexColumnWidth(2),
          1: const pw.FlexColumnWidth(1),
          2: const pw.FlexColumnWidth(2),
        },
        children: [
          _buildPayableTableHeader(['Payable Now ', 'Amount', 'Account Details']),
          _buildPayableTableRow(
            'Booking amount 10%',
            bookingAmount.ceil().toDouble(),
            '${accountDetails['booking']!['accountNo']}\n${accountDetails['booking']!['ifscCode']}\n${accountDetails['booking']!['bankName']}',
          ),
          _buildPayableTableRow(
            'GST amount (Payable)',
            gstAmount.ceil().toDouble(),
            '${accountDetails['tax']!['accountNo']}\n${accountDetails['tax']!['ifscCode']}\n${accountDetails['tax']!['bankName']}',
          ),
          _buildPayableTableRow(
            'Stamp Duty + Registration amount (Full)',
            (calculatedValues['stampDutyRounded']! + calculatedValues['registrationAmount']!).ceil().toDouble(),
            '${accountDetails['tax']!['accountNo']}\n${accountDetails['tax']!['ifscCode']}\n${accountDetails['tax']!['bankName']}',
          ),
          _buildPayableTableRow(
            'TDS @1%',
            tdsAmount.ceil().toDouble(),
            '${accountDetails['tax']!['accountNo']}\n${accountDetails['tax']!['ifscCode']}\n${accountDetails['tax']!['bankName']}',
          ),
          _buildPayableTableRow(
            'Total',
            (bookingAmount + gstAmount + calculatedValues['stampDutyRounded']! + calculatedValues['registrationAmount']! + tdsAmount).ceil().toDouble(),
            '',
            isBold: true,
          ),
        ],
      ),
    );
  }

  pw.TableRow _buildPayableTableHeader(List<String> cells) {
    return pw.TableRow(
      children: cells.map((cell) => pw.Padding(
        padding: const pw.EdgeInsets.all(2),
        child: pw.Text(cell, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
      )).toList(),
    );
  }

  pw.TableRow _buildPayableTableRow(String particular, double amount, String accountDetails, {bool isBold = false}) {
    final textStyle = pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: 9);
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text(particular, style: textStyle)),
        pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Align(alignment: pw.Alignment.centerRight, child: pw.Text(formatCurrency(amount), style: textStyle)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Text(accountDetails, style: textStyle),
        ),
      ],
    );
  }

  Future<void> downloadPdf() async {
    if (pdfFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please generate the PDF first')),
      );
      return;
    }

    final status = await Permission.storage.request();
    if (status.isGranted) {
      final downloadDir = Directory('/storage/emulated/0/Download');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      final pdfName = 'Cost Sheet 01 - Unit ${unitNoController.text}.pdf';
      final downloadPath = '${downloadDir.path}/$pdfName';

      await File(pdfFilePath!).copy(downloadPath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF downloaded to $downloadPath')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied to access storage')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cost Generator 10 Marina Bay"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCard(
                  "Booking Details",
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField("Unit No", unitNoController, isNumber: true),
                      _buildTextField("Floor", floorController, isNumber: true),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: _buildDropdown(
                              value: clientPrefix,
                              items: ["Mr.", "Mrs.", "Miss"],
                              onChanged: (value) {
                                setState(() {
                                  clientPrefix = value!;
                                });
                              },
                              label: "Prefix",
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: _buildTextField("Client Name", clientNameController),
                          ),
                        ],
                      ),
                      if (showAdditionalNameInput)
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField("Name", additionalNameController),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 100,
                              child: _buildDropdown(
                                value: "Mr.",
                                items: ["Mr.", "Mrs.", "Miss"],
                                onChanged: (value) {},
                                label: "Prefix",
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () {
                                if (additionalNameController.text.isNotEmpty) {
                                  setState(() {
                                    additionalNames.add({
                                      'name': additionalNameController.text,
                                      'prefix': "Mr.",
                                    });
                                    additionalNameController.clear();
                                    showAdditionalNameInput = false;
                                  });
                                }
                              },
                            ),
                          ],
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.blue),
                          onPressed: () {
                            setState(() {
                              showAdditionalNameInput = true;
                            });
                          },
                        ),
                      _buildTextField("Reference No", referenceController),
                      _buildTextField("Carpet Area", carpetAreaController, isNumber: true),
                      const SizedBox(height: 16),
                      const Text("Project Name: 10 Marina Bay"),
                      const SizedBox(height: 16),
                      const Text("Stamp Duty Percentage"),
                      _buildDropdown(
                        value: stampDuty,
                        items: ["5", "6"],
                        onChanged: (value) {
                          setState(() {
                            stampDuty = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField("All Inclusive Amount", allInclusiveAmountController, isNumber: true),
                      const SizedBox(height: 8),
                      const Text("GST Percentage: 5%", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildCard(
                  "Address Details",
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField("Flat, House no., Building, Company, Apartment", addressLine1Controller),
                      _buildTextField("Area, Street, Sector, Village", addressLine2Controller),
                      _buildTextField("Landmark", landmarkController),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField("Pincode", pincodeController, isNumber: true, hintText: "6-digit Pincode"),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField("Town/City", cityController),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildCard(
                  "Booking Form Photo",
                  Column(
                    children: [
                      if (_image != null) Image.file(_image!, height: 200, fit: BoxFit.cover),
                      const SizedBox(height: 16),
                      Center(
                        child: _buildButton(
                          onPressed: handlePhotoUpload,
                          icon: photoUploaded ? Icons.check : Icons.upload_file,
                          label: photoUploaded ? "Photo Uploaded" : "Upload Photo",
                          color: photoUploaded ? Colors.green : Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildCard(
                  "Cost Sheet",
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var entry in calculatedValues.entries)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(formatCurrency(entry.value)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      calculateValues();
                      generatePdf();
                    }
                  },
                  icon: Icons.picture_as_pdf,
                  label: "Generate Cost Sheet PDF",
                  color: Colors.purple,
                ),
                const SizedBox(height: 8),
                _buildButton(
                  onPressed: pdfFilePath != null ? downloadPdf : null,
                  icon: Icons.download,
                  label: "Download PDF",
                  color: pdfFilePath != null ? Colors.green : Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, Widget content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false, String? hintText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown({required String value, required List<String> items, required Function(String?) onChanged, String? label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildButton({required VoidCallback? onPressed, required IconData icon, required String label, required Color color}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}