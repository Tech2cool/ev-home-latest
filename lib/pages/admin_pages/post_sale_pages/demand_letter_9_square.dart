import 'package:ev_homes/core/models/customer_payment.dart';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class DemandLetter extends StatefulWidget {
  const DemandLetter({super.key});

  @override
  _PaymentScheduleAndDemandLetterState createState() =>
      _PaymentScheduleAndDemandLetterState();
}

class _PaymentScheduleAndDemandLetterState extends State<DemandLetter> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController flatNoController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController allInclusiveController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController carpetAreaController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController netAmountController = TextEditingController();
  final TextEditingController cgstSgstController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController additionalNameController =
      TextEditingController();
  final TextEditingController tdsController = TextEditingController();
  String selectedSlab = '52';
  String? selectedFloor;
  String? selectedUnit;
  DateTime? selectedDate;
  String? pdfFilePath;
  double totalUpToSelectedSlab = 0.0;
  String stampDuty = "5";
  double cgstSgst = 0.0;
  double netAmount = 0.0;
  double totalAmount = 0.0;
  String? selectedReminder = '1';
  String clientPrefix = 'Mr.';
  // bool isTdsApplicable = false;
  double tdsAmount = 0.0;
  double remainingBase = 0.0;
  double remainingGst = 0.0;
  double remainingTds = 0.0;

  Payment? getpayment;

  String toRoman(int number) {
    if (number < 1 || number > 5) return number.toString();
    const List<String> romanNumerals = ['I', 'II', 'III', 'IV', 'V'];
    return romanNumerals[number - 1];
  }

  final NumberFormat currencyFormat = NumberFormat('#,##,##,##0', 'en_IN');

  List<Map<String, String>> additionalNames = [];
  final List<String> floors =
      List.generate(27, (index) => (index + 5).toString());
  final List<String> units = [
    '01',
    '02',
    '03',
    '04',
    '06',
    '07',
    '08',
    '09',
    '10'
  ];
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

  bool showAdditionalNameInput = false;

  @override
  void initState() {
    super.initState();
    netAmountController.addListener(_updateTotalAmount);
    cgstSgstController.addListener(_updateTotalAmount);
    allInclusiveController.addListener(_calculateTotalUpToSelectedSlab);
  }

  @override
  void dispose() {
    netAmountController.removeListener(_updateTotalAmount);
    cgstSgstController.removeListener(_updateTotalAmount);
    allInclusiveController.removeListener(_calculateTotalUpToSelectedSlab);
    netAmountController.dispose();
    cgstSgstController.dispose();
    totalAmountController.dispose();
    allInclusiveController.dispose();
    super.dispose();
  }

  void _updateTotalAmount() {
    setState(() {
      double netAmount =
          double.tryParse(netAmountController.text.replaceAll(',', '')) ?? 0;
      double cgstSgst =
          double.tryParse(cgstSgstController.text.replaceAll(',', '')) ?? 0;
      totalAmount = netAmount + cgstSgst;
      totalAmountController.text = currencyFormat.format(totalAmount);
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demand Letter Generator'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSection('Flat Details', [
                  _buildRow([
                    _buildDropdownField(
                      value: selectedFloor,
                      label: 'Floor',
                      icon: Icons.apartment,
                      items: floors
                          .map((floor) => DropdownMenuItem<String>(
                                value: floor,
                                child: Text(floor),
                              ))
                          .toList(),
                      onChanged: (newValue) {
                        setState(() => selectedFloor = newValue);
                        _updateFlatNo();
                      },
                    ),
                    _buildDropdownField(
                      value: selectedUnit,
                      label: 'Unit',
                      icon: Icons.door_front_door,
                      items: units
                          .map((unit) => DropdownMenuItem<String>(
                                value: unit,
                                child: Text(unit),
                              ))
                          .toList(),
                      onChanged: (newValue) {
                        setState(() => selectedUnit = newValue);
                        _updateFlatNo();
                      },
                    ),
                  ]),
                  _buildTextField(
                      controller: flatNoController,
                      label: 'Flat Number',
                      icon: Icons.home,
                      readOnly: true),
                  _buildTextField(
                      controller: carpetAreaController,
                      label: 'Carpet Area (sq. ft.)',
                      icon: Icons.square_foot,
                      keyboardType: TextInputType.number),
                  _buildDropdownField(
                    value: selectedSlab,
                    label: 'Construction Stage',
                    icon: Icons.layers,
                    items: slabs
                        .map((slab) => DropdownMenuItem<String>(
                              value: slab['value'],
                              child: Text(slab['name']!),
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() => selectedSlab = newValue!);
                      _calculateTotalUpToSelectedSlab();
                    },
                  ),
                ]),
                _buildSection('Client Details', [
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
                        child: _buildTextField(
                          controller: clientNameController,
                          label: 'Client Name',
                          icon: Icons.person,
                        ),
                      ),
                    ],
                  ),
                  ...additionalNames.map((name) => Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('${name['prefix']} ${name['name']}'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  additionalNames.remove(name);
                                });
                              },
                            ),
                          ],
                        ),
                      )),
                  if (showAdditionalNameInput)
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: additionalNameController,
                            label: 'Additional Name',
                            icon: Icons.person_add,
                          ),
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
                  _buildTextField(
                      controller: phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone),
                  _buildTextField(
                      controller: addressLine1Controller,
                      label: 'Address Line 1',
                      icon: Icons.location_on),
                  _buildTextField(
                      controller: addressLine2Controller,
                      label: 'Address Line 2',
                      icon: Icons.location_on),
                  _buildRow([
                    Expanded(
                        child: _buildTextField(
                            controller: cityController,
                            label: 'City',
                            icon: Icons.location_city)),
                    Expanded(
                        child: _buildTextField(
                            controller: pincodeController,
                            label: 'Pincode',
                            icon: Icons.pin_drop,
                            keyboardType: TextInputType.number)),
                  ]),
                  _buildTextField(
                      controller: referenceController,
                      label: 'Reference',
                      icon: Icons.description),
                ]),
                _buildSection('Financial Details', [
                  _buildTextField(
                    controller: netAmountController,
                    label: 'Net Amount',
                    icon: Icons.money,
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    controller: cgstSgstController,
                    label: 'CGST/SGST',
                    icon: Icons.receipt,
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    controller: totalAmountController,
                    label: 'Total Amount',
                    icon: Icons.calculate,
                    readOnly: true,
                  ),
                  _buildTextField(
                    controller: allInclusiveController,
                    label: 'All Inclusive Amount',
                    icon: Icons.monetization_on,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _calculateTotalUpToSelectedSlab(),
                  ),
                  _buildRow([
                    _buildDropdownField(
                      value: stampDuty,
                      label: 'Stamp Duty',
                      icon: Icons.local_offer,
                      items: ['5', '6']
                          .map((value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text('$value%'),
                              ))
                          .toList(),
                      onChanged: (newValue) {
                        setState(() => stampDuty = newValue!);
                        _calculateTotalUpToSelectedSlab();
                      },
                    ),
                    _buildDropdownField(
                      value: selectedReminder,
                      label: 'Reminder',
                      icon: Icons.alarm,
                      items: List.generate(
                          5,
                          (index) => DropdownMenuItem<String>(
                                value: (index + 1).toString(),
                                child: Text(
                                    '${index + 1} ${index == 0 ? 'day' : 'days'}'),
                              )),
                      onChanged: (newValue) {
                        setState(() => selectedReminder = newValue);
                      },
                    ),
                  ]),
                  _buildTextField(
                    controller: tdsController,
                    label: 'TDS Amount',
                    icon: Icons.money,
                    keyboardType: TextInputType.number,
                  ),
                  _buildDatePicker(),
                ]),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _generatePDF(context);
                    }
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Generate PDF'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: pdfFilePath != null ? _downloadPdf : null,
                  icon: const Icon(Icons.download),
                  label: const Text('Download PDF'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700)),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Row(
      children: children.map((child) => Expanded(child: child)).toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: keyboardType,
        validator: (value) => value!.isEmpty ? 'This field is required' : null,
        onChanged: onChanged,
        readOnly: readOnly,
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: items,
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select an option' : null,
        isExpanded: true,
        menuMaxHeight: 200,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        dropdownColor: Colors.white,
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Due Date',
            prefixIcon: const Icon(Icons.calendar_today),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            selectedDate != null
                ? DateFormat('dd-MM-yyyy').format(selectedDate!)
                : 'Select a date',
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _updateFlatNo() async {
    if (selectedFloor != null && selectedUnit != null) {
      setState(() {
        flatNoController.text = '$selectedFloor$selectedUnit';
      });
      final res =
          await ApiService().getPaymentbyFlat("$selectedFloor$selectedUnit");
      setState(() {
        getpayment = res;
        carpetAreaController.text = res?.carpetArea ?? "";
        clientNameController.text = res?.customerName ?? "";
        phoneController.text = res?.phoneNumber.toString() ?? "";
        addressLine1Controller.text = res?.address1 ?? "";
        addressLine2Controller.text = res?.address2 ?? "";
        cityController.text = res?.city ?? "";
        pincodeController.text = res?.pincode.toString() ?? "";
        netAmountController.text = res?.bookingAmt.toString() ?? "";
        cgstSgstController.text = res?.cgst.toString() ?? "";
        totalAmountController.text = res?.amtReceived.toString() ?? "";
        allInclusiveController.text = res?.allinclusiveamt.toString() ?? "";
        tdsController.text = res?.tds.toString() ?? "";

        print(res);
      });
    }
  }

  void _calculateTotalUpToSelectedSlab() {
    if (allInclusiveController.text.isEmpty) return;

    double allInclusiveAmount =
        double.parse(allInclusiveController.text.replaceAll(',', ''));
    double stampDutyPercentage = double.parse(stampDuty);
    double gstPercentage = 5.0;
    double registrationCharges = 30000;

    double agreementValue = (allInclusiveAmount - registrationCharges) /
        (((stampDutyPercentage + gstPercentage) / 100) + 1);
    double totalValue = agreementValue + (agreementValue * gstPercentage / 100);

    int selectedSlabIndex = int.parse(selectedSlab);
    double selectedSlabPercentage = _getSlabPercentage(selectedSlabIndex);

    setState(() {
      totalUpToSelectedSlab = totalValue * (selectedSlabPercentage / 100);
    });
  }

  String _getGreeting() {
    List<String> allPrefixes = [
      clientPrefix,
      ...additionalNames.map((name) => name['prefix'] ?? '')
    ];
    bool hasMr = allPrefixes.contains('Mr.');
    bool hasMrs = allPrefixes.contains('Mrs.');
    bool hasMiss = allPrefixes.contains('Miss');
    int totalClients = allPrefixes.length;

    if (totalClients == 1) {
      return clientPrefix == 'Mr.' ? 'Dear Sir,' : 'Dear Ma\'am,';
    } else if (totalClients == 2) {
      if (hasMr && (hasMrs || hasMiss)) {
        return 'Dear Sir/Ma\'am,';
      } else if (hasMr) {
        return 'Dear Sirs,';
      } else {
        return 'Dear Ma\'ams,';
      }
    } else {
      if (hasMr && (hasMrs || hasMiss)) {
        return 'Dear Sir/Ma\'am,';
      } else if (hasMr) {
        return 'Dear Sirs,';
      } else {
        return 'Dear Ma\'ams,';
      }
    }
  }

  Future<void> _generatePDF(BuildContext context) async {
    final pdf = pw.Document();
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('dd.MM.yyyy').format(currentDate);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 100),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Ref.: ${referenceController.text}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 15),
              pw.Text('To,',
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.Text(clientNameController.text,
                  style: const pw.TextStyle(fontSize: 12)),
              pw.Text(addressLine1Controller.text),
              pw.Text(addressLine2Controller.text),
              pw.Text(landmarkController.text),
              pw.Text('${cityController.text} - ${pincodeController.text}'),
              pw.SizedBox(height: 15),
              pw.Text(
                  'Sub: Outstanding Call Notice - Reminder ${toRoman(int.parse(selectedReminder!))}',
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              pw.Text(
                  'Ref: Your booking of Flat No-${flatNoController.text} in EV-9 Square, situated at plot No 16, Sector 9, Vashi, Navi Mumbai-400703',
                  style: const pw.TextStyle(fontSize: 12)),
              pw.SizedBox(height: 15),
              pw.Text(_getGreeting(),
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.Text(
                'We are pleased to inform you that we have completed Construction Work ${slabs[int.parse(selectedSlab) - 1]['name']} of EV-9 Square. The statement of your account is listed below. Please arrange to make the payment on or before "${selectedDate != null ? DateFormat('dd.MM.yyyy').format(selectedDate!) : 'N/A'}" to avoid late payment charges applicable as mentioned below.',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 15),
              _buildPdfTable(),
              pw.SizedBox(height: 10),
              pw.Text(
                  'Kindly transfer the above said proceeds on or before "${selectedDate != null ? DateFormat('dd.MM.yyyy').format(selectedDate!) : 'N/A'}". Bank details are given below for your reference.'),
              pw.SizedBox(height: 50),
              pw.Text('Thanking you,'),
              pw.Text('Yours faithfully,'),
              pw.SizedBox(height: 15),
              pw.Text('For E V Homes Constructions Pvt. Ltd.'),
              pw.SizedBox(height: 50),
              pw.Text('Authorized Signature',
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold)),
            ],
          ),
          pw.SizedBox(height: 150),
          pw.Text(
            'Note: We are registered under Micro, Small and Medium Enterprise (MSME) Act and our registration no is MH330010403. As per provision of section 15 and 16, payments made to entity registered under MSME act, beyond 45 days would attract interest and penal consequence.',
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'GST is reconciled on monthly basis and delay in making payment to us will attract interest and penalty, the same will be charged on you at the rate as applicable time to time (i.e., Govt. rate).',
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 10),
              pw.Text('Bank Details',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              _buildPdfBankDetails(
                'ICIC Bank Limited (for Booking amount payment${currencyFormat.format(remainingBase.ceil())})',
                'Account Name:- E V Homes Construction Pvt.Ltd',
                '015105022186',
                'ICIC0000151',
                'ICIC Limited',
                'Vashi, Navi Mumbai',
              ),
              _buildPdfBankDetails(
                'ICIC Bank (for GST And TDS amount payment${currencyFormat.format(remainingGst.ceil())})',
                'Account Name:- E V Homes Construction Pvt.Ltd',
                '015105022390',
                'ICIC0000151',
                'ICIC Bank',
                'Vashi, Navi Mumbai',
              ),
            ],
          ),
        ],
      ),
    );

    try {
      final output = await getApplicationDocumentsDirectory();
      final file =
          File('${output.path}/payment_schedule_and_demand_letter.pdf');
      await file.writeAsBytes(await pdf.save());

      setState(() {
        pdfFilePath = file.path;
      });

      OpenFile.open(file.path);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('PDF generated successfully'),
            backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error generating PDF: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  pw.Widget _buildPdfTable() {
    double totalDue = totalUpToSelectedSlab;
    double receivedAmount =
        double.parse(totalAmountController.text.replaceAll(',', '')) +
            double.parse(tdsController.text.replaceAll(',', ''));
    int reminderDays = int.parse(selectedReminder!);

    // First calculate base amount without GST
    double baseAmount = (totalDue / 1.05);
    // Calculate GST amount
    double gstAmount = totalDue - baseAmount;
    // Calculate 1% TDS on original base amount
    double tdsAmount = baseAmount * 0.01;
    // Base amount remains the original amount (don't subtract TDS here)
    // This ensures TDS shows separately in its column
    double netAmount = baseAmount - tdsAmount;

    double receivedBase =
        double.parse(netAmountController.text.replaceAll(',', ''));
    double receivedGst =
        double.parse(cgstSgstController.text.replaceAll(',', ''));
    double receivedTds = double.parse(tdsController.text.replaceAll(',', ''));

    remainingBase = baseAmount - receivedBase;
    remainingGst = gstAmount - receivedGst;
    remainingTds = tdsAmount - receivedTds;
    // For total, we need to consider TDS reduction
    double remainingTotal = (remainingBase - remainingTds) + remainingGst;

    double latePaymentCharge = remainingBase * (reminderDays / 100.0);
    double latePaymentGST = latePaymentCharge * 0.18;
    double latetdspayment = 0.0; // Changed from "-" as double to 0.0
    double totalLatePayment = latePaymentCharge + latePaymentGST;

    double finalBase = remainingBase + latePaymentCharge;
    double finalGst = remainingGst + latePaymentGST;
    double finaltds = remainingTds;
    // Final total should consider TDS reduction
    double finalTotal = (finalBase - finaltds) + finalGst;

    List<pw.TableRow> rows = [
      _buildPdfTableRow(
          ['Particulars', 'Net Amount', 'CGST/SGST', 'TDS', 'Total'],
          isHeader: true),
      _buildPdfTableRow([
        'Amount due + GST @ 5%',
        currencyFormat.format(netAmount),
        currencyFormat.format(gstAmount),
        currencyFormat.format(tdsAmount),
        currencyFormat.format(totalDue)
      ]),
      _buildPdfTableRow([
        'Less - Recd amount',
        currencyFormat.format(receivedBase),
        currencyFormat.format(receivedGst),
        currencyFormat.format(receivedTds),
        currencyFormat.format(receivedAmount)
      ]),
      _buildPdfTableRow([
        'Total Amount Payable on or before ${selectedDate != null ? DateFormat('dd-MM-yyyy').format(selectedDate!) : 'N/A'}',
        currencyFormat.format(remainingBase),
        currencyFormat.format(remainingGst),
        currencyFormat.format(remainingTds),
        currencyFormat.format(remainingTotal),
      ]),
      _buildPdfTableRow([
        'Add - Late payment charges @ $reminderDays${reminderDays > 1 ? '%' : ''}  + GST @ 18%',
        currencyFormat.format(latePaymentCharge),
        currencyFormat.format(latePaymentGST),
        currencyFormat.format(latetdspayment),
        currencyFormat.format(totalLatePayment)
      ]),
      _buildPdfTableRow([
        'Total Amount Payable after ${selectedDate != null ? DateFormat('dd-MM-yyyy').format(selectedDate!) : 'N/A'}',
        currencyFormat.format(finalBase),
        currencyFormat.format(finalGst),
        currencyFormat.format(finaltds),
        currencyFormat.format(finalTotal)
      ]),
    ];
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
      children: rows,
    );
  }

  pw.TableRow _buildPdfTableRow(List<String> cells, {bool isHeader = false}) {
    final style = pw.TextStyle(
      fontSize: 10,
      fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
    );
    return pw.TableRow(
      children: cells
          .map((cell) => pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child:
                    pw.Text(cell, style: style, textAlign: pw.TextAlign.center),
              ))
          .toList(),
    );
  }

  pw.Widget _buildPdfBankDetails(String title, String accountName,
      String accountNo, String ifscCode, String bankName, String branch) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 1),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      padding: const pw.EdgeInsets.all(10),
      margin: const pw.EdgeInsets.only(bottom: 15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title,
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Divider(color: PdfColors.black, thickness: 1),
          pw.SizedBox(height: 5),
          pw.Text('Account Name: $accountName',
              style: const pw.TextStyle(fontSize: 10)),
          pw.Text('Account No: $accountNo',
              style: const pw.TextStyle(fontSize: 10)),
          pw.Text('IFSC Code: $ifscCode',
              style: const pw.TextStyle(fontSize: 10)),
          pw.Text('Bank Name: $bankName',
              style: const pw.TextStyle(fontSize: 10)),
          pw.Text('Branch: $branch', style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Future<void> _downloadPdf() async {
    if (pdfFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please generate the PDF first'),
            backgroundColor: Colors.red),
      );
      return;
    }
    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final downloadDir = Directory('/storage/emulated/0/Download');
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
        String pdfName =
            'Demand_Letter_${flatNoController.text}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';
        final downloadPath = '${downloadDir.path}/$pdfName';
        await File(pdfFilePath!).copy(downloadPath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('PDF downloaded to $downloadPath'),
              backgroundColor: Colors.green),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error downloading PDF: $e'),
              backgroundColor: Colors.red),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Permission denied to access storage'),
            backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildDropdown(
      {required String value,
      required List<String> items,
      required Function(String?) onChanged,
      String? label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
      ),
    );
  }
}
