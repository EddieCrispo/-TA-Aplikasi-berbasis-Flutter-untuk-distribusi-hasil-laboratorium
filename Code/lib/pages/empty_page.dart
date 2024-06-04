import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Page"),
      ),
      body: Center(
        child: ElevatedButton(
            child: Text("Login"),
            onPressed: () {
              Navigator.pushNamed(context, '/homepage');
            }),
      ),
    );
  }
}
