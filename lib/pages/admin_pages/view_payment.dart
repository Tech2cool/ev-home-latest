import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewPayment extends StatefulWidget {
  const ViewPayment({super.key});

  @override
  State<ViewPayment> createState() => _ViewPaymentState();
}

class _ViewPaymentState extends State<ViewPayment> {
  @override
  void initState() {
    super.initState();
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    settingProvider.getPayment();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final payments = settingProvider.payment;

    return Stack(
      children: [
        const Positioned.fill(
          child: AnimatedGradientBg(),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text("Customer Details")),
          body: payments.isEmpty
              ? const Center(child: Text("No Payment Details"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final customer = payments[index];
                    return Card(
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.5),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Customer Details",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Table(
                                    columnWidths: const {0: FlexColumnWidth(1)},
                                    children: [
                                      _buildVerticalTableRow(
                                          "Project", customer.projects.name),
                                      _buildVerticalTableRow(
                                          "Flat No", customer.flatNo),
                                      _buildVerticalTableRow(
                                          "Carpet Area (sq.ft)",
                                          customer.carpetArea),
                                      _buildVerticalTableRow("Customer Name",
                                          customer.customerName),
                                      _buildVerticalTableRow("Phone Number",
                                          customer.phoneNumber.toString()),
                                      _buildVerticalTableRow(
                                          "Address Line 1", customer.address1!),
                                      _buildVerticalTableRow(
                                          "Address Line 2", customer.address2!),
                                      _buildVerticalTableRow(
                                          "City", customer.city!),
                                      _buildVerticalTableRow("Pincode",
                                          customer.pincode.toString()),
                                      _buildVerticalTableRow("Booking Amount",
                                          customer.bookingAmt.toString()),
                                      _buildVerticalTableRow("CGST/SGST",
                                          customer.cgst.toString()),
                                      _buildVerticalTableRow(
                                          "Total Amount Received",
                                          customer.amtReceived.toString()),
                                      _buildVerticalTableRow(
                                          "All Inclusive Amount",
                                          customer.allinclusiveamt.toString()),
                                      _buildVerticalTableRow(
                                          "TDS", customer.tds.toString()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  TableRow _buildVerticalTableRow(String heading, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(heading,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.0)),
              const SizedBox(height: 3.0),
              Text(value, style: const TextStyle(fontSize: 14.0)),
            ],
          ),
        ),
      ],
    );
  }
}
