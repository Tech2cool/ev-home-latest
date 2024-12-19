import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class EmiCalculator extends StatefulWidget {
  const EmiCalculator({super.key});

  @override
  _EmiCalculatorState createState() => _EmiCalculatorState();
}

class _EmiCalculatorState extends State<EmiCalculator>
    with SingleTickerProviderStateMixin {
  double _loanAmount = 0;
  double _interestRate = 0;
  double _tenureYears = 0;
  double _emi = 0;
  double _totalInterest = 0;

  late TextEditingController _loanAmountController;
  late TextEditingController _interestRateController;
  late TextEditingController _tenureController;

  String? _loanAmountError;
  String? _interestRateError;
  String? _tenureError;

  List<Map<String, double>> amortizationSchedule = [];

  final currencyFormat = NumberFormat("#,##0.00", "en_US");

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loanAmountController = TextEditingController();
    _interestRateController = TextEditingController();
    _tenureController = TextEditingController();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _tenureController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _calculateEMI() {
    FocusScope.of(context).unfocus();
    double principal = double.tryParse(_loanAmountController.text) ?? 0;
    double rate = double.tryParse(_interestRateController.text) ?? 0;
    double tenureYears = double.tryParse(_tenureController.text) ?? 0;

    setState(() {
      _loanAmountError = null;
      _interestRateError = null;
      _tenureError = null;
    });

    bool isValid = true;

    if (principal < 50000 || principal > 1000000000) {
      _loanAmountError = 'Enter an amount between ₹50,000 and ₹100,000,000';
      isValid = false;
    }
    if (rate < 7 || rate > 15) {
      _interestRateError = 'Enter a rate between 7% and 15%';
      isValid = false;
    }
    if (tenureYears < 1 || tenureYears > 35) {
      _tenureError = 'Enter a tenure between 1 and 35 years';
      isValid = false;
    }

    if (!isValid) return;

    double tenureMonths = tenureYears * 12;
    double monthlyInterestRate = rate / 12 / 100;
    _emi = (principal *
            monthlyInterestRate *
            pow(1 + monthlyInterestRate, tenureMonths)) /
        (pow(1 + monthlyInterestRate, tenureMonths) - 1);
    double totalAmount = _emi * tenureMonths;
    _totalInterest = totalAmount - principal;

    _buildAmortizationSchedule(principal, monthlyInterestRate, tenureMonths);

    setState(() {});
  }

  void _buildAmortizationSchedule(
      double principal, double monthlyInterestRate, double tenureMonths) {
    amortizationSchedule.clear();
    double remainingPrincipal = principal;

    for (int month = 1; month <= tenureMonths; month++) {
      double interest = remainingPrincipal * monthlyInterestRate;
      double principalPaid = _emi - interest;
      remainingPrincipal -= principalPaid;

      if (month % 12 == 0 || month == tenureMonths) {
        amortizationSchedule.add({
          'year': (month / 12).ceilToDouble(),
          'openingBalance': principal,
          'interest': interest,
          'principal': principalPaid,
          'closingBalance': remainingPrincipal > 0 ? remainingPrincipal : 0,
        });
      }

      principal -= principalPaid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 240, 246),
      appBar: AppBar(
        title:
            const Text('EMI Calculator', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF042630),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildInputCard(),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                    const SizedBox(height: 24),
                    _buildResultsCard(),
                    if (_emi > 0 && _totalInterest >= 0) ...[
                      const SizedBox(height: 24),
                      _buildYearlySummaryTable(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.real_estate_agent,
                size: 32, color: Color(0xFF042630)),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _animation.value,
                    child: const Text(
                      'The best way to predict your future is to create it',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005254),
                          fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputField(
              'Loan Amount (₹)',
              _loanAmountController,
              _loanAmount,
              (value) => setState(() => _loanAmount = value),
              _loanAmountError,
              Icons.money,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              'Interest Rate (%)',
              _interestRateController,
              _interestRate,
              (value) => setState(() => _interestRate = value),
              _interestRateError,
              Icons.percent,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              'Loan Tenure (Years)',
              _tenureController,
              _tenureYears,
              (value) => setState(() => _tenureYears = value),
              _tenureError,
              Icons.calendar_today,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    double value,
    ValueChanged<double> onChanged,
    String? errorText,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        prefixIcon: Icon(icon, color: Color(0xFF042630)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF042630), width: 2),
        ),
      ),
      onChanged: (text) {
        final newValue = double.tryParse(text) ?? 0;
        onChanged(newValue);
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: _calculateEMI,
          icon: const Icon(
            Icons.calculate,
            color: Color(0xFF042630),
          ),
          label: const Text(
            'Calculate EMI',
            style: TextStyle(
              color: Color(0xFF005254),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: _resetFields,
          icon: const Icon(
            Icons.refresh,
            color: Color(0xFF042630),
          ),
          label: const Text(
            'Reset',
            style: TextStyle(
              color: Color(0xFF005254),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Loan Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005254),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildPieChartWithLegend(),
            const SizedBox(height: 16),
            if (_emi > 0 && _totalInterest >= 0) ...[
              _buildResultItem(
                  'Monthly EMI', '₹${currencyFormat.format(_emi)}'),
              _buildResultItem('Total Interest',
                  '₹${currencyFormat.format(_totalInterest)}'),
              _buildResultItem('Total Payment',
                  '₹${currencyFormat.format(_emi * _tenureYears * 12)}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(value,
              style: const TextStyle(fontSize: 16, color: Color(0xFF042630))),
        ],
      ),
    );
  }

  Widget _buildPieChartWithLegend() {
    double principal = _emi * _tenureYears * 12 - _totalInterest;
    double totalAmount = principal + _totalInterest;
    double principalPercentage =
        totalAmount > 0 ? (principal / totalAmount) * 100 : 0;
    double interestPercentage =
        totalAmount > 0 ? (_totalInterest / totalAmount) * 100 : 0;

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: _buildPieChartSections(),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              startDegreeOffset: -90,
            ),
          ),
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLegendItem('Principal', const Color(0xFFCEA9BC),
                principalPercentage), // Coral color
            _buildLegendItem('Interest', const Color(0xFF042630),
                interestPercentage), // Teal color
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, double percentage) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ${percentage.toStringAsFixed(1)}%',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    if (_emi == 0 && _totalInterest == 0) {
      return [
        PieChartSectionData(
          color: Colors.white,
          value: 100,
          title: '',
          radius: 80,
          titleStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
      ];
    }

    double principal = _emi * _tenureYears * 12 - _totalInterest;
    return [
  PieChartSectionData(
    color: const Color(0xFFCEA9BC),
    value: principal,
    title: '',
    radius: 80,
  ),
  PieChartSectionData(
    color: Colors.transparent, // Set transparent as base color
    value: _totalInterest,
    title: '',
    radius: 80,
    gradient: const LinearGradient(
      colors: [
        Color(0xFF005254),
        Color(0xFF042630),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
];
  }

  Widget _buildYearlySummaryTable() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Yearly Summary',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF042630)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    WidgetStateProperty.all(Colors.purple.shade100),
                dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.08);
                    }
                    return null;
                  },
                ),
                columns: [
                  DataColumn(label: _buildColumnHeader('Year')),
                  DataColumn(label: _buildColumnHeader('Opening\nBalance')),
                  DataColumn(label: _buildColumnHeader('Interest')),
                  DataColumn(label: _buildColumnHeader('Principal')),
                  DataColumn(label: _buildColumnHeader('Closing\nBalance')),
                ],
                rows: amortizationSchedule.map((row) {
                  return DataRow(cells: [
                    DataCell(_buildCellText(row['year']!.toStringAsFixed(0))),
                    DataCell(_buildCellText(
                        '₹${currencyFormat.format(row['openingBalance'])}')),
                    DataCell(_buildCellText(
                        '₹${currencyFormat.format(row['interest'])}')),
                    DataCell(_buildCellText(
                        '₹${currencyFormat.format(row['principal'])}')),
                    DataCell(_buildCellText(
                        '₹${currencyFormat.format(row['closingBalance'])}')),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Color(0xFF042630)),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCellText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black87),
        textAlign: TextAlign.right,
      ),
    );
  }

  void _resetFields() {
    _loanAmountController.clear();
    _interestRateController.clear();
    _tenureController.clear();
    setState(() {
      _emi = 0;
      _totalInterest = 0;
      amortizationSchedule.clear();
    });
  }
}
