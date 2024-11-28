import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DigitalDateTimePicker extends StatefulWidget {
  final DateTime initialDateTime;
  final Function(DateTime) onDateTimeChanged;

  const DigitalDateTimePicker({
    Key? key,
    required this.initialDateTime,
    required this.onDateTimeChanged,
  }) : super(key: key);

  @override
  _DigitalDateTimePickerState createState() => _DigitalDateTimePickerState();
}

class _DigitalDateTimePickerState extends State<DigitalDateTimePicker> {
  late DateTime _selectedDateTime;
  bool _is24HourFormat = true;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.tealAccent,
              onPrimary: Colors.black,
              surface: Colors.grey[850]!,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[900],
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
      widget.onDateTimeChanged(_selectedDateTime);
    }
  }

  void _changeTime(int hours, int minutes) {
    setState(() {
      _selectedDateTime = _selectedDateTime.add(Duration(hours: hours, minutes: minutes));
    });
    widget.onDateTimeChanged(_selectedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[900]!, Colors.grey[850]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Date & Time',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Text(
                    '24h',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(width: 2),
                  Switch(
                    value: _is24HourFormat,
                    onChanged: (value) {
                      setState(() {
                        _is24HourFormat = value;
                      });
                    },
                    activeColor: Colors.tealAccent,
                    activeTrackColor: Colors.tealAccent.withOpacity(0.5),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _selectDate,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today, color: Colors.tealAccent),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM d, y').format(_selectedDateTime),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeColumn(
                value: _selectedDateTime.hour,
                onChanged: (int hour) => _changeTime(hour - _selectedDateTime.hour, 0),
                format: _is24HourFormat ? 'HH' : 'hh',
                itemCount: _is24HourFormat ? 24 : 12,
              ),
              const SizedBox(width: 16),
              const Text(
                ':',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent,
                ),
              ),
              const SizedBox(width: 16),
              _buildTimeColumn(
                value: _selectedDateTime.minute,
                onChanged: (int minute) => _changeTime(0, minute - _selectedDateTime.minute),
                format: 'mm',
                itemCount: 60,
              ),
              if (!_is24HourFormat) ...[
                const SizedBox(width: 16),
                _buildAmPmSelector(),
              ],
            ],
          ),
          const SizedBox(height: 24),
          Text(
            DateFormat(_is24HourFormat ? 'HH:mm' : 'hh:mm a').format(_selectedDateTime),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('MMMM d, y').format(_selectedDateTime),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => widget.onDateTimeChanged(_selectedDateTime),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeColumn({
    required int value,
    required Function(int) onChanged,
    required String format,
    required int itemCount,
  }) {
    return SizedBox(
      height: 180,
      width: 70,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 50,
        perspective: 0.005,
        diameterRatio: 1.2,
        physics: const FixedExtentScrollPhysics(),
        controller: FixedExtentScrollController(initialItem: value),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount,
          builder: (context, index) {
            return Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: value == index ? Colors.tealAccent.withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                DateFormat(format).format(
                  DateTime(2022, 1, 1, format == 'HH' || format == 'hh' ? index : 0, format == 'mm' ? index : 0),
                ),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: value == index ? FontWeight.bold : FontWeight.normal,
                  color: value == index ? Colors.tealAccent : Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAmPmSelector() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedDateTime.hour < 12) {
            _changeTime(12, 0);
          } else {
            _changeTime(-12, 0);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.tealAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          DateFormat('a').format(_selectedDateTime),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent,
          ),
        ),
      ),
    );
  }
}