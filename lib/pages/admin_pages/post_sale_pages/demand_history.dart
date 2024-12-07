import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ev_homes/components/animated_gradient_bg.dart';

class Demand {
  final String slab;
  final String flatno;
  final String demandpaidDate;
  final double amount;
  final String reminder;
  final String clientName;
  final String projectName;
  // final String type;
  Demand({
    required this.slab,
    required this.flatno,
    required this.demandpaidDate,
    required this.amount,
    required this.reminder,
    required this.clientName,
    required this.projectName,
    // required this.type,
  });
}

class DemandHistoryPage extends StatefulWidget {
  const DemandHistoryPage({super.key});

  @override
  State<DemandHistoryPage> createState() => _DemandHistoryPageState();
}

class _DemandHistoryPageState extends State<DemandHistoryPage> {
  bool isLoading = false;
  String searchQuery = '';
  List<Demand> demands = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    setState(() {
      isLoading = true;
    });
    // Simulate network delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        demands = List.generate(
            20,
            (index) => Demand(
                  demandpaidDate:
                      '2023-${(index % 12 + 1).toString().padLeft(2, '0')}-${(index % 28 + 1).toString().padLeft(2, '0')}',
                  // amount: (index + 1) * 100.0,
                  amount: 74857,
                  clientName: 'Client ${index + 1}',
                  projectName: '9square', slab: '34', flatno: '1203',
                  reminder: 'I',
                ));
        isLoading = false;
      });
    });
  }

  List<Demand> getFilteredDemands() {
    if (searchQuery.isEmpty) {
      return demands;
    }
    return demands
        .where((demand) =>
            demand.flatno.toLowerCase().contains(searchQuery.toLowerCase()) ||
            demand.clientName
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            demand.projectName
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredDemands = getFilteredDemands();

    return Stack(
      children: [
        const Positioned.fill(
          child: AnimatedGradientBg(),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text("Demand History"),
          ),
          body: Column(
            children: [
              const SizedBox(height: 6),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                child: TextField(
                  onChanged: (query) {
                    if (_debounce?.isActive ?? false) _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      setState(() {
                        searchQuery = query;
                      });
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search Demand',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredDemands.length,
                  itemBuilder: (context, i) {
                    final demand = filteredDemands[i];
                    return _buildDemandCard(context, demand);
                  },
                ),
              ),
            ],
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.2),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}

Widget _buildDemandCard(BuildContext context, Demand demand) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    child: GestureDetector(
      onTap: () {
        // Navigate to demand details page (to be implemented)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Demand details for ${demand.flatno}')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              demand.clientName,
              style: TextStyle(
                fontSize: 12,
                color: _getStatusColor(demand.clientName),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NamedCard(
                        heading: "Demand slab",
                        value: demand.slab,
                      ),
                      const SizedBox(height: 5),
                      NamedCard(
                          heading: "demand paid Date",
                          value: demand.demandpaidDate),
                      const SizedBox(height: 5),
                      NamedCard(
                        heading: "reminder",
                        value: "${demand.amount} ${demand.reminder}",
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NamedCard(
                        heading: "Client Name",
                        value: demand.clientName,
                      ),
                      const SizedBox(height: 5),
                      NamedCard(
                        heading: "Project",
                        value: demand.projectName,
                      ),
                      const SizedBox(height: 5),
                      NamedCard(
                        heading: "flat no",
                        value: demand.flatno,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'approved':
      return Colors.green;
    case 'rejected':
      return Colors.red;
    case 'pending':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}

class NamedCard extends StatelessWidget {
  final String heading;
  final String value;
  final double? headingSize;
  final double? valueSize;

  const NamedCard({
    super.key,
    required this.heading,
    required this.value,
    this.headingSize,
    this.valueSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            heading,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: headingSize ?? 11,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value.length > 18 ? "${value.substring(0, 15)}..." : value,
            style: TextStyle(
              color: Colors.black,
              fontSize: valueSize ?? 12,
            ),
          ),
        ),
      ],
    );
  }
}
