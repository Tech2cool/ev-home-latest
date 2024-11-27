import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UpdateStatus10 extends StatefulWidget {
  const UpdateStatus10({super.key});

  @override
  _UpdateStatus10State createState() => _UpdateStatus10State();
}

class _UpdateStatus10State extends State<UpdateStatus10> {
  String? selectedSlab;
  String? selectedPercentage;
  String? updatedSlab;
  double totalPercentage = 0;
  List<Map<String, dynamic>> selectionHistory = [];

  final List<Map<String, dynamic>> slabs = [
    {'value': '1', 'name': 'On Booking', 'percentage': 9.5},
    {'value': '2', 'name': 'On Registration', 'percentage': 15.5},
    {'value': '3', 'name': 'Commencement of Work', 'percentage': 10.0},
    {'value': '4', 'name': 'On Completion of Foundation upto Plinth Level', 'percentage': 5.0},
    {'value': '5', 'name': 'On Commencement of 1st Slab', 'percentage': 2.0},
    {'value': '6', 'name': 'On Commencement of 2nd Slab', 'percentage': 2.0},
    {'value': '7', 'name': 'On Commencement of 3rd Slab', 'percentage': 2.0},
    {'value': '8', 'name': 'On Commencement of 4th Slab', 'percentage': 2.0},
    {'value': '9', 'name': 'On Commencement of 5th Slab', 'percentage': 2.0},
    {'value': '10', 'name': 'On Commencement of 6th Slab', 'percentage': 2.0},
    {'value': '11', 'name': 'On Commencement of 7th Slab', 'percentage': 2.0},
    {'value': '12', 'name': 'On Commencement of 8th Slab', 'percentage': 2.0},
    {'value': '13', 'name': 'On Commencement of 9th Slab', 'percentage': 2.0},
    {'value': '14', 'name': 'On Commencement of 10th Slab', 'percentage': 2.0},
    {'value': '15', 'name': 'On Commencement of 11th Slab', 'percentage': 2.0},
    {'value': '16', 'name': 'On Commencement of 12th Slab', 'percentage': 2.0},
    {'value': '17', 'name': 'On Commencement of 13th Slab', 'percentage': 2.0},
    {'value': '18', 'name': 'On Commencement of 14th Slab', 'percentage': 2.0},
    {'value': '19', 'name': 'On Commencement of 15th Slab', 'percentage': 2.0},
    {'value': '20', 'name': 'On Commencement of 16th Slab', 'percentage': 2.0},
    {'value': '21', 'name': 'On Commencement of 17th Slab', 'percentage': 2.0},
    {'value': '22', 'name': 'On Commencement of 18th Slab', 'percentage': 2.0},
    {'value': '23', 'name': 'On Commencement of 19th Slab', 'percentage': 2.0},
    {'value': '24', 'name': 'On Commencement of 20th Slab', 'percentage': 2.0},
    {'value': '25', 'name': 'On Commencement of 21st Slab', 'percentage': 2.0},
    {'value': '26', 'name': 'On Commencement of 22nd Slab', 'percentage': 2.0},
    {'value': '27', 'name': 'On Commencement of 23rd Slab', 'percentage': 2.0},
    {'value': '28', 'name': 'On Commencement of 24th Slab', 'percentage': 2.0},
    {'value': '29', 'name': 'On Commencement of 25th Slab', 'percentage': 2.0},
    {'value': '30', 'name': 'On Commencement of 26th Slab', 'percentage': 2.0},
    {'value': '31', 'name': 'On Commencement of Plumbing of Building', 'percentage': 2.0},
    {'value': '32', 'name': 'On Commencement of Flooring & Tiling', 'percentage': 2.0},
    {'value': '33', 'name': 'On Commencement of External Painting', 'percentage': 2.0},
    {'value': '34', 'name': 'On Possession', 'percentage': 2.0},
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? historyJson = prefs.getString('selectionHistory_UpdateStatus10');
    if (historyJson != null) {
      setState(() {
        selectionHistory = List<Map<String, dynamic>>.from(json.decode(historyJson));
      });
    }
  }

  void _saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String historyJson = json.encode(selectionHistory);
    await prefs.setString('selectionHistory_UpdateStatus10', historyJson);
  }

  void _updateStatus() {
    if (selectedSlab != null) {
      setState(() {
        updatedSlab = slabs.firstWhere((slab) => slab['value'] == selectedSlab)['name'];
        int selectedIndex = int.parse(selectedSlab!) - 1;
        totalPercentage = 0;
        for (int i = 0; i <= selectedIndex; i++) {
          totalPercentage += slabs[i]['percentage'] as double;
        }

        // Add only the selected slab to history
        selectionHistory.add({
          'slab': updatedSlab,
          'percentage': slabs[selectedIndex]['percentage'],
          'timestamp': DateTime.now().toIso8601String(),
        });

        _saveHistory(); // Save history after updating
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Payment Status'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.lightBlueAccent],
          ),
        ),
        child: SafeArea(
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
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildDropdownField(
                            value: selectedSlab,
                            label: 'Select Slab',
                            icon: Icons.layers,
                            items: slabs.map((Map<String, dynamic> slab) {
                              return DropdownMenuItem<String>(
                                value: slab['value'],
                                child: Text(slab['name']!),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedSlab = newValue;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue),
                            ),
                            child: Text(
                              '${selectedSlab != null ? slabs[int.parse(selectedSlab!) - 1]['percentage'].toString() : '0'}%',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: selectedSlab == null ? null : _updateStatus,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Update Status',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    if (updatedSlab != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Updated Slab:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              updatedSlab!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Total Percentage:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${totalPercentage.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    const Text(
                      'Selection History',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: selectionHistory.length,
                      itemBuilder: (context, index) {
                        final item = selectionHistory[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(item['slab']),
                            subtitle: Text('Percentage: ${item['percentage']}%'),
                            trailing: Text(
                              DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(item['timestamp'])),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
        filled: true,
        fillColor: Colors.white,
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