import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class AdminRegisterPersonalSection extends StatefulWidget {
  final TextEditingController emailAddressTextController;
  // final FocusNode emailAddressFocusNode;
  // final FocusNode emailAddressValidatorFocusNode;
  final TextEditingController passwordController;
  // final FocusNode passwordFocusNode;
  final bool passwordVisibility;
  // final Function() onPressPassVisibility;
  // final Function() onPressSignup;
  final String? Function(String?)? passwordValidator;
  final String? Function(String?)? emailValidator;
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController dobController;
  final TextEditingController addressController;
  final TextEditingController confirmPasswordController;

  final String? selectedGender;
  final Function(String? gender) updateGender;
  const AdminRegisterPersonalSection({
    super.key,
    required this.emailAddressTextController,
    // required this.emailAddressFocusNode,
    // required this.emailAddressValidatorFocusNode,
    required this.passwordController,
    required this.confirmPasswordController,
    // required this.passwordFocusNode,
    required this.passwordVisibility,
    // required this.onPressPassVisibility,
    required this.nameController,
    required this.selectedGender,
    required this.lastNameController,
    required this.phoneController,
    required this.dobController,
    required this.addressController,
    // required this.onPressSignup,
    this.passwordValidator,
    this.emailValidator,
    required this.updateGender,
  });

  @override
  _AdminRegisterPersonalSectionState createState() =>
      _AdminRegisterPersonalSectionState();
}

class _AdminRegisterPersonalSectionState
    extends State<AdminRegisterPersonalSection>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _shinyAnimation;
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _lastNameController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _dobController = TextEditingController();

  // final TextEditingController _addressController = TextEditingController();
  bool _isPersonalDetailsComplete = false;
  bool _passwordVisibility = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _shinyAnimation =
        Tween<double>(begin: -1, end: 2).animate(_animationController);

    void togglePasswordVisibility() {
      setState(() {
        _passwordVisibility = !_passwordVisibility;
      });
    }
  }

  @override
  void dispose() {
    // widget.nameController.dispose();
    // widget.lastNameController.dispose();
    // widget.phoneController.dispose();
    // widget.dobController.dispose();
    // widget.addressController.dispose();
    // _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center(
              //   child: Image.asset(
              //     'assets/images/3.png',
              //     height: 80,
              //     width: 100,
              //   ),
              // ),
              // const SizedBox(height: 10),
              // Timeline tile
              // _buildTimelineTile(),
              // const SizedBox(height: 15),
              const Text(
                'Personal Details',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'First Name',
                      icon: Icons.person,
                      controller: widget.nameController,
                      validator: (value) {
                        return value == null || value.isEmpty
                            ? 'Please enter your first name'
                            : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildTextField(
                      label: 'Last Name',
                      icon: Icons.person,
                      controller: widget.lastNameController,
                      validator: (value) {
                        return value == null || value.isEmpty
                            ? 'Please enter your last name'
                            : null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Email address',
                icon: Icons.email,
                controller: widget.emailAddressTextController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Regular expression for validating email format
                  String pattern =
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
                      r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                label: 'Password',
                controller: widget.passwordController,
                isVisible: _passwordVisibility,
                onVisibilityPressed: () {
                  setState(() {
                    _passwordVisibility = !_passwordVisibility;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                label: 'Confirm Password',
                controller: widget.confirmPasswordController,
                isVisible: _passwordVisibility,
                onVisibilityPressed: () {
                  setState(() {
                    _passwordVisibility = !_passwordVisibility;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your confirm password';
                  } else if (value.length < 6) {
                    return ' confirm Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildPhoneNumberField(widget.phoneController),
              const SizedBox(height: 16),
              _buildDateOfBirthField(context),
              const SizedBox(height: 16),
              _buildGenderDropdown(),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Address',
                icon: Icons.home,
                controller: widget.addressController,
                maxLength: 100,
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'Please enter your address'
                      : null;
                },
              ),
              const SizedBox(height: 32),
              // _buildNextButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required Function() onVisibilityPressed,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
        prefixIcon: const Icon(Icons.lock, color: Colors.black, size: 18),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        suffixIcon: InkWell(
          onTap: onVisibilityPressed,
          focusNode: FocusNode(skipTraversal: true),
          child: Icon(
            _passwordVisibility
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          // onTap: onVisibilityPressed,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildTimelineTile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 80,
                width: double.infinity,
                child: TimelineTile(
                  alignment: TimelineAlign.center,
                  isFirst: true,
                  axis: TimelineAxis.horizontal,
                  indicatorStyle: IndicatorStyle(
                    width: 30,
                    // height: 30,
                    indicator: _isPersonalDetailsComplete
                        ? const Icon(Icons.check_circle,
                            color: Colors.green, size: 24)
                        : const Icon(
                            Icons.radio_button_unchecked,
                            size: 24,
                            color: Colors.grey,
                          ),
                  ),
                  beforeLineStyle: LineStyle(
                    // color: Colors.purple,
                    color:
                        _isPersonalDetailsComplete ? Colors.green : Colors.grey,
                    thickness: 4,
                  ),
                  // startChild: Text("Personal Details"),
                  endChild: const Text(
                    "Personal Details",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8), // Spacing between line and label
              // const Text('Personal Details'),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 80,
                width: double.infinity,
                child: TimelineTile(
                  alignment: TimelineAlign.center,
                  isFirst: false,
                  axis: TimelineAxis.horizontal,
                  indicatorStyle: const IndicatorStyle(
                    width: 30,
                    // height: 30,
                    indicator: Icon(
                      Icons.radio_button_unchecked,
                      size: 24,
                      color: Colors.grey,
                    ),
                  ),
                  beforeLineStyle: LineStyle(
                    // color: Colors.purple,
                    color:
                        _isPersonalDetailsComplete ? Colors.grey : Colors.grey,
                    thickness: 4,
                  ),
                  // startChild: Text("Personal Details"),
                  endChild: const Text(
                    "Company Details",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8), // Spacing between line and label
              // const Text('Company Details'),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 80,
                width: double.infinity,
                child: TimelineTile(
                  alignment: TimelineAlign.center,
                  isLast: true,
                  axis: TimelineAxis.horizontal,
                  indicatorStyle: const IndicatorStyle(
                    width: 30,
                    // height: 30,
                    indicator: Icon(
                      Icons.radio_button_unchecked,
                      size: 24,
                      color: Colors.grey,
                    ),
                  ),
                  beforeLineStyle: LineStyle(
                    // color: Colors.purple,
                    color:
                        _isPersonalDetailsComplete ? Colors.grey : Colors.grey,
                    thickness: 4,
                  ),
                  // startChild: Text("Personal Details"),
                  endChild: const Text(
                    "Registration",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8), // Spacing between line and label
              // const Text('Registration'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateOfBirthField(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        setState(() {
          widget.dobController.text = "${pickedDate?.toLocal()}".split(' ')[0];
          // DateFormat('yyyy-mm-dd').format(pickedDate);
        });
      },
      child: AbsorbPointer(
        child: _buildTextField(
          label: 'D.O.B',
          icon: Icons.calendar_today,
          controller: widget.dobController,
          validator: (value) {
            return value == null || value.isEmpty
                ? 'Please select your date of birth'
                : null;
          },
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: const TextStyle(color: Colors.black, fontSize: 12),
        prefixIcon: const Icon(Icons.person, color: Colors.black, size: 18),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      ),
      value: widget.selectedGender,
      items: ['male', 'female', 'other']
          .map((gender) => DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              ))
          .toList(),
      onChanged: (value) {
        widget.updateGender(value);
        // setState(() {
        //   widget.selectedGender = value;
        // });
      },
      validator: (value) => value == null ? 'Please select your gender' : null,
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _isPersonalDetailsComplete = true;
            });

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const AdminCompanyRegisterForm(
            //       isPersonalDetailsComplete: true,
            //       isCompanyDetailsComplete: false,
            //     ),
            //   ),
            // );
          }
        },
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF745C),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _shinyAnimation,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.8),
                          Colors.white.withOpacity(0.0),
                        ],
                        stops: [
                          _shinyAnimation.value - 0.2,
                          _shinyAnimation.value,
                          _shinyAnimation.value + 0.2,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white.withOpacity(0.2),
                      ),
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
}

Widget _buildPhoneNumberField(TextEditingController controller) {
  return TextFormField(
    keyboardType: TextInputType.phone,
    maxLength: 10,
    controller: controller,
    style: const TextStyle(color: Colors.black, fontSize: 12),
    decoration: InputDecoration(
      labelText: 'Phone Number',
      labelStyle: const TextStyle(color: Colors.black, fontSize: 12),
      prefixIcon: const Icon(Icons.phone, color: Colors.black, size: 18),
      prefixText: '+91 ',
      prefixStyle: const TextStyle(color: Colors.black, fontSize: 12),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your phone number';
      }
      if (value.length != 10) {
        return 'Phone number must be 10 digits';
      }
      return null;
    },
  );
}

Widget _buildTextField({
  required String label,
  required IconData icon,
  required TextEditingController controller,
  FocusNode? focusNode,
  TextInputType? keyboardType,
  int? maxLength,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    keyboardType: keyboardType,
    controller: controller,
    focusNode: focusNode,
    style: const TextStyle(color: Colors.black, fontSize: 12),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black, fontSize: 12),
      prefixIcon: Icon(icon, color: Colors.black, size: 18),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
    ),
    validator: validator,
  );
}
