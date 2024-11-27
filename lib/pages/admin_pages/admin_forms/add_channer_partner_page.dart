import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddChannerPartnerPage extends StatefulWidget {
  const AddChannerPartnerPage({super.key});

  @override
  State<AddChannerPartnerPage> createState() => _AddChannerPartnerPageState();
}

class _AddChannerPartnerPageState extends State<AddChannerPartnerPage> {
  final bool _showFirmDetails = false;
  bool _showPersonalDetails = false;
  bool _sameAddress = false;
  bool _haveReraNumber = false;
  bool _showPassword = false;

  String? _selectedGender;
  DateTime? _selectedDate;

  // Text controllers
  TextEditingController FirstNameController = TextEditingController();
  TextEditingController LastNameController = TextEditingController();
  // TextEditingController fatherNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController adminController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController personalAddressController = TextEditingController();
  TextEditingController firmAddressController = TextEditingController();
  TextEditingController firmNameController = TextEditingController();
  TextEditingController reraCertificate = TextEditingController();
  TextEditingController reraNumberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool isLoading = false;

  final List<DropdownMenuItem<String>> listOfGender = const [
    DropdownMenuItem(value: "male", child: Text("Male")),
    DropdownMenuItem(value: "female", child: Text("Female")),
    DropdownMenuItem(value: "other", child: Text("Other")),
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime initialDate = _selectedDate ?? today;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(today.year - 100),
      lastDate: today,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final channelPartner = settingProvider.channelPartner;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Channel Partner"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                FormHolder(
                  selected: _showPersonalDetails,
                  title: "Personal Details",
                  onTap: () {
                    setState(() {
                      _showPersonalDetails = !_showPersonalDetails;
                    });
                  },
                  childrens: [
                    if (_showPersonalDetails) ...[
                      const SizedBox(height: 16),
                      // Name Field
                      TextFormField(
                        controller: FirstNameController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          prefixIcon: const Icon(Icons.person),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.7),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: LastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          prefixIcon: const Icon(Icons.person),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.7),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Email Field
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.7),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Phone Number Field
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone ',
                          prefixIcon: const Icon(Icons.phone),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.7),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Date of Birth Field
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          prefixIcon: const Icon(Icons.calendar_today),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.7),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ),
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: 10),
                      // Gender Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          prefixIcon: const Icon(Icons.person),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.7),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ),
                        items: listOfGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: personalAddressController,
                        minLines: 2,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: 'Home Address',
                          prefixIcon: const Icon(Icons.home_filled),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.7)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.4)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Stack(
                        children: [
                          TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.password),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.7)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.4)),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 5,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 23,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: firmNameController,
                        decoration: InputDecoration(
                          labelText: 'Firm Name',
                          prefixIcon: const Icon(Icons.apartment),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.7)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.4)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Same as Above"),
                            Checkbox(
                              value: _sameAddress,
                              onChanged: (value) {
                                setState(() {
                                  _sameAddress = value!;
                                  if (value == true) {
                                    firmAddressController.text =
                                        personalAddressController.text;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        controller: firmAddressController,
                        minLines: 2,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: 'Firm Address',
                          prefixIcon: const Icon(Icons.home_filled),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.7)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.4)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),

                if (!_haveReraNumber)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Rera registration?",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withAlpha(240),
                            ),
                          ),
                        ),
                        Checkbox(
                          value: _haveReraNumber,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() {
                              _haveReraNumber = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                // Rera registration fields
                if (_haveReraNumber) ...[
                  const SizedBox(height: 16),
                  // Rera Number Field
                  TextFormField(
                    controller: reraNumberController,
                    decoration: InputDecoration(
                      labelText: 'Rera Number',
                      prefixIcon: const Icon(Icons.apartment),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.7)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.4)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Rera Certificate Field
                  TextFormField(
                    controller: reraCertificate,
                    decoration: InputDecoration(
                      labelText: 'Rera Certificate',
                      prefixIcon: const Icon(Icons.document_scanner),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.7)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.4)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                const SizedBox(height: 60),

                // Buttons for cancel and create account
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[300],
                          ),
                          onPressed: () {
                            GoRouter.of(context).pop();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[300],
                          ),
                          onPressed: () async {
                            Provider.of<SettingProvider>(
                              context,
                              listen: false,
                            );
                            setState(() {
                              isLoading = true;
                            });
                            await settingProvider.addChannelPartner(
                              FirstNameController.text,
                              LastNameController.text,
                              emailController.text,
                              _selectedGender!,
                              int.tryParse(phoneController.text) ?? 0,
                              passwordController.text,
                              _dateController.text,
                              personalAddressController.text,
                              firmNameController.text,
                              firmAddressController.text,
                              reraNumberController.text,
                              reraCertificate.text,
                            );
                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: const Text(
                            "Create account",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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

class FormHolder extends StatelessWidget {
  final bool selected;
  final String title;
  final VoidCallback onTap;
  final List<Widget> childrens;

  const FormHolder({
    super.key,
    required this.selected,
    required this.title,
    required this.onTap,
    required this.childrens,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(selected ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ],
            ),
            if (selected) ...childrens,
          ],
        ),
      ),
    );
  }
}
