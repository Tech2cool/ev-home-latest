import 'dart:io';
import 'package:ev_homes/components/loading/loading_square.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/amenity.dart';
import 'package:ev_homes/core/models/configuration.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddNewProjectPage extends StatefulWidget {
  const AddNewProjectPage({
    super.key,
  });

  @override
  State<AddNewProjectPage> createState() => _AddNewProjectPageState();
}

class _AddNewProjectPageState extends State<AddNewProjectPage> {
  final _formKey = GlobalKey<FormState>();

  final _projectNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _locationLinkController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();

  File? _showCaseImage;
  File? _selectedBrochure;
  List<File> _carouselImages = [];
  List<LocalAmenity> _amenites = [];
  List<LocalConfig> _configuration = [];
  bool isLoading = false;

  void onSelectAmenities() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Amenity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              AmenityDialog(
                onAdd: (name, images) {
                  if (images == null) return;
                  for (var img in images) {
                    setState(() {
                      _amenites.add(
                        LocalAmenity(
                          name: name,
                          imagePath: File(img.path),
                        ),
                      );
                    });
                  }
                },
                picker: imagePicker,
              ),
            ],
          ),
        );
      },
    );
  }

  void onSelectConfiguration() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ConfigurationDialog(
            onAdd: (configuration, reraId, carpetArea, price, image) {
              setState(() {
                _configuration.add(
                  LocalConfig(
                    reraId: reraId,
                    carpetArea: carpetArea,
                    price: double.parse(price),
                    configuration: configuration,
                    imagePath: File(image!.path),
                  ),
                );
              });
            },
            picker: imagePicker,
          ),
        );
      },
    );
  }

  void onSelectCarouselImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      for (var each in selectedImages) {
        setState(() {
          _carouselImages.add(
            File(each.path),
          );
        });
      }
    }
  }

  void onSelectShowCaseImage() async {
    final XFile? returnedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (returnedImage == null) {
      return;
    }

    setState(() {
      _showCaseImage = File(returnedImage.path);
    });
  }

  void onSelectBrochure() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedBrochure = File(result.files.single.path!);
      });
    }
  }

  Future<void> onSubmit() async {
    final apiService = ApiService();
    String upShowCaseImage = "";
    String uBrochure = "";
    List<String> carousel = [];
    List<Amenity> amenties = [];
    List<Configuration> configs = [];
    setState(() {
      isLoading = true;
    });
    try {
      if (_showCaseImage != null) {
        final uShowcaseImage = await apiService.uploadFile(_showCaseImage!);
        if (uShowcaseImage != null) {
          upShowCaseImage = uShowcaseImage.downloadUrl;
        }
      }

      if (_selectedBrochure != null) {
        final uBrochurResp = await apiService.uploadFile(_selectedBrochure!);
        if (uBrochurResp != null) {
          uBrochure = uBrochurResp.downloadUrl;
        }
      }

      if (_carouselImages.isNotEmpty) {
        final coruselResp = await apiService.uploadMultipleFile(
          _carouselImages,
        );
        if (coruselResp.isNotEmpty) {
          final dlinksCoursel =
              coruselResp.map((ele) => ele.downloadUrl).toList();
          setState(() {
            carousel = dlinksCoursel;
          });
        }
      }

      if (_amenites.isNotEmpty) {
        final aminitesLinks = _amenites.map((ele) => ele.imagePath).toList();

        final amenitiesResp = await apiService.uploadMultipleFile(
          aminitesLinks,
        );

        if (amenitiesResp.isNotEmpty) {
          for (int i = 0; i < amenitiesResp.length; i++) {
            setState(() {
              amenties.add(
                Amenity(
                  name: _amenites[i].name,
                  image: amenitiesResp[i].downloadUrl,
                ),
              );
            });
          }
        }
      }

      if (_configuration.isNotEmpty) {
        final configLinks = _configuration.map((ele) => ele.imagePath).toList();

        final configResp = await apiService.uploadMultipleFile(configLinks);

        if (configResp.isNotEmpty) {
          for (int i = 0; i < configResp.length; i++) {
            setState(() {
              configs.add(
                Configuration(
                  reraId: _configuration[i].reraId,
                  image: configResp[i].downloadUrl,
                  carpetArea: _configuration[i].carpetArea,
                  price: _configuration[i].price,
                  configuration: _configuration[i].configuration,
                ),
              );
            });
          }
        }
      }
      final settingProvider = Provider.of<SettingProvider>(
        context,
        listen: false,
      );

      OurProject newProject = OurProject(
        id: '',
        name: _projectNameController.text,
        description: _descriptionController.text,
        showCaseImage: upShowCaseImage,
        carouselImages: carousel,
        configurations: configs,
        amenities: amenties,
        brochure: uBrochure,
        locationName: _locationController.text,
        locationLink: _locationLinkController.text.isNotEmpty
            ? _locationLinkController.text
            : null,
        contactNumber: _contactController.text.isNotEmpty
            ? int.parse(_contactController.text)
            : null,
        // flatList: [],
      );
      await settingProvider.addNewProject(newProject);
    } catch (e) {
      // Helper.showCustomSnackBar("Unkown error adding new Project");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(title: const Text('Add New Project')),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: SizedBox(
                      width: 300,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MyTextField(
                              controller: _projectNameController,
                              hintText: "Project Name",
                            ),
                            const SizedBox(height: 16),
                            MyTextField(
                              controller: _locationController,
                              hintText: "Project Location",
                              prefixIcon: Icons.location_on,
                            ),
                            const SizedBox(height: 16),
                            MyTextField(
                              controller: _descriptionController,
                              hintText: "Description",
                              minLines: 2,
                            ),
                            const SizedBox(height: 16),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.4),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Select Showcase Image',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      MaterialButton(
                                        color: Colors.blue,
                                        onPressed: onSelectShowCaseImage,
                                        child: const Text(
                                          "Browse",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (_showCaseImage != null) ...[
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        height: 60,
                                        child: Image.file(
                                          _showCaseImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text("Selected Image"),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _showCaseImage = null;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.4),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Select Coursel Images',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      MaterialButton(
                                        color: Colors.blue,
                                        onPressed: onSelectCarouselImages,
                                        child: const Text(
                                          'Browse',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                const SizedBox(height: 10),
                                if (_carouselImages.isNotEmpty) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Selected Coursel Images",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _carouselImages = [];
                                          });
                                        },
                                        child: const Text(
                                          "Clear All",
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),

                                  ...List.generate(_carouselImages.length, (i) {
                                    return Row(
                                      children: [
                                        SizedBox(
                                          width: 50,
                                          height: 60,
                                          child: Image.file(
                                            _carouselImages[i],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Text("Selected Image"),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _carouselImages.removeAt(i);
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                        )
                                      ],
                                    );
                                  }),

                                  // const SizedBox(width: 16),
                                ],
                              ],
                            ),
                            // const SizedBox(height: 20),
                            // MyTextField(
                            //   controller: _descriptionController,
                            //   hintText: "Description",
                            // ),
                            // const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Amenities',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 16.0),
                                Row(
                                  children: [
                                    const Text(
                                      'Add New',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      color: Colors.green,
                                      onPressed: onSelectAmenities,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (_amenites.isNotEmpty) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Selected Amenities",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _amenites = [];
                                      });
                                    },
                                    child: const Text(
                                      "Clear All",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ...List.generate(_amenites.length, (i) {
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      height: 60,
                                      child: Image.file(
                                        _amenites[i].imagePath,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(_amenites[i].name),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _amenites.removeAt(i);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                );
                              }),
                            ],
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Configuration',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 16.0),
                                Row(
                                  children: [
                                    const Text(
                                      'Add Configuration',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      color: Colors.green,
                                      onPressed: onSelectConfiguration,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (_configuration.isNotEmpty) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Selected Configurations",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _configuration = [];
                                      });
                                    },
                                    child: const Text(
                                      "Clear All",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ...List.generate(_configuration.length, (i) {
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      height: 60,
                                      child: Image.file(
                                        _configuration[i].imagePath,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${_configuration[i].configuration} / ${_configuration[i].carpetArea} / ${Helper.formatNumber(_configuration[i].price)}',
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _configuration.removeAt(i);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                );
                              }),
                            ],
                            const SizedBox(height: 16),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.4),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Select Brochure',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      MaterialButton(
                                        color: Colors.blue,
                                        onPressed: onSelectBrochure,
                                        child: const Text(
                                          "Browse",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (_selectedBrochure != null) ...[
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 50,
                                        height: 60,
                                        child: Icon(
                                          Icons.picture_as_pdf,
                                          size: 35,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text("Selected Brochure"),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedBrochure = null;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ],
                            ),
                            MyTextField(
                              controller: _locationLinkController,
                              hintText: "Select Location",
                              prefixIcon: Icons.location_on,
                            ),
                            const SizedBox(height: 16),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text(
                                'Preview',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 40),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      onSubmit();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (isLoading) const LoadingSquare()
          ],
        ));
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.validatorText,
    this.prefixIcon,
    this.minLines,
    this.maxLines,
  });

  final TextEditingController controller;
  final String hintText;
  final String? validatorText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: hintText,
        prefixIcon: Icon(prefixIcon ?? Icons.title),
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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 15,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorText ?? 'Please enter a Project Name';
        }
        return null;
      },
    );
  }
}

class AmenityDialog extends StatefulWidget {
  final void Function(String, List<XFile>?) onAdd;
  final ImagePicker picker;

  const AmenityDialog({super.key, required this.onAdd, required this.picker});

  @override
  State<AmenityDialog> createState() => _AmenityDialogState();
}

class _AmenityDialogState extends State<AmenityDialog> {
  final TextEditingController _nameController = TextEditingController();
  List<XFile>? _pickedImages = [];

  Future<void> _pickImages() async {
    final List<XFile> pickedImages = await widget.picker.pickMultiImage();

    if (pickedImages.length > 3) {
      // Display a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only select up to 3 images.'),
          duration: Duration(seconds: 6),
        ),
      );

      setState(() {
        _pickedImages = pickedImages.take(3).toList();
      });
    } else {
      setState(() {
        _pickedImages = pickedImages;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Amenity name'),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickImages,
                  child: const Text('Upload Image'),
                ),
              ],
            ),
            if (_pickedImages != null && _pickedImages!.isNotEmpty)
              SizedBox(
                height: 100, // Adjust the height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _pickedImages!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        File(_pickedImages![index].path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                widget.onAdd(_nameController.text, _pickedImages);
                Navigator.of(context).pop();
              },
              child: const Text('Add Amenities'),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfigurationDialog extends StatefulWidget {
  final void Function(String, String, String, String, XFile?) onAdd;
  final ImagePicker picker;

  const ConfigurationDialog(
      {super.key, required this.onAdd, required this.picker});

  @override
  State<ConfigurationDialog> createState() => _ConfigurationDialogState();
}

class _ConfigurationDialogState extends State<ConfigurationDialog> {
  final TextEditingController _configurationController =
      TextEditingController();
  final TextEditingController _reraIdController = TextEditingController();
  final TextEditingController _carpetAreaController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  XFile? _pickedImage1;

  @override
  void dispose() {
    _carpetAreaController.dispose();
    _priceController.dispose();
    _reraIdController.dispose(); // Dispose the RERA ID controller
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage1 =
        await widget.picker.pickImage(source: ImageSource.gallery);

    if (pickedImage1 != null) {
      // Display a message to the user
      setState(() {
        _pickedImage1 = pickedImage1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Center(
                child: Text(
                  'Add Configuration',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _configurationController,
                      decoration: const InputDecoration(
                        labelText: 'Configuration',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _reraIdController,
                      decoration: const InputDecoration(
                        labelText: 'Rera ID',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _carpetAreaController,
                      decoration: const InputDecoration(
                        labelText: 'Carpet Area',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Upload Image'),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              if (_pickedImage1 != null)
                SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      File(_pickedImage1!.path),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  widget.onAdd(
                    _configurationController.text,
                    _reraIdController.text,
                    _carpetAreaController.text,
                    _priceController.text,
                    _pickedImage1,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Add Configurations'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocalAmenity {
  final String name;
  final File imagePath;

  LocalAmenity({required this.name, required this.imagePath});
}

class LocalConfig {
  final String reraId;
  final String carpetArea;
  final double price;
  final String configuration;
  final File imagePath;

  LocalConfig({
    required this.reraId,
    required this.carpetArea,
    required this.price,
    required this.configuration,
    required this.imagePath,
  });
}
