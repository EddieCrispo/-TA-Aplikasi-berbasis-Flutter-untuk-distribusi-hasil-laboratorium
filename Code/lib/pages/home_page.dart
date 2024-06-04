// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:firebasetutorial/pages/graph_page.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasetutorial/pages/pdf_page.dart';
import 'package:firebasetutorial/read%20data/get_first_name.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebasetutorial/pages/pdf_viewer_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final storageRef = FirebaseStorage.instance.ref();

  late Future<ListResult> filesList;

  @override
  void initState() {
    super.initState();
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

  Future<void> viewFile(BuildContext context, String userId) async {
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

      ListResult result =
          await FirebaseStorage.instance.ref('/files/$userId').listAll();
      List<Reference> filesList = result.items;
      final files = filesList.last;

      final docUrl = await files.getDownloadURL();

      // Load PDF after getting download URL
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[200],
        title: FutureBuilder<String>(
          future: GetFirstName(userId: user.uid).getFirstName(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blueGrey,
                ),
              );
            } else {
              return Text(
                'Halo, ${snapshot.data}',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blueGrey,
                ),
              );
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.,
          children: [
            SizedBox(
              height: 25,
            ),
            // Card -> How do you feel?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    // Gambar ilustrasi
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(
                        Icons.assignment,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(
                      width: 20,
                    ),

                    // how do you feel + get started button
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bagaimana kabarmu?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Tampilkan Hasil Laboratorium Terbaru',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          GestureDetector(
                            onTap: () async {
                              String userId = user.uid;
                              await viewFile(context, userId);
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey[300],
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Text(
                                  'Hasil Terbaru',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 25,
            ),

            // Doctor list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menu Lainnya',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey[500]),
                  )
                ],
              ),
            ),

            SizedBox(
              height: 25,
            ),

            // Riwayat Hasil Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PDFPage()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[100],
                      borderRadius: BorderRadius.circular(22)),
                  child: Row(
                    children: [
                      // Gambar ilustrasi
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey[300],
                            borderRadius: BorderRadius.circular(12)),
                        child: Icon(
                          Icons.recent_actors,
                          size: 75,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(
                        width: 20,
                      ),

                      // Teks Hasil terbaru
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Riwayat Pemeriksaan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Tampilkan Riwayat Hasil Laboratorium',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 25,
            ),

            // Graph Hasil Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GraphPage()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[100],
                      borderRadius: BorderRadius.circular(22)),
                  child: Row(
                    children: [
                      // Gambar ilustrasi
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey[300],
                            borderRadius: BorderRadius.circular(12)),
                        child: Icon(
                          Icons.stacked_line_chart,
                          size: 75,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(
                        width: 20,
                      ),

                      // Teks Hasil terbaru
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Graph Pemeriksaan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Tampilkan Graph dari 5 Hasil Laboratorium Terakhir',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
