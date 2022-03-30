import 'package:chat_app/services/database.dart';
import 'package:chat_app/shared.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/messaging/widgets/loading.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/services.dart';

//import '../widgets/loading.dart';

class PostForm extends StatefulWidget {
  const PostForm({
    Key key,
    this.contact,
  }) : super(key: key);
  final User contact;
  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  var loading = false;
  var message = TextEditingController();
  final Database db = Database();
  User contact;
  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: message,
                showCursor: true,
                minLines: 4,
                maxLines: 10,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Rate this convo (1-5)",
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
                  child: const Text("Post Message")),
              verticalSpaceLarge
            ],
          );
  }

  void postMessage() async {
    var post = message.text.trim();
    var value = int.tryParse(post);
    if (value != null) {
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
