// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetutorial/line%20graph/line_graph.dart';
import 'package:flutter/material.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({Key? key}) : super(key: key);

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  final user = FirebaseAuth.instance.currentUser;

  Future<String?> getNomorRM(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userID', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['nomor RM'] as String?;
      } else {
        return null; // User not found
      }
    } catch (e) {
      print('Error getting nomor RM: $e');
      return null; // Error
    }
  }

  // Function to build FutureBuilder with inner document ID
  FutureBuilder<DocumentSnapshot> buildGraphFuture(
    String outerDocumentId,
    String innerDocumentId,
    double rangeMin,
    double rangeMax,
    double yMin,
    double yMax,
  ) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(outerDocumentId)
          .collection('hasil_tes')
          .doc(innerDocumentId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        Map<String, dynamic>? hasilTestData =
            snapshot.data?.data() as Map<String, dynamic>?;

        List<double> testsSummary = [];

        if (hasilTestData != null) {
          // Sort the keys in ascending order
          List<String> sortedKeys = hasilTestData.keys.toList()..sort();

          // Process the sorted keys
          sortedKeys.forEach((key) {
            var value = hasilTestData[key];
            if (value is int) {
              testsSummary.add(value.toDouble());
            } else if (value is double) {
              testsSummary.add(value);
            }
          });
        }

        return _buildGraph(testsSummary, 'Grafik untuk $innerDocumentId',
            rangeMin, rangeMax, yMin, yMax);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          'Grafik Hasil Pemeriksaan',
          style: TextStyle(color: Colors.blueGrey),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<String?>(
            // Fetch outerDocumentId before proceeding with Firestore query
            future: getNomorRM(user!.uid),
            builder: (context, outerDocIdSnapshot) {
              if (outerDocIdSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (outerDocIdSnapshot.hasError) {
                return Text('Error: ${outerDocIdSnapshot.error}');
              }

              String? outerDocumentId = outerDocIdSnapshot.data;

              if (outerDocumentId == null) {
                return Text('Outer document ID not found.');
              }

              //String innerDocumentId = 'hasil_gula';

              return Column(
                children: [
                  buildGraphFuture(
                      outerDocumentId, 'hasil_gula', 80, 170, 50, 200),
                  buildGraphFuture(
                      outerDocumentId, 'hasil_cholesterol', 0, 180, 0, 250),
                  buildGraphFuture(
                      outerDocumentId, 'hasil_trigliserida', 0, 150, 0, 200),
                  // Add more graphs as needed
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGraph(
    List<double> data,
    String graphTitle,
    double minRange,
    double maxRange,
    double yMin,
    double yMax,
  ) {
    // Ensure that only the last 5 elements are used
    List<double> lastFiveValues =
        data.length > 5 ? data.sublist(data.length - 5) : data;
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Adjust the border color as needed
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            graphTitle,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 300,
            child: MyLineGraph(
              testsSummary: lastFiveValues,
              minRange: minRange,
              maxRange: maxRange,
              yMin: yMin,
              yMax: yMax,
            ),
          ),
        ],
      ),
    );
  }
}
