import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetFirstName extends StatelessWidget {
  final String userId;

  GetFirstName({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getFirstName(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Text('${snapshot.data}');
        }
      },
    );
  }

  Future<String> getFirstName(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userID', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['first name'];
      } else {
        return 'User not found';
      }
    } catch (e) {
      print('Error getting first name: $e');
      return 'Error';
    }
  }
}
