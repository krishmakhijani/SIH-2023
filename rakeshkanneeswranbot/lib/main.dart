import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:rakeshkanneeswranbot/messages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: "SRM's Bharat AI",
      theme: ThemeData(brightness: Brightness.light),
      home: Home(),
    );
    ;
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];
  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SRM's Bharat AI",textScaleFactor: 1.5,)),
      body: Container(
        child: Column(
          children: [Expanded(child: Text("From SRM's Indigenous Innovators",textScaleFactor: 1.2)),
            Expanded(child: MessagesScreen(messages: messages)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: Colors.blue,
              child: Row(
                children: [
                  Expanded(
                      child: TextField(showCursor: true,
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                  )),
                  IconButton(
                      onPressed: () {
                        sendMessages(_controller.text);
                        _controller.clear();
                      },
                      icon: Icon(Icons.send),color: Colors.white,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void sendMessages(String text) async {
    if (text.isEmpty) {
      print("empty message");
    } else {
      setState(() {
        addmessage(Message(text: DialogText(text: [text])), true);
      });
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null)
        return;
      else {
        setState(() {
          addmessage(response.message!);
        });
      }
    }
  }

  void addmessage(Message message, [bool isUserMessage = false]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }
}
