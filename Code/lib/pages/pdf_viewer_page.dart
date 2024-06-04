import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfViewerPage extends StatefulWidget {
  final File file;
  final String url;

  const PdfViewerPage({
    Key? key,
    required this.file,
    required this.url,
  }) : super(key: key);

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final storageRef = FirebaseStorage.instance.ref();

  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          name,
          style: TextStyle(color: Colors.blueGrey),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _downloadFile(widget.url);
            },
            icon: const Icon(Icons.download_rounded),
          ),
        ],
      ),
      body: PDFView(
        filePath: widget.file.path,
      ),
    );
  }

  Future<void> _downloadFile(String fileUrl) async {
    print("File URL: $fileUrl");
    //final docUrl = await storageRef.child(fileUrl).getDownloadURL();

    final Uri _url = Uri.parse(fileUrl);

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }

    //ScaffoldMessenger.of(context)
    //    .showSnackBar(SnackBar(content: Text('Downloaded ${ref.name}')));
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}
