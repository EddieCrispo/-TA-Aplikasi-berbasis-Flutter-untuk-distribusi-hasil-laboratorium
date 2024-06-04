// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetutorial/web_pages/upload_page.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePageWeb extends StatefulWidget {
  const HomePageWeb({super.key});

  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  final user = FirebaseAuth.instance.currentUser!;
  final storageRef = FirebaseStorage.instance.ref();

  late Future<ListResult> filesList;

  @override
  void initState() {
    super.initState();
  }

  Future<String> getAdminID(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('admins')
          .where('userID', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['admin ID'];
      } else {
        return 'User not found';
      }
    } catch (e) {
      print('Error getting admin ID: $e');
      return 'Error';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[200],
        title: FutureBuilder<String>(
          future: getAdminID(user.uid),
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
                'ID Admin yang login: ${snapshot.data}',
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
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
            ),

            // Menu Lainnya
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

            // Upload Hasil Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadPage()),
                    );
                  },
                  child: Container(
                    width: 400,
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
                            Icons.upload_file,
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
                                'Upload Hasil',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Upload Hasil Laboratorium',
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
            ),
          ],
        ),
      ),
    );
  }
}
