import 'package:ev_homes/components/loading/loading_generate_pdf.dart';
import 'package:ev_homes/components/loading/loading_square.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:ev_homes/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class DateFilterScreenSiteVisit extends StatefulWidget {
  final Function(DateTime? start, DateTime? end) onSelect;
  final Function() onSubmit;
  const DateFilterScreenSiteVisit(
      {super.key, required this.onSelect, required this.onSubmit});

  @override
  State<DateFilterScreenSiteVisit> createState() =>
      _DateFilterScreenSiteVisitState();
}

class _DateFilterScreenSiteVisitState extends State<DateFilterScreenSiteVisit> {
  String? selectedFilterType = 'day';
  int? selectedWeek;
  int? selectedMonth;
  DateTimeRange? selectedDateRange;
  bool isLoading = false;
  bool isGenerating = false;
  List<Lead> leads = [];
  Employee? selectedEmployee;
  OurProject? selectedProject;
  String? visitStatus;
  Employee? _selectedTeamLeader;

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

  void _onSubmit() async {
    DateTime? startDate;
    DateTime? endDate;

    if (selectedFilterType == 'week' && selectedWeek != null) {
      final weekRange = getDateRange(
        filterType: 'week',
        weekNumber: selectedWeek,
      );
      startDate = weekRange['startDate'];
      endDate = weekRange['endDate'];
    } else if (selectedFilterType == 'month' && selectedMonth != null) {
      final monthRange = getDateRange(
        filterType: 'month',
        monthNumber: selectedMonth,
      );
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
      // print('Start Date: ${DateFormat('yyyy-MM-dd').format(startDate)}');
      // print('End Date: ${DateFormat('yyyy-MM-dd').format(endDate)}');
      try {
        setState(() {
          isGenerating = true;
        });
        final resp = await ApiService().getLeadsForExport({
          "startDate": startDate.toIso8601String(),
          "endDate": endDate.toIso8601String(),
        });
        setState(() {
          leads = resp;
        });

        await saveCSVToDownloads(
          resp.map((ele) => ele.toExportJson()).toList(),
        );
        setState(() {
          isGenerating = false;
        });
      } catch (e) {
        //
      } finally {
        setState(() {
          isGenerating = false;
        });
      }
    }
    widget.onSubmit();
  }

  Future<void> saveCSVToDownloads(List<Map<String, dynamic>> data) async {
    try {
      // Check and request storage permission
      if (await Permission.storage.request().isGranted) {
        // Define headers and rows
        List<List<dynamic>> rows = [];
        if (data.isNotEmpty) {
          // Add headers
          rows.add(data.first.keys.toList());

          // Add data rows
          for (var row in data) {
            rows.add(row.values.toList());
          }
        }

        // Convert to CSV format
        String csv = const ListToCsvConverter().convert(rows);

        // Get the Downloads directory
        Directory? downloadsDirectory =
            Directory('/storage/emulated/0/Download');
        if (!downloadsDirectory.existsSync()) {
          downloadsDirectory = await getExternalStorageDirectory();
        }

        final path =
            "${downloadsDirectory!.path}/data_${DateTime.now().millisecondsSinceEpoch}.csv";

        // Write CSV to file
        final file = File(path);
        await file.writeAsString(csv);
        // Notify the user
        await showDownloadNotification(path);

        // Notify the user
        print("File saved at: $path");
        // For download manager notification
        if (Platform.isAndroid) {
          print("You can integrate DownloadManager notification if needed.");
        }
      } else {
        print("Permission not granted to write to storage.");
      }
    } catch (e) {
      print("Error saving CSV to Downloads: $e");
    }
  }

  Future<void> showDownloadNotification(String filePath) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      channelDescription: 'Notification for download completion',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      showProgress: true,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Complete',
      'Tap to open the file.',
      platformDetails,
      payload: filePath,
    );
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
        endDate = startDate.add(const Duration(days: 6));
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
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
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

  Future<void> onRefresh() async {
    try {
      final settingProvider = Provider.of<SettingProvider>(
        context,
        listen: false,
      );
      setState(() {
        isLoading = true;
      });
      await settingProvider.getClosingManagers();
      await settingProvider.getOurProject();
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

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text('Select Date Range')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedFilterType,
                  onChanged: _onFilterChanged,
                  items: [
                    const DropdownMenuItem(child: Text('Day'), value: 'day'),
                    const DropdownMenuItem(child: Text('Week'), value: 'week'),
                    const DropdownMenuItem(
                        child: Text('Month'), value: 'month'),
                    const DropdownMenuItem(
                        child: Text('Custom'), value: 'custom'),
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _onSubmit,
                  child: const Text('Submit'),
                ),
                if (leads.isNotEmpty) ...[
                  Text("Found Result ${leads.length}"),
                ],
              ],
            ),
          ),
        ),
        if (isGenerating) const LoadingGeneratePdf(),
        if (isLoading) const LoadingSquare(),
      ],
    );
  }
}
