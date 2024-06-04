import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebasetutorial/pages/pdf_viewer_page.dart';

class PDFPage extends StatefulWidget {
  const PDFPage({Key? key}) : super(key: key);

  @override
  _PDFPageState createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  final storageRef = FirebaseStorage.instance.ref();
  final user = FirebaseAuth.instance.currentUser!;
  late Future<ListResult> futureFiles;

  @override
  void initState() {
    super.initState();
    String userId = user.uid;
    futureFiles = FirebaseStorage.instance.ref('/files/$userId').listAll();
  }

  Future<String?> getNomorRMByUserID(String userID) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        return data['nomor RM'] as String?;
      } else {
        return null; // Document not found
      }
    } catch (e) {
      print("Error getting nomorRM: $e");
      return null;
    }
  }

  Future<void> viewFile(BuildContext context, Reference ref) async {
    try {
      // Show the circular progress indicator while loading the PDF
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        barrierDismissible: false,
      );

      final docUrl = await ref.getDownloadURL();

      // Load PDF
      final file = await loadPdfFromNetwork(docUrl);

      // Dismiss the progress indicator dialog
      Navigator.pop(context);

      // Open PDF
      openPdf(context, file, docUrl);
    } catch (error) {
      // Handle error (e.g., show an error message)
      print('Error: $error');
      Navigator.pop(context); // Dismiss the progress indicator dialog
    }
  }

  Future<File> loadPdfFromNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    return _storeFile(url, bytes);
  }

  Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    if (kDebugMode) {
      print('$file');
    }
    return file;
  }

  void openPdf(BuildContext context, File file, String url) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PdfViewerPage(
            file: file,
            url: url,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Hasil',
          style: TextStyle(color: Colors.blueGrey),
        ),
        backgroundColor: Colors.grey[200],
      ),
      body: FutureBuilder<ListResult>(
        future: futureFiles,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final files = snapshot.data!.items;

            return ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index];

                  return GestureDetector(
                    onTap: () => viewFile(context, file),
                    child: ListTile(
                      title: Text(file.name),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error Occurred'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
