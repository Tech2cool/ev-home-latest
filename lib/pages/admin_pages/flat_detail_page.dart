import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/costsheet_generator_marina_bay.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/costsheet_generator_nine_square.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/demand_letter.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/demand_letter_9_square.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/payment_schedule%20_nine_square.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/payment_schedule_marina_bay.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import the intl package

class FlatDetailPage extends StatefulWidget {
  final OurProject project;
  final String flatNo;

  const FlatDetailPage({
    super.key,
    required this.project,
    required this.flatNo,
  });

  @override
  State<FlatDetailPage> createState() => _FlatDetailPageState();
}

class _FlatDetailPageState extends State<FlatDetailPage> {
  final _priceController = TextEditingController();
  bool status = false;
  String? customValue;
  double allInclusive = 0;
  final double registration = 30000;
  double stampDutyPercentage = 6.0;
  double gstPercentage = 5.0;
  String? selectedGenerate;

  void showPriceDialog() {
    _priceController.text = allInclusive.toStringAsFixed(2);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Price"),
        content: TextFormField(
          decoration: InputDecoration(
            labelText: "Price",
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
          ),
          controller: _priceController,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog without saving
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                customValue = _priceController.text;
                allInclusive = double.tryParse(customValue ?? '') ?? 0;
              });
              Navigator.pop(context); // Close dialog
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final flat = widget.project.flatList.singleWhere(
      (fl) => fl.flatNo == widget.flatNo,
    );
    status = flat.occupied!;
    allInclusive = flat.allInclusiveValue ?? 0;
    _priceController.text = flat.allInclusiveValue?.toString() ?? "";
  }

  String formatCurrency(double amount) {
    final format = NumberFormat.simpleCurrency(locale: 'en_IN', name: '₹');
    return format.format(amount);
  }

  Future<void> _showProjectDialogForCostSheet() async {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    final projects = settingProvider.ourProject;
    OurProject? selectedProject;
    // print(settingProvider.ourProject);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Project'),
          content: DropdownButtonFormField<OurProject>(
            value: projects.contains(selectedProject) ? selectedProject : null,
            decoration: InputDecoration(
              labelText: 'Select Project',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            items: projects.map((project) {
              return DropdownMenuItem<OurProject>(
                value: project,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.name ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedProject = newValue;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a Project';
              }
              return null;
            },
            isExpanded: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedProject!.name!.toLowerCase().contains("square")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CostGenerators(),
                    ),
                  );
                }
                if (selectedProject!.name!.toLowerCase().contains("marina")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CostGenerator(),
                    ),
                  );
                }
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
    // print(selectedProject);
  }

  Future<void> _showProjectDialogForPaymentSchedule() async {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    final projects = settingProvider.ourProject;
    OurProject? selectedProject;
    // print(settingProvider.ourProject);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Project'),
          content: DropdownButtonFormField<OurProject>(
            value: projects.contains(selectedProject) ? selectedProject : null,
            decoration: InputDecoration(
              labelText: 'Select Project',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            items: projects.map((project) {
              return DropdownMenuItem<OurProject>(
                value: project,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.name ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedProject = newValue;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a Project';
              }
              return null;
            },
            isExpanded: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedProject!.name!.toLowerCase().contains("square")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentScheduleGenerators(),
                    ),
                  );
                }
                if (selectedProject!.name!.toLowerCase().contains("marina")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentScheduleGenerator(),
                    ),
                  );
                }
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
    // print(selectedProject);
  }

  Future<void> _showProjectDialogForDemand() async {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    final projects = settingProvider.ourProject;
    OurProject? selectedProject;
    // print(settingProvider.ourProject);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Project'),
          content: DropdownButtonFormField<OurProject>(
            value: projects.contains(selectedProject) ? selectedProject : null,
            decoration: InputDecoration(
              labelText: 'Select Project',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            items: projects.map((project) {
              return DropdownMenuItem<OurProject>(
                value: project,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.name ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedProject = newValue;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a Project';
              }
              return null;
            },
            isExpanded: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedProject!.name!.toLowerCase().contains("square")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DemandLetter(),
                    ),
                  );
                }
                if (selectedProject!.name!.toLowerCase().contains("marina")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DemandLetter10(),
                    ),
                  );
                }
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
    // print(selectedProject);
  }

  @override
  Widget build(BuildContext context) {
    final flat = widget.project.flatList.singleWhere(
      (fl) => fl.flatNo == widget.flatNo,
    );

    final double agValue = (allInclusive - registration) /
        (((gstPercentage + stampDutyPercentage) / 100) + 1);

    final double formattedValue = agValue;
    double customRound(double value) {
      // Round to the nearest whole number based on the decimal part
      return (value - value.truncate() >= 0.5)
          ? value.ceilToDouble()
          : value.floorToDouble();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Details for Flat ${widget.flatNo}',
          style: TextStyle(fontSize: 20),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Color.fromARGB(255, 7, 7, 7),
            ),
            onSelected: (value) async {
              if (value == "Cost Sheet Generator") {
                _showProjectDialogForCostSheet();
              } else if (value == "Payment Schedule") {
                _showProjectDialogForPaymentSchedule();
              } else if (value == "Demand Letter") {
                _showProjectDialogForDemand();
              }

              setState(() {
                selectedGenerate = value;
              });
            },
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Cost Sheet Generator',
                child: Text('Cost Sheet Generator'),
              ),
              const PopupMenuItem<String>(
                value: 'Payment Schedule',
                child: Text('Payment Schedule'),
              ),
              const PopupMenuItem<String>(
                value: 'Demand Letter',
                child: Text('Demand Letter'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status: ${flat.occupied == true ? "Booked" : "Available"}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Floor: ${flat.floor}'),
            Text('Flat: ${widget.flatNo}'),
            Text('Type: ${flat.configuration} (${flat.type})'),
            Text('Usable Carpet Area: ${flat.carpetArea} sqft'),
            Text('Sellable Carpet Area: ${flat.sellableCarpetArea} sqft'),
            Text('All Inclusive Price: ${formatCurrency(allInclusive)}'),
            const SizedBox(height: 20),
            DropdownButtonFormField<double>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Offer Price',
              ),
              items: [
                DropdownMenuItem(
                  value: flat.msp1 ?? 0,
                  child: const Text("MSP1"),
                ),
                DropdownMenuItem(
                  value: flat.msp2 ?? 1,
                  child: const Text("MSP2"),
                ),
                DropdownMenuItem(
                  value: flat.msp3 ?? 2,
                  child: const Text("MSP3"),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: const Text("CUSTOM"),
                ),
              ],
              onChanged: (value) {
                if (value == 3) {
                  showPriceDialog();
                } else {
                  setState(() {
                    customValue = null;
                    allInclusive = value ?? 0;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            if (customValue != null) ...[
              Table(
                columnWidths: {
                  0: FlexColumnWidth(3), // Adjusts column widths
                  1: FlexColumnWidth(3),
                },
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Agreement Value:',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          formatCurrency(customRound(formattedValue)),
                          style: const TextStyle(fontSize: 16),
                          textAlign:
                              TextAlign.left, // Aligns the values to the right
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Stamp Duty:',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          formatCurrency(customRound(formattedValue * 0.06)),
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'GST 5%:',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          formatCurrency(customRound(formattedValue * 0.05)),
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Registration:',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          formatCurrency(customRound(registration)),
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Total (All Inclusive):',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          formatCurrency(customRound(allInclusive)),
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                "Note",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                "All inclusive price does not including, 1 lakh rupess of maintainance deposit and 30000 rupeess of legal charges.",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ],
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
