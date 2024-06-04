// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  PlatformFile? _selectedFile;
  final user = FirebaseAuth.instance.currentUser!;
  final _nomorRMController = TextEditingController();
  final _hasil_gulaController = TextEditingController();
  final _hasil_cholController = TextEditingController();
  final _hasil_trigController = TextEditingController();

  Future<String?> getUserIDByNomorRM(String nomorRM) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(nomorRM)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        return data['userID'] as String?;
      } else {
        return null; // Document not found
      }
    } catch (e) {
      print("Error getting userID: $e");
      return null;
    }
  }

  Future<void> uploadHasilGula(
      BuildContext context, String nomorRM, double hasil) async {
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);

      // Check if the document exists
      bool documentExists = await FirebaseFirestore.instance
          .collection('users')
          .doc(nomorRM)
          .collection('hasil_tes')
          .doc('hasil_gula')
          .get()
          .then((docSnapshot) => docSnapshot.exists);

      if (documentExists) {
        // If the document exists, update it
        await FirebaseFirestore.instance
            .collection('users')
            .doc(nomorRM)
            .collection('hasil_tes')
            .doc('hasil_gula')
            .update({
          '$formattedDate': hasil,
        });
      } else {
        // If the document doesn't exist, set it
        await FirebaseFirestore.instance
            .collection('users')
            .doc(nomorRM)
            .collection('hasil_tes')
            .doc('hasil_gula')
            .set({
          '$formattedDate': hasil,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hasil Gula uploaded successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading hasil gula: $e'),
        ),
      );
    }
  }

  Future<void> uploadHasilChol(
      BuildContext context, String nomorRM, double hasil) async {
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);

      // Check if the document exists
      bool documentExists = await FirebaseFirestore.instance
          .collection('users')
          .doc(nomorRM)
          .collection('hasil_tes')
          .doc('hasil_cholesterol')
          .get()
          .then((docSnapshot) => docSnapshot.exists);

      if (documentExists) {
        // If the document exists, update it
        await FirebaseFirestore.instance
            .collection('users')
            .doc(nomorRM)
            .collection('hasil_tes')
            .doc('hasil_cholesterol')
            .update({
          '$formattedDate': hasil,
        });
      } else {
        // If the document doesn't exist, set it
        await FirebaseFirestore.instance
            .collection('users')
            .doc(nomorRM)
            .collection('hasil_tes')
            .doc('hasil_cholesterol')
            .set({
          '$formattedDate': hasil,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hasil Cholesterol uploaded successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading hasil cholesterol: $e'),
        ),
      );
    }
  }

  Future<void> uploadHasilTrigliserida(
      BuildContext context, String nomorRM, double hasil) async {
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);

      // Check if the document exists
      bool documentExists = await FirebaseFirestore.instance
          .collection('users')
          .doc(nomorRM)
          .collection('hasil_tes')
          .doc('hasil_trigliserida')
          .get()
          .then((docSnapshot) => docSnapshot.exists);

      if (documentExists) {
        // If the document exists, update it
        await FirebaseFirestore.instance
            .collection('users')
            .doc(nomorRM)
            .collection('hasil_tes')
            .doc('hasil_trigliserida')
            .update({
          '$formattedDate': hasil,
        });
      } else {
        // If the document doesn't exist, set it
        await FirebaseFirestore.instance
            .collection('users')
            .doc(nomorRM)
            .collection('hasil_tes')
            .doc('hasil_trigliserida')
            .set({
          '$formattedDate': hasil,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hasil Trigliserida uploaded successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading hasil trigliserida: $e'),
        ),
      );
    }
  }

  Future<void> _pickFile() async {
    try {
      // File picking for web
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.first;
        });
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile != null) {
      try {
        String nomorRM = _nomorRMController.text.trim();
        String? userId = await getUserIDByNomorRM(nomorRM);

        if (userId != null) {
          String fileName = _selectedFile!.name;

          Reference storageReference =
              FirebaseStorage.instance.ref().child('files/$userId/$fileName');

          Uint8List fileBytes = _selectedFile!.bytes as Uint8List;

          await storageReference.putData(fileBytes);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File uploaded successfully!'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: NomorRM not found for the current user.'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading file: $e'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a PDF file first.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nomorRMController.dispose();
    _hasil_trigController.dispose();
    _hasil_cholController.dispose();
    _hasil_gulaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //String userId = user.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          'Upload Hasil Tes Laboratorium',
          style: TextStyle(color: Colors.blueGrey),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _selectedFile != null
                  ? Text('Selected File: ${_selectedFile!.name}')
                  : Text('No file selected'),
              SizedBox(
                height: 20,
              ),

              // File Picker Button
              GestureDetector(
                onTap: () {
                  _pickFile();
                },
                child: Container(
                  width: 200,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      'Pilih file untuk diupload',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Text("Masukkan Nomor RM"),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  width: 750, // Set the width
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _nomorRMController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'NomorRM',
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              // File Upload Button
              GestureDetector(
                onTap: () {
                  _uploadFile();
                },
                child: Container(
                  width: 200,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      'Upload file',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              // Row hasil
              Container(
                width: 750,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _hasil_gulaController,
                        decoration: InputDecoration(
                          labelText: 'Hasil Gula',
                        ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: _hasil_cholController,
                        decoration: InputDecoration(
                          labelText: 'Hasil Cholesterol',
                        ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: _hasil_trigController,
                        decoration: InputDecoration(
                          labelText: 'Hasil Trigliserida',
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),

              // Row hasil
              Container(
                width: 750,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Upload Hasil Gula
                    GestureDetector(
                      onTap: () {
                        uploadHasilGula(
                          context,
                          _nomorRMController.text.trim(),
                          double.parse(_hasil_gulaController.text.trim()),
                        );
                      },
                      child: Container(
                        width: 200,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            'Upload hasil gula',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 15,
                    ),

                    // Upload Hasil Cholesterol
                    GestureDetector(
                      onTap: () {
                        uploadHasilChol(
                          context,
                          _nomorRMController.text.trim(),
                          double.parse(_hasil_cholController.text.trim()),
                        );
                      },
                      child: Container(
                        width: 200,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            'Upload hasil cholesterol',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 15,
                    ),

                    // Upload Hasil Trigliserida
                    GestureDetector(
                      onTap: () {
                        uploadHasilTrigliserida(
                          context,
                          _nomorRMController.text.trim(),
                          double.parse(_hasil_trigController.text.trim()),
                        );
                      },
                      child: Container(
                        width: 200,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            'Upload hasil trigliserida',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
