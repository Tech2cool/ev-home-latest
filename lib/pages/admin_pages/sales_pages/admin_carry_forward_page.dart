import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminCarryForwardPage extends StatefulWidget {
  final String? id;
  const AdminCarryForwardPage({super.key, this.id});

  @override
  State<AdminCarryForwardPage> createState() => _AdminCarryForwardPageState();
}

class _AdminCarryForwardPageState extends State<AdminCarryForwardPage> {
  int? selectedVal;
  bool isLoading = false;

  Future<void> onRefresh() async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    try {
      setState(() {
        isLoading = true;
      });
      await settingProvider.getCarryForwardOpt(
        widget.id ?? settingProvider.loggedAdmin!.id!,
      );
    } catch (e) {
      //
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
    final settingProvider = Provider.of<SettingProvider>(context);
    final carryForwards = settingProvider.carryForwardsOptions;
    return Scaffold(
      appBar: AppBar(
        title: Text("Carry Forward Option"),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButtonFormField<int>(
                value: carryForwards.contains(selectedVal) ? selectedVal : null,
                decoration: InputDecoration(
                  labelText: 'Select Carry Forward opt',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                items: carryForwards.map((project) {
                  return DropdownMenuItem<int>(
                    value: project,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            project.toString(),
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
                    // updateCombinedText();
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a Unit No';
                  }
                  return null;
                },
                isExpanded: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Submit"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
