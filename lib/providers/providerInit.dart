import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:chat_app/screens/home/homeScreen.dart';

class ProviderInit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<fa.User>.value(
        value: fa.FirebaseAuth.instance.authStateChanges(), child: MaterialApp(
      title: 'Chat Application',
      debugShowCheckedModeBanner: false,
      home: Home(),
    ));
  }
}
