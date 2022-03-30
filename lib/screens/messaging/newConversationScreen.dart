import 'package:bubble/bubble.dart';
import 'package:chat_app/providers/conversationProvider.dart';
import 'package:chat_app/screens/home/homeBuilder.dart';
import 'package:chat_app/screens/home/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/services.dart';
import 'package:chat_app/forms/ratingform.dart';
import 'package:chat_app/shared.dart';
import 'package:chat_app/screens/messaging/widgets/loading.dart';

class NewConversationScreen extends StatelessWidget {
  //final TextEditingController _controller = TextEditingController();
  NewConversationScreen(
      {@required this.uid, @required this.contact, @required this.convoID});
  final String uid, convoID;
  final User contact;
  final TextEditingController _controller = TextEditingController();
  final Database db = Database();
  final TextEditingController rating = TextEditingController();
  setState() {
    contact.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "<https://randomuser.me/api/portraits/men/5.jpg>"),
                    maxRadius: 20,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          contact.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'Rating:${contact.rating.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: ChatScreen(uid: uid, convoID: convoID, contact: contact));
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {@required this.uid, @required this.convoID, @required this.contact});
  final String uid, convoID;
  final User contact;
  setState() {
    contact.rating;
  }

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String uid, convoID;
  User contact;
  List<DocumentSnapshot> listMessage;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final TextEditingController rated = TextEditingController();
  final Database db = Database();
  var loading = false;
  @override
  void initState() {
    super.initState();
    uid = widget.uid;
    convoID = widget.convoID;
    contact = widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              buildMessages(),
              buildInput(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInput() {
    //var _rating = TextEditingController();
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                ratingPoppy();
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            FloatingActionButton(
              onPressed: () => onSendMessage(textEditingController.text),
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              backgroundColor: Colors.blue,
              elevation: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessages() {
    return Flexible(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(convoID)
            .collection(convoID)
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            listMessage = snapshot.data.docs;
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) =>
                  buildItem(index, snapshot.data.docs[index]),
              itemCount: snapshot.data.docs.length,
              reverse: true,
              controller: listScrollController,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (!document.get('read') && document.get('idTo') == uid) {
      Database.updateMessageRead(document, convoID);
    }

    if (document.get('idFrom') == uid) {
      // Right (my message)
      return Row(
        children: <Widget>[
          // Text
          Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Bubble(
                  color: Colors.blue[200],
                  elevation: 0,
                  padding: const BubbleEdges.all(10.0),
                  nip: BubbleNip.rightTop,
                  child: Text(
                    document.get('content').toString(),
                  )),
              width: 200)
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Container(
                child: Bubble(
                    color: Colors.grey.shade300,
                    elevation: 0,
                    padding: const BubbleEdges.all(10.0),
                    nip: BubbleNip.leftTop,
                    child: Text(
                      document.get('content').toString(),
                    )),
                width: 200.0,
                margin: const EdgeInsets.only(left: 10.0),
              )
            ])
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  void onSendMessage(String content) {
    if (content.trim() != '') {
      textEditingController.clear();
      content = content.trim();
      Database.sendMessage(convoID, uid, contact.id, content,
          DateTime.now().millisecondsSinceEpoch.toString());
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Future ratingPoppy() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Rate this convo (1-5)'),
            content: TextField(
              maxLength: 1,
              autofocus: true,
              decoration: InputDecoration(hintText: 'Enter rating'),
              controller: rated,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[1-5]{1}'))
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      postMessage();
                    });
                  },
                  child: const Text("Post Rating")),
            ],
          ));

  void ratingPopUp() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return const Padding(padding: EdgeInsets.all(30.0), child: null);
        });
  }

  Widget rateForm(BuildContext context) {
    return loading
        ? const Loading()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: rated,
                showCursor: true,
                minLines: 4,
                maxLines: 10,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Rate this convo (1-5)',
                    hintText:
                        'Enter what you wish to rate who you are chatting with'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[1-5]{1}'))
                ],
              ),
              verticalSpaceSmall,
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      loading = true;
                      postMessage();
                    });
                  },
                  child: const Text("Post Rating")),
              verticalSpaceLarge
            ],
          );
  }

  void postMessage() async {
    var post = rated.text.trim();
    var value = int.tryParse(post);
    if (post.isNotEmpty) {
      await db.updateRating(
          contact.id, value, contact.rating, contact.rate_length);
      snackBar(context, "Rating successfully added.");
      Navigator.of(context).pop();
    } else {
      snackBar(context, "Rating not formated properly.");
      setState(() {
        loading = false;
      });
    }
  }
}
