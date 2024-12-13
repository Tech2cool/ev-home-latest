import 'package:flutter/material.dart';

class FlatDetailPage extends StatelessWidget {
  final String flatNumber;
  final String bhk;
  final String area;

  const FlatDetailPage({
    Key? key,
    required this.flatNumber,
    required this.bhk,
    required this.area,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? status;
    String? msp;

    return Scaffold(
      appBar: AppBar(
        title: Text('Details for Flat $flatNumber'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Flat: $flatNumber',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('BHK: $bhk'),
            Text('Area: $area'),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Status',
              ),
              items: ['Booked', 'Sold']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) {
                status = value;
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Coating Price',
              ),
              items: ['MSP1', 'MSP2', 'MSP3']
                  .map((msp) => DropdownMenuItem(
                        value: msp,
                        child: Text(msp),
                      ))
                  .toList(),
              onChanged: (value) {
                msp = value;
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
