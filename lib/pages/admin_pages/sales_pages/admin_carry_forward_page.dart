import 'package:flutter/material.dart';

class AdminCarryForwardDialog extends StatefulWidget {
  final String? id;
  const AdminCarryForwardDialog({super.key, this.id});

  @override
  State<AdminCarryForwardDialog> createState() =>
      _AdminCarryForwardDialogState();
}

class _AdminCarryForwardDialogState extends State<AdminCarryForwardDialog> {
  int? selectedVal;
  bool isLoading = false;
  List<int> carryForwards = [1, 2, 3, 4]; // Mocked options for demonstration

  Future<void> onRefresh() async {
    try {
      setState(() {
        isLoading = true;
      });
      // Mocked delay to simulate async operation
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      // Handle exceptions
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Carry Forward Option",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: carryForwards.contains(selectedVal) ? selectedVal : null,
                decoration: InputDecoration(
                  labelText: 'Select Carry Forward Option',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: carryForwards.map((project) {
                  return DropdownMenuItem<int>(
                    value: project,
                    child: Text(
                      project.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedVal = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a value';
                  }
                  return null;
                },
                isExpanded: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, selectedVal);
                },
                child: const Text("Submit"),
              ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
