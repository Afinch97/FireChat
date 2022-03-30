import 'package:chat_app/providers/conversationProvider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/screens/login/loginScreen.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final fa.User firebaseUser = Provider.of<fa.User>(context);
    return (firebaseUser != null)
        ? ConversationProvider(user: firebaseUser)
        : Login();
  }
}
