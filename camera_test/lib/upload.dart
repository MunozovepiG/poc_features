import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DocumentUploadScreen extends StatefulWidget {
  @override
  _DocumentUploadScreenState createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  bool _documentUploaded = false;
  String _uploadedFileName = '';

  void _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _documentUploaded = true;
        _uploadedFileName = result.files.single.name ?? '';
      });
    }
  }

  void _deleteDocument() {
    setState(() {
      _documentUploaded = false;
      _uploadedFileName = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _documentUploaded
                ? Column(
                    children: [
                      Text('Document Uploaded: $_uploadedFileName'),
                      ElevatedButton(
                        onPressed: _deleteDocument,
                        child: Text('Delete Document'),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: _pickDocument,
                    child: Text('Upload Document'),
                  ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DocumentUploadScreen(),
  ));
}
