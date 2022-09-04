import 'package:animate_do/animate_do.dart';
import 'package:chatapp_firebase/pages/group_info.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/message_tile.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';
import '../model/task.dart';
import '../utils/colors.dart';
import '../utils/constanst.dart';
import '../utils/strings.dart';
import '../widgets/task_widget.dart';
import 'tasks/task_view.dart';

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

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";

  GlobalKey<SliderDrawerState> dKey = GlobalKey<SliderDrawerState>();

  /// Checking Done Tasks
  int checkDoneTask(List<Task> task) {
    int i = 0;
    for (Task doneTasks in task) {
      if (doneTasks.isCompleted) {
        i++;
      }
    }
    return i;
  }

  /// Checking The Value Of the Circle Indicator
  dynamic valueOfTheIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
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
    final base = BaseWidget.of(context);
    var textTheme = Theme.of(context).textTheme;
    
    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();

          /// Sort Task List
          tasks.sort(((a, b) => a.createdAtDate.compareTo(b.createdAtDate)));

          return Scaffold(
        appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.planboardName),
        backgroundColor: Theme.of(context).primaryColor,
        ),
            backgroundColor: Colors.white,

            /// Floating Action Button
            floatingActionButton: const FAB(),

            /// Body
            body: Container(
              // child: SliderDrawer(
                // isDraggable: false,
                // key: dKey,
                // animationDuration: 1000,

                /// My AppBar
                // appBar: MyAppBar(
                //   drawerKey: dKey,
                // ),

                /// My Drawer Slider
                //slider: MySlider(),

                /// Main Body
                child: _buildBody(
                  tasks,
                  base,
                  textTheme,
                ),
              
            ),
          );
        }

    // return Scaffold(
    //   appBar: AppBar(
    //     centerTitle: true,
    //     elevation: 0,
    //     title: Text(widget.planboardName),
    //     backgroundColor: Theme.of(context).primaryColor,
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         nextScreen(
        //             context,
        //             GroupInfo(
        //               plandboardId: widget.plandboardId,
        //               planboardName: widget.planboardName,
        //               adminName: admin,
        //             ));
        //       },
        //       icon: const Icon(Icons.info))
        // ],
      // ),
      
      //body: 
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
  }

  /// Main Body
  SizedBox _buildBody(
    List<Task> tasks,
    BaseWidget base,
    TextTheme textTheme,
  ) {
    return SizedBox(
      // width: double.infinity,
      // height: double.infinity,
      child: Column(
        children: [
          /// Top Section Of Home page : Text, Progrss Indicator
          Container(
            // margin: const EdgeInsets.fromLTRB(55, 0, 0, 0),
            // width: double.infinity,
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// CircularProgressIndicator
                SizedBox(
                  width: 25,
                  height: 25,
                  // child: CircularProgressIndicator(
                  //   valueColor: const AlwaysStoppedAnimation(MyColors.primaryColor),
                  //   backgroundColor: Colors.grey,
                  //   value: checkDoneTask(tasks) / valueOfTheIndicator(tasks),
                  // ),
                ),
                const SizedBox(
                  width: 25,
                ),

                /// Texts
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(MyString.mainTitle, style: textTheme.headline4),
                    const SizedBox(
                      height: 3,
                    ),
                    Text("${checkDoneTask(tasks)} of ${tasks.length} task",
                        style: textTheme.subtitle1),
                  ],
                )
              ],
            ),
          ),

          /// Divider
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              thickness: 2,
              indent: 0,
            ),
          ),

          //Bottom ListView : Tasks
          SizedBox(
            width: double.infinity,
            height: 400,
            child: tasks.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      var task = tasks[index];

                      return Dismissible(
                        direction: DismissDirection.horizontal,
                        background: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(MyString.deletedTask,
                                style: TextStyle(
                                  color: Colors.grey,
                                ))
                          ],
                        ),
                        onDismissed: (direction) {
                          base.dataStore.dalateTask(task: task);
                        },
                        key: Key(task.id),
                        child: TaskWidget(
                          task: tasks[index],
                        ),
                      );
                    },
                  )

                // if All Tasks Done Show this Widgets
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Lottie
                      // FadeIn(
                      //   child: SizedBox(
                      //     // width: 200,
                      //     // height: 200,
                      //     child: Lottie.asset(
                      //       lottieURL,
                      //       animate: tasks.isNotEmpty ? false : true,
                      //     ),
                      //   ),
                      // ),

                      /// Bottom Texts
                      FadeInUp(
                        from: 30,
                        child: const Text(MyString.doneAllTask),
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}

/// My Drawer Slider
class MySlider extends StatelessWidget {
  MySlider({
    Key? key,
  }) : super(key: key);

  /// Icons
  // List<IconData> icons = [
  //   CupertinoIcons.home,
  //   CupertinoIcons.person_fill,
  //   CupertinoIcons.settings,
  //   CupertinoIcons.info_circle_fill,
  // ];

  /// Texts
  List<String> texts = [
    "Home",
    "Profile",
    "Settings",
    "Details",
  ];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: MyColors.primaryGradientColor,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: Column(
        // children: [
        //   const CircleAvatar(
        //     radius: 50,
        //     backgroundImage: AssetImage('assets/img/main.png'),
        //   ),
        //   const SizedBox(
        //     height: 8,
        //   ),
        //   Text("AmirHossein Bayat", style: textTheme.headline2),
        //   Text("junior flutter dev", style: textTheme.headline3),
        //   Container(
        //     margin: const EdgeInsets.symmetric(
        //       vertical: 30,
        //       horizontal: 10,
        //     ),
        //     width: double.infinity,
        //     height: 300,
        //     child: ListView.builder(
        //         itemCount: icons.length,
        //         physics: const NeverScrollableScrollPhysics(),
        //         itemBuilder: (ctx, i) {
        //           return InkWell(
        //             // ignore: avoid_print
        //             onTap: () => print("$i Selected"),
        //             child: Container(
        //               margin: const EdgeInsets.all(5),
        //               child: ListTile(
        //                   leading: Icon(
        //                     icons[i],
        //                     color: Colors.white,
        //                     size: 30,
        //                   ),
        //                   title: Text(
        //                     texts[i],
        //                     style: const TextStyle(
        //                       color: Colors.white,
        //                     ),
        //                   )),
        //             ),
        //           );
        //         }),
        //   )
        // ],
      ),
    );
  }
}

/// My App Bar
class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  MyAppBar({Key? key, 
    required this.drawerKey,
  }) : super(key: key);
  GlobalKey<SliderDrawerState> drawerKey;

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _MyAppBarState extends State<MyAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// toggle for drawer and icon aniamtion
  void toggle() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        controller.forward();
        widget.drawerKey.currentState!.openSlider();
      } else {
        controller.reverse();
        widget.drawerKey.currentState!.closeSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var base = BaseWidget.of(context).dataStore.box;
    return SizedBox(
      width: double.infinity,
      height: 132,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Animated Icon - Menu & Close
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: controller,
                    size: 40,
                  ),
                  onPressed: toggle),
            ),

            /// Delete Icon
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  base.isEmpty
                      ? warningNoTask(context)
                      : deleteAllTask(context);
                },
                child: const Icon(
                  CupertinoIcons.trash,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating Action Button
class FAB extends StatelessWidget {
  const FAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => TaskView(
              taskControllerForSubtitle: null,
              taskControllerForTitle: null,
              task: null,
            ),
          ),
        );
      },
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 10,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 140, 138),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(
              child: Icon(
            Icons.add,
            color: Colors.white,
          )),
        ),
      ),
    );
  }
}

  // chatMessages() {
  //   return StreamBuilder(
  //     stream: chats,
  //     builder: (context, AsyncSnapshot snapshot) {
  //       return snapshot.hasData
  //           ? ListView.builder(
  //               itemCount: snapshot.data.docs.length,
  //               itemBuilder: (context, index) {
  //                 return MessageTile(
  //                     message: snapshot.data.docs[index]['message'],
  //                     sender: snapshot.data.docs[index]['sender'],
  //                     sentByMe: widget.userName ==
  //                         snapshot.data.docs[index]['sender']);
  //               },
  //             )
  //           : Container();
  //     },
  //   );
  // }

//   sendMessage() {
//     if (messageController.text.isNotEmpty) {
//       Map<String, dynamic> chatMessageMap = {
//         "message": messageController.text,
//         "sender": widget.userName,
//         "time": DateTime.now().millisecondsSinceEpoch,
//       };

//       DatabaseService().sendMessage(widget.plandboardId, chatMessageMap);
//       setState(() {
//         messageController.clear();
//       });
//     }
//   }
// }
