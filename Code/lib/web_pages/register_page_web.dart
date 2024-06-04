// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPageWeb extends StatefulWidget {
  final VoidCallback showLoginPageWeb;
  const RegisterPageWeb({Key? key, required this.showLoginPageWeb})
      : super(key: key);

  @override
  State<RegisterPageWeb> createState() => _RegisterPageWebState();
}

class _RegisterPageWebState extends State<RegisterPageWeb> {
  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _adminIDController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _nameController.dispose();
    _adminIDController.dispose();
    super.dispose();
  }

  Future signUp() async {
    // Authenticate User
    if (passwordConfirmed()) {
      try {
        // Create user
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Get the user ID
        String userId = userCredential.user!.uid;

        // Add user details using the user ID
        await addUserDetails(
          userId,
          _nameController.text.trim(),
          _emailController.text.trim(),
          _adminIDController.text.trim(),
        );
      } catch (error) {
        // Handle registration errors
        showRegistrationErrorDialog(error.toString());
      }
    }
  }

  void showRegistrationErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Registration Failed"),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future addUserDetails(
    String userId,
    String name,
    String email,
    String adminID,
  ) async {
    await FirebaseFirestore.instance.collection('admins').doc(adminID).set({
      'userID': userId,
      'name': name,
      'email': email,
      'admin ID': adminID,
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 125.0,
                    width: 225,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/images/logo_rsud.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  // Hello Again!
                  Text(
                    'REGISTER ADMIN LAB',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 52,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Register below with your details',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  SizedBox(height: 30),

                  // Name Textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'First Name',
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Admin ID Textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _adminIDController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'ID Admin',
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Email Textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Password Textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Confirm Password Textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _confirmpasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Confim Password',
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Sign-in Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: GestureDetector(
                      onTap: signUp,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[400],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 25),

                  // Not a member? Register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.showLoginPageWeb,
                        child: Text(
                          ' Login now',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
