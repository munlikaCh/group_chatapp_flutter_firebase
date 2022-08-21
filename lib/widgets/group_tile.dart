import 'package:chatapp_firebase/pages/chat_page.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String plandboardId;
  final String planboardName;
  const GroupTile(
      {Key? key,
      required this.plandboardId,
      required this.planboardName,
      required this.userName})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatPage(
              plandboardId: widget.plandboardId,
              planboardName: widget.planboardName,
              userName: widget.userName,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.planboardName.substring(0, 2).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            widget.planboardName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          // subtitle: Text(
          //   "Join the conversation as ${widget.userName}",
          //   style: const TextStyle(fontSize: 13),
          // ),
        ),
      ),
    );
  }
}
