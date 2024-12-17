import 'package:ev_homes/components/loading/loading_square.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/admin_pages/flat_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryPage1 extends StatefulWidget {
  final Function(String) onButtonPressed;

  const InventoryPage1({super.key, required this.onButtonPressed});
  @override
  State<InventoryPage1> createState() => _InventoryPage1State();
}

class _InventoryPage1State extends State<InventoryPage1> {
  String selectedView = 'Flat No';
  bool isLoading = false;
  OurProject? selectedTower;

  void onTower(OurProject? selectedValue) {
    setState(() {
      selectedTower = selectedValue;
    });
  }

  Future<void> _onRefresh() async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );

    try {
      setState(() {
        isLoading = true;
      });

      // Execute all three futures concurrently
      await Future.wait([
        settingProvider.getOurProject(),
      ]);
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
    _onRefresh();
  }

  Widget _buildButton(String buttonName, IconData icon) {
    bool isSelected = selectedView == buttonName;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedView = buttonName;
        });
        // onbuttonPres(buttonName);
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.white : Colors.transparent,
        side: BorderSide(
          color: isSelected ? Colors.blueAccent : Colors.grey,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          Text(
            buttonName,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(selectedTower?.name ?? ""),
                Text(
                  selectedTower?.locationName ?? "",
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: Column(
              children: [
                DropdownSection(
                  onTower: onTower,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildButton('Area', Icons.square_foot),
                    _buildButton('BHK', Icons.house),
                    _buildButton('Flat No', Icons.location_city_outlined),
                  ],
                ),
                Expanded(
                  child: FloorContent(
                    selectedView: selectedView,
                    selectedProject: selectedTower,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLegend(
                      const Color.fromARGB(255, 253, 127, 127),
                      'Sold',
                    ),
                    _buildLegend(
                      const Color(0xff03cf9e),
                      'Available',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        if (isLoading) const LoadingSquare(),
      ],
    );
  }
}

Widget _buildLegend(Color color, String text) {
  return Row(
    children: [
      Container(
        width: 15,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 8), // Spacing between circle and text
      Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

class DropdownSection extends StatelessWidget {
  final Function(OurProject?) onTower;
  const DropdownSection({
    super.key,
    required this.onTower,
  });

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<OurProject>(
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          labelText: 'Select Project',
        ),
        items: [
          ...settingProvider.ourProject.map(
            (ele) => DropdownMenuItem(
              value: ele,
              child: Text(ele.name ?? ""),
            ),
          )
        ],
        onChanged: onTower,
      ),
    );
  }
}

class ButtonSection extends StatelessWidget {
  final Function(String) onButtonPressed;

  const ButtonSection({super.key, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () => onButtonPressed('Area'),
            child: const Text('Area'),
          ),
          ElevatedButton(
            onPressed: () => onButtonPressed('BHK'),
            child: const Text('BHK'),
          ),
          ElevatedButton(
            onPressed: () => onButtonPressed('Flat No'),
            child: const Text('Flat No'),
          ),
        ],
      ),
    );
  }
}

class FloorContent extends StatelessWidget {
  final String selectedView;
  final OurProject? selectedProject;

  const FloorContent({
    super.key,
    required this.selectedView,
    this.selectedProject,
  });

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final whichProj = selectedProject == null
        ? null
        : settingProvider.ourProject.singleWhere(
            (pro) => pro == selectedProject,
          );
    final floors = whichProj?.flatList
            .map((flat) => flat.floor) // Get all floors
            .whereType<int>() // Ensure non-null and int type
            .toSet() // Remove duplicates
            .toList() ??
        []
      ..sort();
    final reversedFloors = floors.reversed.toList();

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.75, // Limit height
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed Floor Labels
            Column(
              children: List.generate(reversedFloors.length, (i) {
                int floor = reversedFloors[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11.0),
                  child: Container(
                    width: 80,
                    height: 40,
                    alignment: Alignment.center,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        ),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Floor $floor',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            // Scrollable Flats
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(reversedFloors.length, (i) {
                    int floor = reversedFloors[i];
                    final flats = (selectedProject?.flatList ?? [])
                        .where((flat) => flat.floor == floor)
                        .toList()
                      ..sort((a, b) => a.floor!.compareTo(b.floor!));

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(flats.length, (itemIndex) {
                          final flat = flats[itemIndex];
                          String content = _generateContent(flat, itemIndex);
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FlatDetailPage(
                                    project: selectedProject!,
                                    flat: flat,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 70,
                              height: 40,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: flat.occupied == true
                                    ? Colors.redAccent
                                    : const Color(0xff00cf9f),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                content,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _generateContent(Flat flat, int itemIndex) {
    switch (selectedView) {
      case 'Flat No':
        return '${flat.flatNo}';
      case 'BHK':
        return flat.configuration ?? "";
      case 'Area':
        return '${flat.carpetArea} Sqft';
      default:
        return '';
    }
  }
}
