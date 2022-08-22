import 'package:chatapp_firebase/pages/group_info.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/message_tile.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:chatapp_firebase/navigation_drawer.dart';

class ChatPage extends StatefulWidget {
  final String plandboardId;
  final String planboardName;
  final String userName;
  const ChatPage(
      {Key? key,
      required this.plandboardId,
      required this.planboardName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class InnerList {
  final String name;
  List<String> children;
  InnerList({required this.name, required this.children, required Column header});
}

class _ChatPageState extends State<ChatPage> {

  late List<InnerList> _lists;
  
  get index => null;

  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
    _lists = List.generate(3, (outerIndex) {
      return InnerList(
        header: Column(
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 4),
                  child: Text(
                    'Header $index',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
        name: outerIndex.toString(),
        children: 
        List.generate(5, (innerIndex) => '$outerIndex.$innerIndex'),
      );
    });
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.plandboardId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.plandboardId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var backgroundColor = const Color.fromARGB(255, 243, 242, 248);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.planboardName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                      plandboardId: widget.plandboardId,
                      planboardName: widget.planboardName,
                      adminName: admin,
                    ));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      drawer: const NavigationDrawer(),
      body: DragAndDropLists(
        
        children: List.generate(_lists.length, (index) => _buildList(index)),
        onItemReorder: _onItemReorder,
        onListReorder: _onListReorder,
        axis: Axis.horizontal,
        listWidth: 150,
        listDraggingWidth: 150,
        listDecoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(7.0)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black45,
              spreadRadius: 3.0,
              blurRadius: 6.0,
              offset: Offset(2, 3),
            ),
          ],
        ),
        listPadding: const EdgeInsets.all(8.0),
        //add
        itemDivider: Divider(
          thickness: 2,
          height: 2,
          color: backgroundColor,
        ),
        itemDecorationWhileDragging: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        listInnerDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        lastItemTargetHeight: 8,
        addLastItemTargetHeightToTop: true,
        lastListTargetSize: 40,
        listDragHandle: const DragHandle(
          verticalAlignment: DragHandleVerticalAlignment.top,
          child: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.menu,
              color: Colors.black26,
            ),
          ),
        ),
        itemDragHandle: const DragHandle(
          child: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.menu,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),

      // Stack(
      //   children: <Widget>[
      //     // chat messages here
      //     chatMessages(),
      //     Container(
      //       alignment: Alignment.bottomCenter,
      //       width: MediaQuery.of(context).size.width,
      //       child: Container(
      //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      //         width: MediaQuery.of(context).size.width,
      //         color: Colors.grey[700],
      //         child: Row(children: [
      //           Expanded(
      //               child: TextFormField(
      //             controller: messageController,
      //             style: const TextStyle(color: Colors.white),
      //             decoration: const InputDecoration(
      //               hintText: "Send a message...",
      //               hintStyle: TextStyle(color: Colors.white, fontSize: 16),
      //               border: InputBorder.none,
      //             ),
      //           )),
      //           const SizedBox(
      //             width: 12,
      //           ),
      //           GestureDetector(
      //             onTap: () {
      //               sendMessage();
      //             },
      //             child: Container(
      //               height: 50,
      //               width: 50,
      //               decoration: BoxDecoration(
      //                 color: Theme.of(context).primaryColor,
      //                 borderRadius: BorderRadius.circular(30),
      //               ),
      //               child: const Center(
      //                   child: Icon(
      //                 Icons.send,
      //                 color: Colors.white,
      //               )),
      //             ),
      //           )
      //         ]),
      //       ),
      //     )
      //   ],
      // ),
    );
  

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.userName ==
                          snapshot.data.docs[index]['sender']);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.plandboardId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}

 _buildList(int outerIndex) {
    var innerList = _lists[outerIndex];
    return DragAndDropList(
      header: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(7.0)),
                color: Colors.pink,
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                'Header ${innerList.name}',
                style: Theme.of(context).primaryTextTheme.headline6,
              ),
            ),
          ),
        ],
      ),
      // footer: Row(
      //   children: <Widget>[
      //     Expanded(
      //       child: Container(
      //         decoration: const BoxDecoration(
      //           borderRadius:
      //               BorderRadius.vertical(bottom: Radius.circular(7.0)),
      //           color: Colors.pink,
      //         ),
      //         padding: const EdgeInsets.all(10),
      //         child: Text(
      //           'Footer ${innerList.name}',
      //           style: Theme.of(context).primaryTextTheme.headline6,
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      leftSide: const VerticalDivider(
        color: Colors.pink,
        width: 1.5,
        thickness: 1.5,
      ),
      rightSide: const VerticalDivider(
        color: Colors.pink,
        width: 1.5,
        thickness: 1.5,
      ),
      children: List.generate(innerList.children.length,
          (index) => _buildItem(innerList.children[index])),
    );
  }

  _buildItem(String item) {
    return DragAndDropItem(
      child: ListTile(
        title: Text(item),
      ),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _lists[oldListIndex].children.removeAt(oldItemIndex);
      _lists[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _lists.removeAt(oldListIndex);
      _lists.insert(newListIndex, movedList);
    });
  }
}
