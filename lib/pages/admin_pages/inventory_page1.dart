import 'package:flutter/material.dart';

class InventoryPage1 extends StatefulWidget {
  final Function(String) onButtonPressed;

  const InventoryPage1({required this.onButtonPressed});
  @override
  _InventoryPage1State createState() => _InventoryPage1State();
}

class _InventoryPage1State extends State<InventoryPage1> {
  String selectedView = 'Flat No';

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
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EV 10 Marina Bay'),
            Text(
              'Vashi',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          DropdownSection(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildButton('Area', Icons.square_foot),
              _buildButton('BHK', Icons.house),
              _buildButton('Flat No', Icons.location_city_outlined),
            ],
          ),
          Expanded(
            child: FloorContent(selectedView: selectedView),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegend(Colors.redAccent, 'Sold'),
              _buildLegend(Colors.greenAccent, 'Available'),
              _buildLegend(Colors.grey, 'Booked'),
            ],
          ),
          const SizedBox(height: 10),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     ElevatedButton.icon(
          //       onPressed: () {},
          //       icon: Icon(Icons.phone_in_talk, color: Colors.redAccent),
          //       label: const Text('Contact Us',
          //           style: TextStyle(color: Colors.black)),
          //       style: ElevatedButton.styleFrom(
          //         foregroundColor: Colors.black,
          //         backgroundColor: Colors.white,
          //         side: BorderSide(color: Colors.redAccent, width: 1),
          //       ),
          //     ),
          //     ElevatedButton(
          //       onPressed: () {},
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: Colors.redAccent,
          //       ),
          //       child: const Text('Book Site Visit',
          //           style: TextStyle(color: Colors.white)),
          //     ),
          //   ],
          // ),
        ],
      ),
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          labelText: 'Select Tower',
        ),
        items: const [
          DropdownMenuItem(
            value: 'EV 10 Marina Bay',
            child: Text('EV 10 Marina Bay'),
          ),
          DropdownMenuItem(
            value: 'EV 9 Square',
            child: Text('EV 9 Square'),
          ),
        ],
        onChanged: (value) {
          // Handle dropdown change
        },
      ),
    );
  }
}

class ButtonSection extends StatelessWidget {
  final Function(String) onButtonPressed;

  const ButtonSection({required this.onButtonPressed});

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

  FloorContent({required this.selectedView});

  @override
  Widget build(BuildContext context) {
    // Generate floors in reverse order: from 25 down to 5
    final floors = List.generate(21, (index) => 25 - index);

    return ListView.builder(
      itemCount: floors.length,
      itemBuilder: (context, index) {
        int floor = floors[index]; // Get floor number in reversed order

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 7.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Floor Label
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Container(
                  width: 80,
                  alignment: Alignment.center,
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
              // Flats - Horizontal Scroll
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(10, (itemIndex) {
                      String content = _generateContent(floor, itemIndex);
                      return Container(
                        width: 70, // Width of each flat
                        height: 40, // Height of each flat
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          content,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _generateContent(int floor, int itemIndex) {
    switch (selectedView) {
      case 'Flat No':
        // Add "0" for all elements except the last one (itemIndex 9)
        if (itemIndex != 9) {
          return '${floor}0${itemIndex + 1}';
        } else {
          return '${floor}${itemIndex + 1}';
        }
      case 'BHK':
        return itemIndex % 2 == 0 ? '2BHK' : '3BHK';
      case 'Area':
        return '${971 + floor * 10} Sqft';
      default:
        return '';
    }
  }
}
