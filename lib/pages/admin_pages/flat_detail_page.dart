import 'package:ev_homes/core/models/our_project.dart';
import 'package:flutter/material.dart';

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
  String? msp;
  double allInclusive = 0;

  void showPriceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
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
              onChanged: (value) {
                setState(() {
                  allInclusive = double.parse(value);
                });
              },
              keyboardType: TextInputType.number,
            ),
          ],
        ),
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

  @override
  Widget build(BuildContext context) {
    final flat = widget.project.flatList.singleWhere(
      (fl) => fl.flatNo == widget.flatNo,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Details for Flat ${widget.flatNo}'),
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
            Text('All Inclusive Price: $allInclusive'),
            // Text('Name: ${flat.type}'),
            // const SizedBox(height: 20),
            // DropdownButtonFormField(
            //   value: status,
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(),
            //     labelText: 'Status',
            //   ),
            //   items: const [
            //     DropdownMenuItem(
            //       value: false,
            //       child: Text("Available"),
            //     ),
            //     DropdownMenuItem(
            //       value: true,
            //       child: Text("Booked"),
            //     ),
            //   ],
            //   onChanged: (value) {
            //     status = value!;
            //   },
            // ),
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
                    allInclusive = value ?? 0;
                    _priceController.text = value?.toString() ?? "";
                  });
                }
              },
            ),
            const Spacer(),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save or handle selections here.
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
