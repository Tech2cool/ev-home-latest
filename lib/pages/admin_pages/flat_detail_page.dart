import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/costsheet_generator_marina_bay.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

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

  @override
  Widget build(BuildContext context) {
    final flat = widget.project.flatList.singleWhere(
      (fl) => fl.flatNo == widget.flatNo,
    );

    final double agValue = (allInclusive - registration) /
        (((gstPercentage + stampDutyPercentage) / 100) + 1);

    final double formattedValue = agValue;

    return Scaffold(
      appBar: AppBar(
        title: Text('Details for Flat ${widget.flatNo}'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Cost Sheet Generator') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CostGenerator(),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'NextPage',
                  child: Text('Go to Next Page'),
                ),
              ];
            },
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
              Text(
                'Agreement Value: ${formatCurrency(formattedValue)}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<double>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Stamp Duty',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 5,
                    child: Text("5%"),
                  ),
                  DropdownMenuItem(
                    value: 6,
                    child: Text("6%"),
                  ),
                ],
                value: stampDutyPercentage,
                onChanged: (value) {
                  setState(() {
                    stampDutyPercentage = value ?? 6;
                  });
                },
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              Text(
                'Stamp Duty: ${formatCurrency(formattedValue * 0.06)}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'GST 5%: ${formatCurrency(formattedValue * 0.05)}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Registration: ${formatCurrency(registration)}',
                style: const TextStyle(
                  fontSize: 16,
                ),
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
