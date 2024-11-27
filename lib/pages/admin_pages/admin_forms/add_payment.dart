import 'package:ev_homes/core/models/customer_payment.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({super.key});

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _carpetAreaController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _allinclusiveamountController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _receiveDateController = TextEditingController();
  final TextEditingController _receiptNoController = TextEditingController();
  final TextEditingController _transactionIdController =
      TextEditingController();
  final TextEditingController _chequeNumberController = TextEditingController();
  final TextEditingController _flatNoController = TextEditingController();
  final TextEditingController _amountReceivedController =
      TextEditingController();
  final TextEditingController _bookingAmountController =
      TextEditingController();
  final TextEditingController _stampDutyController = TextEditingController();
  final TextEditingController _tdsController = TextEditingController();
  final TextEditingController _cgstController = TextEditingController();
  bool isLoading = false;

  String? _selectedAccount;
  String? _selectedPaymentMode;
  OurProject? _selectedProject;
  bool _showTransactionIdField = false;
  bool _showChequeNumberField = false;

  final List<Payment> _payment = [];

  void _handleSubmit() async {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);

    final newPayment = Payment(
      projects: _selectedProject!, // Ensure this is not null
      customerName: _customerNameController.text,
      phoneNumber: int.tryParse(_phoneNumberController.text) ?? 0,
      dateOfAmtReceive: _receiveDateController.text,
      receiptNo: _receiptNoController.text,
      account: _selectedAccount ?? '',
      flatNo: _flatNoController.text,
      carpetArea: _carpetAreaController.text,
      address1: _address1Controller.text,
      address2: _address2Controller.text,
      city: _cityController.text,
      pincode: int.tryParse(_pincodeController.text) ?? 0,
      amtReceived:
          int.tryParse(_amountReceivedController.text.replaceAll(',', '')) ?? 0,
      allinclusiveamt: int.tryParse(
              _allinclusiveamountController.text.replaceAll(',', '')) ??
          0,
      paymentMode: _selectedPaymentMode ?? '',
      transactionId: _transactionIdController.text,
      bookingAmt:
          int.tryParse(_bookingAmountController.text.replaceAll(',', '')) ?? 0,
      stampDuty: int.tryParse(_stampDutyController.text) ?? 0,
      tds: int.tryParse(_tdsController.text) ?? 0,
      cgst: int.tryParse(_cgstController.text) ?? 0,
    );

    Map<String, dynamic> payment = newPayment.toMap();

    if (_selectedProject != null) {
      payment["projects"] = _selectedProject!.id;
    }

    try {
      await settingProvider.addPayment(payment);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment details added successfully!')),
      );

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const ViewPayment(payment: []),
      //   ),
      // );
    } catch (e) {
      // print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add payment: $e')),
      );
    }
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
        settingProvider.getPayment(),
      ]);
    } catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final projects = settingProvider.ourProject;
    return Scaffold(
      appBar: AppBar(title: const Text("Add Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<OurProject>(
                  value: projects.contains(_selectedProject)
                      ? _selectedProject
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Select Project',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  items: projects.map((project) {
                    return DropdownMenuItem<OurProject>(
                      value: project,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              project.name,
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
                      _selectedProject = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a Project';
                    }
                    return null;
                  },
                  isExpanded: true,
                ),
                CustomTextField(
                  controller: _customerNameController,
                  labelText: 'Customer Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Customer Name is required';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _phoneNumberController,
                  labelText: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone Number is required';
                    }
                    if (value.length != 10) {
                      return 'Enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _receiveDateController,
                  labelText: 'Amount Receive Date',
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      _receiveDateController.text =
                          pickedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Receive Date is required';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _receiptNoController,
                  labelText: 'Receipt No',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Receipt No is required';
                    }
                    return null;
                  },
                ),
                CustomDropdown(
                  labelText: 'Account',
                  value: _selectedAccount,
                  items: const ['ICICI-22186', 'ICICI-22390'],
                  onChanged: (value) {
                    setState(() {
                      _selectedAccount = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Account is required';
                    }
                    return null;
                  },
                ),
                CustomDropdown(
                  labelText: 'Payment Mode',
                  value: _selectedPaymentMode,
                  items: const ['Online', 'Cheque'],
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMode = value;
                      _showTransactionIdField = value == 'Online';
                      _showChequeNumberField = value == 'Cheque';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Payment Mode is required';
                    }
                    return null;
                  },
                ),
                if (_showTransactionIdField)
                  CustomTextField(
                    controller: _transactionIdController,
                    labelText: 'Transaction ID',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Transaction ID is required';
                      }
                      return null;
                    },
                  ),
                if (_showChequeNumberField)
                  CustomTextField(
                    controller: _chequeNumberController,
                    labelText: 'Cheque Number',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cheque Number is required';
                      }
                      return null;
                    },
                  ),
                CustomTextField(
                  controller: _flatNoController,
                  labelText: 'Flat No',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Flat No is required';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _carpetAreaController,
                  labelText: 'Carpet Area (sq.ft)',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Carpet Area is required';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _address1Controller,
                  labelText: 'Address Line 1',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Address Line 1 is required';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _address2Controller,
                  labelText: 'Address Line 2',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Address Line 2 is required';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _cityController,
                        labelText: 'City',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'City is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: CustomTextField(
                        controller: _pincodeController,
                        labelText: 'Pincode',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pincode is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                CustomTextField(
                  controller: _amountReceivedController,
                  labelText: 'Total Amount Received',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final input = newValue.text.replaceAll(',', '');
                      if (input.isEmpty) return newValue;

                      final formattedInput =
                          NumberFormat('#,###').format(int.parse(input));

                      // Calculate the new cursor position
                      int cursorPosition = formattedInput.length -
                          (input.length - newValue.selection.baseOffset);

                      // Ensure the cursor position is within bounds
                      cursorPosition =
                          cursorPosition.clamp(0, formattedInput.length);

                      return TextEditingValue(
                        text: formattedInput,
                        selection:
                            TextSelection.collapsed(offset: cursorPosition),
                      );
                    }),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Total Amount Received is required';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _allinclusiveamountController,
                  labelText: 'All Inclusive Amount',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final input = newValue.text.replaceAll(',', '');
                      if (input.isEmpty) return newValue;

                      final formattedInput =
                          NumberFormat('#,###').format(int.parse(input));

                      // Calculate the new cursor position
                      int cursorPosition = formattedInput.length -
                          (input.length - newValue.selection.baseOffset);

                      // Ensure the cursor position is within bounds
                      cursorPosition =
                          cursorPosition.clamp(0, formattedInput.length);

                      return TextEditingValue(
                        text: formattedInput,
                        selection:
                            TextSelection.collapsed(offset: cursorPosition),
                      );
                    }),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'All inclusive amount is required';
                    }
                    return null;
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Payment Options",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                CustomTextField(
                  controller: _bookingAmountController,
                  labelText: 'Booking Amount',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final input = newValue.text.replaceAll(',', '');
                      if (input.isEmpty) return newValue;

                      final formattedInput =
                          NumberFormat('#,###').format(int.parse(input));

                      // Calculate the new cursor position
                      int cursorPosition = formattedInput.length -
                          (input.length - newValue.selection.baseOffset);

                      // Ensure the cursor position is within bounds
                      cursorPosition =
                          cursorPosition.clamp(0, formattedInput.length);

                      return TextEditingValue(
                        text: formattedInput,
                        selection:
                            TextSelection.collapsed(offset: cursorPosition),
                      );
                    }),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Booking Amount is required';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _stampDutyController,
                  labelText: 'Stamp Duty/Registration',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final input = newValue.text.replaceAll(',', '');
                      if (input.isEmpty) return newValue;

                      final formattedInput =
                          NumberFormat('#,###').format(int.parse(input));

                      // Calculate the new cursor position
                      int cursorPosition = formattedInput.length -
                          (input.length - newValue.selection.baseOffset);

                      // Ensure the cursor position is within bounds
                      cursorPosition =
                          cursorPosition.clamp(0, formattedInput.length);

                      return TextEditingValue(
                        text: formattedInput,
                        selection:
                            TextSelection.collapsed(offset: cursorPosition),
                      );
                    }),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Stamp Duty/Registration is required';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _tdsController,
                  labelText: 'TDS',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final input = newValue.text.replaceAll(',', '');
                      if (input.isEmpty) return newValue;

                      final formattedInput =
                          NumberFormat('#,###').format(int.parse(input));

                      // Calculate the new cursor position
                      int cursorPosition = formattedInput.length -
                          (input.length - newValue.selection.baseOffset);

                      // Ensure the cursor position is within bounds
                      cursorPosition =
                          cursorPosition.clamp(0, formattedInput.length);

                      return TextEditingValue(
                        text: formattedInput,
                        selection:
                            TextSelection.collapsed(offset: cursorPosition),
                      );
                    }),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'TDS is required';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _cgstController,
                  labelText: 'CGST/SGST',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final input = newValue.text.replaceAll(',', '');
                      if (input.isEmpty) return newValue;

                      final formattedInput =
                          NumberFormat('#,###').format(int.parse(input));

                      // Calculate the new cursor position
                      int cursorPosition = formattedInput.length -
                          (input.length - newValue.selection.baseOffset);

                      // Ensure the cursor position is within bounds
                      cursorPosition =
                          cursorPosition.clamp(0, formattedInput.length);

                      return TextEditingValue(
                        text: formattedInput,
                        selection:
                            TextSelection.collapsed(offset: cursorPosition),
                      );
                    }),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'CGST/SGST is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
        validator: validator,
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String labelText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const CustomDropdown({
    Key? key,
    required this.labelText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FormField<String>(
        validator: validator,
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: labelText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              errorText: state.errorText,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                onChanged: (newValue) {
                  state.didChange(newValue);
                  onChanged(newValue);
                },
                items: items
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
