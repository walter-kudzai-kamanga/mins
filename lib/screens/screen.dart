import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class FilePickerScreen extends StatefulWidget {
  @override
  _FilePickerScreenState createState() => _FilePickerScreenState();
}

class _FilePickerScreenState extends State<FilePickerScreen> {
  String? _fileName;
  Uint8List? _fileBytes; // Stores file content for web

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        _fileBytes = result.files.single.bytes; // Web returns file as bytes
      });

      // Example: Convert bytes to a file (for uploads)
      if (_fileBytes != null) {
        print("File size: ${_fileBytes!.length} bytes");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("File Picker Example")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: Text("Pick a File"),
            ),
            SizedBox(height: 20),
            _fileName != null
                ? Text("Selected File: $_fileName", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                : Text("No file selected", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FilePickerScreen(),
  ));
}
