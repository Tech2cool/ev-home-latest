import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Future<void> onRefresh() async {
    try {
      final settingProvider = Provider.of<SettingProvider>(
        context,
        listen: false,
      );
      setState(() {
        isLoading = true;
      });
      // Mocked delay to simulate async operation
      await settingProvider.getCarryForwardOpt(
        widget.id ?? settingProvider.loggedAdmin!.id!,
      );
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      // Handle exceptions
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateCarry() async {
    try {
      final settingProvider = Provider.of<SettingProvider>(
        context,
        listen: false,
      );

      final resp = await settingProvider.updateCarryForward(
        widget.id ?? settingProvider.loggedAdmin!.id!,
        {
          "carryForward": selectedVal,
        },
      );
    } catch (e) {
      //
    } finally {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    final carryForwards = settingProvider.carryForwardsOptions;

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
                onPressed: updateCarry,
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
