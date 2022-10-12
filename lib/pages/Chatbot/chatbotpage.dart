
import 'package:chatapp_firebase/widgets/Messages.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class Chatbotpage extends StatefulWidget {
  const Chatbotpage({Key? key}) : super(key: key);

  @override
  State<Chatbotpage> createState() => _ChatbotpageState();
}

class _ChatbotpageState extends State<Chatbotpage> {
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
      appBar: AppBar(
        backgroundColor: Color(0xff8FCACA),
        elevation: 0,
        title: Text('Bearlance bot',
        style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
              fontFamily: 'UbuntuRegular'),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: MessagesScreen(messages: messages)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: Color(0xff8FCACA),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.black),
                  )),
                  IconButton(
                      onPressed: () {
                        sendMessage(_controller.text);
                        _controller.clear();
                      },
                      icon: Icon(Icons.send,
                      color: Colors.white,))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         centerTitle: true,
  //         elevation: 0,
  //         backgroundColor: Theme.of(context).primaryColor,
  //         title: Text(
  //           "Bearlance bot",
  //           style: TextStyle(
  //               fontSize: 27,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white,
  //               fontFamily: 'UbuntuRegular'),
  //         ),
  //       ),
  //       body: Container(
  //         alignment: Alignment.bottomCenter,
  //         width: MediaQuery.of(context).size.width,
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
  //           width: MediaQuery.of(context).size.width,
  //           color: Color.fromARGB(255, 152, 19, 19),
  //           child: Row(children: [
  //             Expanded(
  //                 child: MessagesScreen(messages: messages
  //                     // ,
  //                     // style: const TextStyle(color: Colors.white),
  //                     // decoration: const InputDecoration(
  //                     //   hintText: "Send a message...",
  //                     //   hintStyle: TextStyle(color: Colors.white, fontSize: 16),
  //                     //   border: InputBorder.none,
  //                     // ),
  //                     )),
  //             Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  //               color: Colors.deepPurple,
  //               child: Row(
  //                 children: [
  //                   Expanded(
  //                       child: TextField(
  //                     controller: _controller,
  //                     style: TextStyle(color: Colors.white),
  //                   )),
  //                   IconButton(
  //                       onPressed: () {
  //                         sendMessage(_controller.text);
  //                         _controller.clear();
  //                       },
  //                       icon: Icon(Icons.send))
  //                 ],
  //               ),
  //             )
  //           ]),
  //         ),
  //       ));
  // }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}
