import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFilterScreen extends StatefulWidget {
  final Function(DateTime? start, DateTime? end) onSelect;
  final Function() onSubmit;
  const DateFilterScreen(
      {super.key, required this.onSelect, required this.onSubmit});

  @override
  State<DateFilterScreen> createState() => _DateFilterScreenState();
}

class _DateFilterScreenState extends State<DateFilterScreen> {
  String? selectedFilterType = 'day';
  int? selectedWeek;
  int? selectedMonth;
  DateTimeRange? selectedDateRange;

  List<String> weekOptions = List.generate(53, (index) => 'Week ${index + 1}');
  List<String> monthOptions = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  void _onFilterChanged(String? value) {
    setState(() {
      selectedFilterType = value;
    });
  }

  void _onSubmit() {
    DateTime? startDate;
    DateTime? endDate;

    if (selectedFilterType == 'week' && selectedWeek != null) {
      final weekRange =
          getDateRange(filterType: 'week', weekNumber: selectedWeek);
      startDate = weekRange['startDate'];
      endDate = weekRange['endDate'];
    } else if (selectedFilterType == 'month' && selectedMonth != null) {
      final monthRange =
          getDateRange(filterType: 'month', monthNumber: selectedMonth);
      startDate = monthRange['startDate'];
      endDate = monthRange['endDate'];
    } else if (selectedFilterType == 'custom' && selectedDateRange != null) {
      startDate = selectedDateRange!.start;
      endDate = selectedDateRange!.end;
    } else if (selectedFilterType == 'day') {
      final dayRange = getDateRange(filterType: 'day');
      startDate = dayRange['startDate'];
      endDate = dayRange['endDate'];
    }

    if (startDate != null && endDate != null) {
      print('Start Date: ${DateFormat('yyyy-MM-dd').format(startDate)}');
      print('End Date: ${DateFormat('yyyy-MM-dd').format(endDate)}');
    }
    widget!.onSubmit!();
  }

  Map<String, DateTime> getDateRange({
    required String filterType,
    int? weekNumber,
    int? monthNumber,
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) {
    final now = DateTime.now();
    DateTime startDate, endDate;

    switch (filterType) {
      case 'day':
        startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        widget.onSelect(startDate, endDate);

        break;

      case 'week':
        if (weekNumber == null) {
          throw ArgumentError("Week number is required for 'week' filter.");
        }
        final firstDayOfYear = DateTime(now.year, 1, 1);
        final daysOffset = (weekNumber - 1) * 7;
        startDate = firstDayOfYear
            .add(Duration(days: daysOffset - firstDayOfYear.weekday + 1));
        endDate = startDate.add(Duration(days: 6));
        widget.onSelect(startDate, endDate);

        break;

      case 'month':
        if (monthNumber == null) {
          throw ArgumentError("Month number is required for 'month' filter.");
        }
        startDate = DateTime(now.year, monthNumber, 1);
        endDate = DateTime(now.year, monthNumber + 1, 0, 23, 59, 59);
        widget.onSelect(startDate, endDate);

        break;

      case 'custom':
        if (customStartDate == null || customEndDate == null) {
          throw ArgumentError(
              "Start and end dates are required for 'custom' filter.");
        }
        startDate = customStartDate;
        endDate = customEndDate;
        widget.onSelect(startDate, endDate);
        break;

      default:
        throw ArgumentError("Invalid filter type: $filterType");
    }

    return {'startDate': startDate, 'endDate': endDate};
  }

  Future<void> _selectCustomDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Date Range')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedFilterType,
              onChanged: _onFilterChanged,
              items: [
                DropdownMenuItem(child: Text('Day'), value: 'day'),
                DropdownMenuItem(child: Text('Week'), value: 'week'),
                DropdownMenuItem(child: Text('Month'), value: 'month'),
                DropdownMenuItem(child: Text('Custom'), value: 'custom'),
              ],
            ),
            if (selectedFilterType == 'week')
              DropdownButtonFormField<int>(
                value: selectedWeek,
                onChanged: (value) {
                  setState(() {
                    selectedWeek = value;
                  });
                },
                items: weekOptions
                    .map((week) => DropdownMenuItem<int>(
                          value: int.parse(week.split(' ')[1]),
                          child: Text(week),
                        ))
                    .toList(),
              ),
            if (selectedFilterType == 'month')
              DropdownButtonFormField<int>(
                value: selectedMonth,
                onChanged: (value) {
                  setState(() {
                    selectedMonth = value;
                  });
                },
                items: monthOptions
                    .asMap()
                    .map((index, month) => MapEntry(
                          index,
                          DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text(month),
                          ),
                        ))
                    .values
                    .toList(),
              ),
            if (selectedFilterType == 'custom')
              ElevatedButton(
                onPressed: () => _selectCustomDateRange(context),
                child: Text(
                  selectedDateRange == null
                      ? 'Select Date Range'
                      : 'Selected: ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)} - ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)}',
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onSubmit,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
