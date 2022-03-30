import 'package:chat_app/models/convo.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/providers/newMessageProvider.dart';
import 'package:chat_app/screens/messaging/widgets/convoWidget.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:flutter/material.dart';
import 'package:chat_app/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/screens/chatPage.dart';

class HomeBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fa.User firebaseUser = Provider.of<fa.User>(context);
    final List<Convo> _convos = Provider.of<List<Convo>>(context);
    final List<User> _users = Provider.of<List<User>>(context);

    return Scaffold(
      body: ChatPage(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () => createNewConvo(context),
                icon: Icon(Icons.add, size: 30)),
            label: "Add Convo",
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                icon: Icon(Icons.logout),
                onPressed: Authentication.handleLogout),
            label: "Logout",
          ),
        ],
      ),
    );
  }

  void createNewConvo(BuildContext context) {
    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => NewMessageProvider()));
  }

  Map<String, User> getUserMap(List<User> users) {
    final Map<String, User> userMap = Map();
    for (User u in users) {
      userMap[u.id] = u;
    }
    return userMap;
  }

  List<Widget> getWidgets(BuildContext context, fa.User user,
      List<Convo> _convos, List<User> _users) {
    final List<Widget> list = <Widget>[];
    if (_convos != null && _users != null && user != null) {
      final Map<String, User> userMap = getUserMap(_users);

      for (Convo c in _convos) {
        if (c.userIds[0] == user.uid) {
          list.add(ConvoListItem(
              user: user,
              peer: userMap[c.userIds[1]],
              lastMessage: c.lastMessage));
        } else {
          list.add(ConvoListItem(
              user: user,
              peer: userMap[c.userIds[0]],
              lastMessage: c.lastMessage));
        }
      }
    }

    return list;
  }
}
