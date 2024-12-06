import 'dart:io';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class UploadShorts extends StatefulWidget {
  const UploadShorts({super.key});

  @override
  State<UploadShorts> createState() => _UploadShortsState();
}

class _UploadShortsState extends State<UploadShorts> {
  // final FilePicker imagePicker = FilePicker();

  File? _uploadShorts;
  String? _fileName;

  void onSelectVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // allowedExtensions: ['mp4'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _uploadShorts = File(result.files.single.path!);
        _fileName = path.basename(result.files.single.path!);
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

        // Display the SnackBar upon successful upload
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Uploaded File Successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Optionally handle the case when the upload fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to upload file'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Handle the case when no file is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a file to upload'),
          backgroundColor: Colors.orange,
        ),
      );
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: const Expanded(
                  child: Text(
                    'Upload Files (Storage)',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: MaterialButton(
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
                Text(
                  _fileName ?? "Selected Video", // Display the file name
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _uploadShorts = null;
                      _fileName = null;
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
