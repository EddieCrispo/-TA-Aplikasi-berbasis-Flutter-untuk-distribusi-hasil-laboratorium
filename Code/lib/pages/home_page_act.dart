// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetutorial/read%20data/get_first_name.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebasetutorial/util/category_card.dart';
//import 'package:firebasetutorial/util/doctor_card.dart';

class HomePageAct extends StatefulWidget {
  const HomePageAct({super.key});

  @override
  State<HomePageAct> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageAct> {
  final user = FirebaseAuth.instance.currentUser!;

  // Document IDs
  List<String> docIDs = [];

  // Get docIDs
  getDocId() async {
    await FirebaseFirestore.instance.collection('users').get().then(
          (snapshot) => snapshot.docs.forEach((document) {
            print(document.reference);
            docIDs.add(document.reference.id);
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(children: [
          // App Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      'Hello,',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    // First Name
                    GetFirstName(userId: user.uid),
                    GestureDetector(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: Icon(Icons.logout),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 25),

          // Card -> How do you feel?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.pink[100],
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  // animation or cute picture
                  Container(
                    height: 100,
                    width: 100,
                    child: Lottie.asset('lib/icons/doc_anim.json'),
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
                          'How do you feel?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Fill out your medical card right now',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.deepPurple[300],
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: Text(
                                'Get Started',
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
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

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                  borderRadius: BorderRadius.circular(12)),
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    hintText: 'How can we help you?'),
              ),
            ),
          ),

          SizedBox(
            height: 25,
          ),

          // Horizontal listview -> Categories
          Container(
            height: 80,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              CategoryCard(
                  CategoryName: 'Results',
                  iconImagePath: 'lib/icons/hospital.png'),
              CategoryCard(
                  CategoryName: 'Reports',
                  iconImagePath: 'lib/icons/document.png'),
              CategoryCard(
                  CategoryName: 'Graph', iconImagePath: 'lib/icons/chart.png')
            ]),
          ),

          SizedBox(
            height: 25,
          ),
        ])),
      ),
    );
  }
}
