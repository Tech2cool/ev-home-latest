import 'dart:io';
import 'dart:typed_data';

import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/providers/geolocation_provider.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:ev_homes/core/services/image_picker_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as img; // Import the image package

class TimeInOutScreen extends StatefulWidget {
  const TimeInOutScreen({super.key});

  @override
  State<TimeInOutScreen> createState() => _TimeInOutScreenState();
}

class _TimeInOutScreenState extends State<TimeInOutScreen> {
  ImagePickerService imagePickerService = ImagePickerService();
  // DatabaseService databaseService = DatabaseService();

  // caputuring screenshot of the imageWidget
  GlobalKey key = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  // for indicator after capturing photo
  bool isLoadingImage = true;
  bool isUploadingImage = false;
  // original captured image
  File? imageFile2;

  // device info
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceName = "";
  String deviceImei = "";

  // simple date format like 2024-09-04 12:44
  String getFormatedTime() {
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    DateTime now = DateTime.now();
    return formatter.format(now);
  }

  Future<void> _pickImage() async {
    setState(() {
      isLoadingImage = true;
    });
    final img = await imagePickerService.takePhoto();
    if (img != null) {
      setState(() {
        imageFile2 = img;
      });
    } else {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        isLoadingImage = false;
      });
    });
  }

  Future<void> _getCurrentLocationAndAddress() async {
    setState(() {
      // geolocationProvider.address = "Fetching location...";
    });
    // await _locationService.fetchCurrentLocationAndAddress();
    // setState(() {
    //   geolocationProvider.address = _locationService.address;
    // });
  }

  Future<void> getDeviceInfo() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceName = androidInfo.model;
    deviceImei = androidInfo.manufacturer;
  }

  // Attendance punchInAttendance(UserModel user, imageUrl) {
  //   Attendance attendance = Attendance(
  //     userId: user.uid,
  //     date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  //     startTime: Timestamp.now(),
  //     // startPosition: LatLangPosition(
  //     //   longitude: _locationService.longitude!,
  //     //   latitude: _locationService.latitude!,
  //     // ),
  //     // startAddress: _locationService.address,
  //     startSelfie: imageUrl!,
  //     status: Status.isShiftStarted,
  //   );
  //   return attendance;
  // }

  // Attendance punchOutAttendance(
  //     UserModel user, imageUrl, Attendance todayAttendance) {
  //   Attendance attendance = Attendance(
  //     userId: user.uid,
  //     date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  //     //start info
  //     startTime: todayAttendance.startTime,
  //     startAddress: todayAttendance.startAddress,
  //     startPosition: todayAttendance.startPosition,
  //     startSelfie: todayAttendance.startSelfie,
  //     //end info
  //     // endPosition: LatLangPosition(
  //     //   longitude: _locationService.longitude!,
  //     //   latitude: _locationService.latitude!,
  //     // ),
  //     // endAddress: _locationService.address,
  //     endTime: Timestamp.now(),
  //     endSelfie: imageUrl!,
  //     //done
  //     status: Status.isDayCompleted,
  //   );
  //   return attendance;
  // }

  Future<void> onPressConfirm(
    screenshotController,
    /*UserModel? user,
      AttendanceProvider attendanceProvider*/
  ) async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    final geolocationProvider = Provider.of<GeolocationProvider>(
      context,
      listen: false,
    );

    // Attendance? todayAttendance = attendanceProvider.attendanceToday;
    setState(() {
      isUploadingImage = true;
    });
    bool isValidShift = false;
    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        // Convert to an image object using the image package
        img.Image? capturedImage = img.decodeImage(image);

        if (capturedImage != null) {
          // Compress the image to reduce its size
          final compressedImage = img.encodeJpg(
            capturedImage,
            quality: 50,
          ); // Adjust quality as needed

          // Save the compressed image to a temporary file
          final tempDir = await getTemporaryDirectory();
          final filePath = '${tempDir.path}/compressed_screenshot.jpg';
          final file = File(filePath)..writeAsBytesSync(compressedImage);

          final uploadedResp = await ApiService().uploadFile(file);
          if (uploadedResp == null) {
            Helper.showCustomSnackBar("Failed to Upload Photo");
            return;
          }

          final resp = await ApiService().checkInAttendance({
            "userId": settingProvider.loggedAdmin!.id!,
            "checkInLatitude": geolocationProvider.latitude,
            "checkInLongitude": geolocationProvider.longitude,
            "checkInPhoto": uploadedResp.downloadUrl,
          });

          // final bool checkIn = todayAttendance == null ||
          //     (todayAttendance != null &&
          //         todayAttendance.status == Status.isShiftStarted);
          // // Upload the compressed image to Firebase
          // final imageUrl = await databaseService.uploadImageToFirebase(
          //     file, user!.uid, checkIn);

          // isValidShift = todayAttendance != null &&
          //     todayAttendance.status == Status.isShiftStarted;

          // if (isValidShift) {
          //   Attendance attendance =
          //       punchOutAttendance(user, imageUrl, todayAttendance!);
          //   // NotificationListener()
          //   AttendanceService attendanceService = AttendanceService();
          //   await attendanceService.saveOrUpdateAttendance(attendance);
          // } else {
          //   Attendance attendance = punchInAttendance(user, imageUrl);
          //   AttendanceService attendanceService = AttendanceService();
          //   await attendanceService.saveOrUpdateAttendance(attendance);
          // }

          setState(() {
            isUploadingImage = false;
          });

          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      }
    }).catchError((onError) {
      print(onError);
      setState(() {
        isUploadingImage = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _pickImage();
    // _getCurrentLocationAndAddress();
    getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvider>(context).user;
    // final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final geolocationProvider = Provider.of<GeolocationProvider>(context);

    // final Attendance? todayAttendance = attendanceProvider.attendanceToday;
    // bool checkOut = todayAttendance != null &&
    //     todayAttendance.status == Status.isShiftStarted;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Check ${/*checkOut ? 'Out' :*/ 'In'}",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              CustomPhotoView(
                address: geolocationProvider.address,
                screenshotController: screenshotController,
                globalKey: key,
                isLoadingImage: isLoadingImage,
                imageFile2: imageFile2,
                time: getFormatedTime(),
              ),
              const SizedBox(height: 10),
              CustomListItem(
                text: "$deviceName / $deviceImei",
                icon: Icons.phone_android_outlined,
              ),
              const SizedBox(height: 10),
              CustomListItem(
                text: getFormatedTime(),
                icon: Icons.access_time,
              ),
              const SizedBox(height: 10),
              CustomListItem(
                text: geolocationProvider.address,
                icon: Icons.location_on,
                iconColor: Colors.red,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyCustomBtn(
                    text: "Retake",
                    btnColor: Colors.amber,
                    textColor: Colors.black,
                    onPress: _pickImage,
                  ),
                  const SizedBox(width: 20),
                  MyCustomBtn(
                    text: "Confirm",
                    onPress: () => onPressConfirm(
                      screenshotController, /*user!, attendanceProvider*/
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isUploadingImage)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.6),
            ),
          if (isUploadingImage)
            Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: Platform.isIOS
                    ? const CircularProgressIndicator.adaptive()
                    : CircularProgressIndicator(
                        color: Colors.amber[900],
                        strokeWidth: 3,
                      ),
              ),
            ),
        ],
      ),
    );
  }
}

class MyCustomBtn extends StatelessWidget {
  final String text;
  final Color? btnColor;
  final Color? textColor;
  final void Function() onPress;
  const MyCustomBtn({
    super.key,
    required this.text,
    required this.onPress,
    this.btnColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.4,
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor ?? Colors.green,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String text;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? Colors.green,
            size: 28,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPhotoView extends StatelessWidget {
  final ScreenshotController screenshotController;
  final GlobalKey globalKey;
  final bool isLoadingImage;
  final File? imageFile2;
  final String address;
  final String time;

  const CustomPhotoView({
    super.key,
    required this.screenshotController,
    required this.globalKey,
    required this.isLoadingImage,
    required this.imageFile2,
    required this.address,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Stack(
        key: key,
        children: [
          isLoadingImage
              ? AspectRatio(
                  aspectRatio: 9 / 10,
                  child: Container(
                      color: Colors.grey.withOpacity(0.3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Platform.isIOS
                                ? const CircularProgressIndicator.adaptive()
                                : CircularProgressIndicator(
                                    color: Colors.amber[900],
                                    strokeWidth: 3,
                                  ),
                          )
                        ],
                      )),
                )
              : imageFile2 != null
                  ? AspectRatio(
                      aspectRatio: 9 / 10,
                      child: Image.file(
                        imageFile2!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : AspectRatio(
                      aspectRatio: 9 / 10,
                      child: Container(
                        color: Colors.grey.withOpacity(0.3),
                        child: const Text("No Image"),
                      ),
                    ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                address,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                time,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//TODO://punch-in-out-screen