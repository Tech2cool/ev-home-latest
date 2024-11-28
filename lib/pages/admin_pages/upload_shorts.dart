import 'dart:io';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadShorts extends StatefulWidget {
  const UploadShorts({super.key});

  @override
  State<UploadShorts> createState() => _UploadShortsState();
}

class _UploadShortsState extends State<UploadShorts> {
  // final FilePicker imagePicker = FilePicker();

  File? _uploadShorts;

  void onSelectVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // allowedExtensions: ['mp4'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _uploadShorts = File(result.files.single.path!);
      });
    }
  }

  Future<void> onSubmit() async {
    final apiService = ApiService();
    String upShowCaseVideo = "";

    if (_uploadShorts != null) {
      final uShowcaseVideo = await apiService.uploadFile(_uploadShorts!);
      if (uShowcaseVideo != null) {
        upShowCaseVideo = uShowcaseVideo.downloadUrl;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Upload Shorts',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              MaterialButton(
                color: Colors.blue,
                onPressed: onSelectVideo,
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
          if (_uploadShorts != null) ...[
            Row(
              children: [
                const SizedBox(
                  width: 50,
                  height: 60,
                  child: Icon(
                    Icons.video_file_outlined,
                    size: 35,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 10),
                const Text("Selected Video"),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _uploadShorts = null;
                    });
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ],
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              onSubmit();
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
    );
  }
}
