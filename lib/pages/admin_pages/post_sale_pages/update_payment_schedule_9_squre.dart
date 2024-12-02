import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class UpdatePayment9 extends StatefulWidget {
  const UpdatePayment9({Key? key}) : super(key: key);

  @override
  _UpdatePayment9State createState() => _UpdatePayment9State();
}

class _UpdatePayment9State extends State<UpdatePayment9> {
  String selectedSlab = '52';
  String? updatedSlab;
  List<Map<String, dynamic>> selectionHistory = [];

  final List<Map<String, String>> slabs = [
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
    {'value': '49', 'name': 'On Completion of electro, mechanical and environmental requirements'},
    {'value': '50', 'name': 'On completion of entrance lobby'},
    {'value': '51', 'name': 'On completion of plinth protection and paving'},
    {'value': '52', 'name': 'On Possession'},
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('selectionHistory_UpdatePayment9');
    if (historyJson != null) {
      setState(() {
        selectionHistory = List<Map<String, dynamic>>.from(json.decode(historyJson));
      });
    }
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = json.encode(selectionHistory);
    await prefs.setString('selectionHistory_UpdatePayment9', historyJson);
  }

  void _updateStatus() {
    setState(() {
      updatedSlab = slabs.firstWhere((slab) => slab['value'] == selectedSlab)['name'];
      selectionHistory.add({
        'slab': updatedSlab,
        'timestamp': DateTime.now().toIso8601String(),
      });
      _saveHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Payment Status'),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo, Colors.indigo.shade200],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
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
                            color: Colors.indigo,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
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
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _updateStatus,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
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
                              color: Colors.indigo.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.indigo),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Updated Slab:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
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
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
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
                          'Selection History',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
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
                                title: Text(item['slab'] as String),
                                subtitle: Text(
                                  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(item['timestamp'] as String)),
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.indigo,
                                  child: Text(
                                    '${selectionHistory.length - index}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
        prefixIcon: Icon(icon, color: Colors.indigo),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.indigo),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items,
      onChanged: onChanged,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.indigo),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      dropdownColor: Colors.white,
    );
  }
}