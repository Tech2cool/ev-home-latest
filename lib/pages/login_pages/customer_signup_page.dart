// import 'package:ev_homes/Customer%20pages/login_page.dart';
// import 'package:ev_homes/Customer%20pages/otp_verification.dart';
import 'package:ev_homes/core/models/customer.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:ev_homes/pages/login_pages/customer_login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:ev_homes/pages/customer/login_screen.dart';

// import '../pages/Customer pages/otp_verification.dart';
// import 'package:ev_homes/pages/customer/otp_verification.dart';

class SignUpTabBarPage extends StatelessWidget {
  const SignUpTabBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SignUpTabBar(
            emailAddressTextController: TextEditingController(),
            emailAddressFocusNode: FocusNode(),
            emailAddressValidatorFocusNode: FocusNode(),
            passwordController: TextEditingController(),
            passwordFocusNode: FocusNode(),
            passwordVisibility: false,
            confirmPasswordController: TextEditingController(),
            // confirmPasswordVisibility: false,
            // onPressPassVisibility: () {

            // },
            onPressSignup: () {
              // Signup action logic
            },
            confirmpasswordValidator: (value) {
              return value == null || value.length < 6
                  ? 'Password must be at least 6 characters'
                  : null;
            },
            passwordValidator: (value) {
              return value == null || value.length < 6
                  ? 'Password must be at least 6 characters'
                  : null;
            },
            emailValidator: (value) {
              return value == null || !value.contains('@')
                  ? 'Enter a valid email address'
                  : null;
            },
          ),
        ),
      ),
    );
  }
}

class SignUpTabBar extends StatefulWidget {
  final TextEditingController emailAddressTextController;
  final FocusNode emailAddressFocusNode;
  final FocusNode emailAddressValidatorFocusNode;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final bool passwordVisibility;
  final TextEditingController confirmPasswordController;
  // final bool confirmPasswordVisibility;
  // final Function() onPressPassVisibility;
  final Function() onPressSignup;
  final String? Function(String?) passwordValidator;
  final String? Function(String?) confirmpasswordValidator;
  final String? Function(String?) emailValidator;

  const SignUpTabBar({
    super.key,
    required this.emailAddressTextController,
    required this.emailAddressFocusNode,
    required this.emailAddressValidatorFocusNode,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.passwordVisibility,
    required this.confirmPasswordController,
    // required this.confirmPasswordVisibility,
    // required this.onPressPassVisibility,
    required this.onPressSignup,
    required this.passwordValidator,
    required this.confirmpasswordValidator,
    required this.emailValidator,
  });

  @override
  State<SignUpTabBar> createState() => _SignUpTabBarState();
}

class _SignUpTabBarState extends State<SignUpTabBar>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _shinyAnimation;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  //List<Project> _projects = []; // This will be your project list fetched from the database
  String? _selectedProject;

  Employee? _selectedTL;
  String? _selectedResidence;
  String? _selectedOtherLocation;
  String? _selectedApartment;
  bool _showOtherLocations = false;

  bool _passwordVisibility = false;
  bool _confirmPasswordVisibility = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _shinyAnimation =
        Tween<double>(begin: -1, end: 2).animate(_animationController);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisibility = !_passwordVisibility;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _confirmPasswordVisibility =
          !_confirmPasswordVisibility; // Toggle the local state variable
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> createAccount() async {
    Customer newCustomer = Customer(
      id: "",
      firstName: _nameController.text,
      lastName: _lastNameController.text,
      email: widget.emailAddressTextController.text,
      gender: "Male",
      phoneNumber: int.parse(_phoneController.text),
      address: _selectedResidence,
      projects: [_selectedProject!],
      choiceApt: [_selectedApartment!],
      closingManager: _selectedTL,
    );
    Map<String, dynamic> mapped = newCustomer.toMap();
    if (mapped['closingManager'] != null) {
      mapped['closingManager'] = mapped['closingManager']['id'];
    }

    mapped['password'] = widget.passwordController.text;
    await ApiService().registerCustomerAndSiteVisit(
      context,
      mapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final employees = settingProvider.closingManagers;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Center(
                  child: Image.asset(
                    'assets/images/3.png',
                    height: 100,
                    width: 100,
                  ),
                ),
                const Text(
                  'Create your account',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Kindly Register to know More About Our Project',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'First Name',
                        icon: Icons.person,
                        controller: _nameController,
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
                        controller: _lastNameController,
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
                  focusNode: widget.emailAddressFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  validator: widget.emailValidator,
                ),
                const SizedBox(height: 16),
                _buildPhoneNumberField(_phoneController),

                const SizedBox(height: 16),
                _buildPasswordField(
                  label: 'Password',
                  controller: widget.passwordController,
                  isVisible: _passwordVisibility,
                  onVisibilityPressed: _togglePasswordVisibility,
                  validator: widget.passwordValidator,
                ),
                const SizedBox(height: 16),
                _buildConfirmPasswordField(
                  label: 'Confirm Password',
                  controller: widget.confirmPasswordController,
                  isVisible: _confirmPasswordVisibility,
                  onVisibilityPressed: _toggleConfirmPasswordVisibility,
                  validator: widget.confirmpasswordValidator,
                ),

                // Adding Project Dropdown below Confirm Password field
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildProjectDropdown()),
                    const SizedBox(
                        width: 10), // Add space between the two dropdowns
                    Expanded(child: _buildchoiceofapartmentDropdown()),
                  ],
                ),

                const SizedBox(height: 16),
                _buildTLDropdown(employees),

                const SizedBox(height: 16),
                _buildResidenceDropdown(),

                if (_showOtherLocations) const SizedBox(height: 16),
                if (_showOtherLocations) _buildOtherLocationsDropdown(),

                const SizedBox(height: 32),
                _buildRegisterButton(context),

                const SizedBox(height: 16),

                // Align(
                //   alignment: const AlignmentDirectional(0.0, 0.0),
                //   child: Padding(
                //     padding: const EdgeInsetsDirectional.fromSTEB(
                //         6.0, 0.0, 6.0, 4.0),
                //     child: AnimatedContainer(
                //       duration:
                //           const Duration(seconds: 1), // Animation duration
                //       child: const Row(
                //         children: [
                //           Expanded(
                //             child: Divider(
                //               color: Colors.grey,
                //               thickness: 1.0,
                //             ),
                //           ),
                //           Padding(
                //             padding: EdgeInsets.symmetric(horizontal: 8.0),
                //             child: Text(
                //               'or',
                //               style: TextStyle(
                //                 fontSize: 16.0,
                //                 color: Colors.black54,
                //               ),
                //             ),
                //           ),
                //           Expanded(
                //             child: Divider(
                //               color: Colors.grey,
                //               thickness: 1.0,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),

                // const SizedBox(height: 16), // Add space after the divider
                // Center(
                //   child: SizedBox(
                //     width: double.infinity,
                //     height: 50, // Height of the button
                //     child: ElevatedButton.icon(
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.white, // White background
                //         shape: RoundedRectangleBorder(
                //           borderRadius:
                //               BorderRadius.circular(12.0), // Rounded corners
                //         ),
                //         side: const BorderSide(
                //           color: Colors.grey, // Border color
                //         ),
                //       ),
                //       icon: Image.asset(
                //         'assets/images/google_icon.webp', // Replace with your Google icon path
                //         height: 24.0, // Icon size
                //       ),
                //       label: const Text(
                //         'Sign in with Google',
                //         style: TextStyle(
                //           color: Colors.black, // Text color
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       onPressed: () {
                //         // Google sign-in action logic
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
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

  Widget _buildConfirmPasswordField({
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
            _confirmPasswordVisibility
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          // onTap: onVisibilityPressed,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildProjectDropdown() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _selectedProject,
          decoration: InputDecoration(
            labelText: 'Select Project',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          items: [
            'MARINA BAY',
            'EV9 SQUARE',
            'Heart City',
            'Other',
          ].map((project) {
            return DropdownMenuItem<String>(
              value: project,
              child: FittedBox(child: Text(project)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedProject = newValue;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a project';
            }
            return null;
          },
        ),
        if (_selectedProject == 'Other') ...[
          const SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Other Project',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            validator: (value) {
              if (_selectedProject == 'Other' &&
                  (value == null || value.isEmpty)) {
                return 'select Other Project';
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  Widget _buildTLDropdown(List<Employee> emps) {
    return DropdownButtonFormField<Employee>(
      value: _selectedTL,
      decoration: InputDecoration(
        labelText: 'Closing Manager',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      items: emps.map((teamleader) {
        return DropdownMenuItem<Employee>(
          value: teamleader,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "${teamleader.firstName} ${teamleader.lastName}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  "(${teamleader.designation?.designation ?? "NA"})",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedTL = newValue;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a Closing Manager';
        }
        return null;
      },
      isExpanded: true,
    );
  }

  Widget _buildchoiceofapartmentDropdown() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _selectedApartment,
          decoration: InputDecoration(
            labelText: 'Choice of Apartment',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          items: [
            '1RK',
            '1BHK',
            '2BHK',
            '3BHK',
            'JODI',
            'Other',
          ].map((apartment) {
            return DropdownMenuItem<String>(
              value: apartment,
              child: FittedBox(child: Text(apartment)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedApartment = newValue;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select choice of apartment';
            }
            return null;
          },
        ),
        if (_selectedApartment == 'Other') ...[
          const SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Other Apartment',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            validator: (value) {
              if (_selectedApartment == 'Other' &&
                  (value == null || value.isEmpty)) {
                return 'select Other Apartment';
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  Widget _buildResidenceDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedResidence,
      decoration: InputDecoration(
        labelText: 'Residence',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      items: [
        'Vashi',
        'Nerul',
        'Koparkhairane',
        'Seawoods',
        'Kharghar',
        'Panvel',
        'Belapur',
        'Juinagar',
        'Sanpada',
        'Airoli',
        'Ghansoli',
        'Other',
      ].map((residence) {
        return DropdownMenuItem<String>(
          value: residence,
          child: Text(residence),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedResidence = newValue;
          _showOtherLocations = newValue == 'Other'; // Show second dropdown
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a residence';
        }
        return null;
      },
    );
  }

  Widget _buildOtherLocationsDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedOtherLocation,
      decoration: InputDecoration(
        labelText: 'Other Location',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      items: [
        'Chembur',
        'Andheri',
        'South Mumbai',
        'Pune',
      ].map((location) {
        return DropdownMenuItem<String>(
          value: location,
          child: Text(location),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedOtherLocation = newValue;
        });
      },
      validator: (value) {
        if (_showOtherLocations && (value == null || value.isEmpty)) {
          return 'Please select a location';
        }
        return null;
      },
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            // String phone = _phoneController.text;
            await createAccount();
            if (!context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPagee(),
              ),
            );
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
                'REGISTER',
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
    style: const TextStyle(color: Colors.black, fontSize: 14),
    decoration: InputDecoration(
      labelText: 'Phone Number',
      labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
      prefixIcon: const Icon(Icons.phone, color: Colors.black, size: 18),
      prefixText: '+91 ',
      prefixStyle: const TextStyle(color: Colors.black, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
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
  String? Function(String?)? validator,
}) {
  return TextFormField(
    keyboardType: keyboardType,
    controller: controller,
    focusNode: focusNode,
    style: const TextStyle(color: Colors.black, fontSize: 14),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.black, size: 18),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
    ),
    validator: validator,
  );
}
