import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/controllers/agents_provider.dart';
import 'package:jobhubv2_0/controllers/chat_provider.dart';
import 'package:jobhubv2_0/controllers/login_provider.dart';
import 'package:jobhubv2_0/controllers/zoom_provider.dart';
import 'package:jobhubv2_0/models/request/agents/agents.dart';
import 'package:jobhubv2_0/utils/date.dart';
import 'package:jobhubv2_0/views/common/drawer/drawer_widget.dart';
import 'package:jobhubv2_0/views/common/exports.dart';
import 'package:jobhubv2_0/views/common/loader.dart';
import 'package:jobhubv2_0/views/ui/agent/agent_page.dart';
import 'package:jobhubv2_0/views/ui/auth/NonUser.dart';
import 'package:jobhubv2_0/views/ui/chat/chat_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({super.key});

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> with TickerProviderStateMixin {
  late TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );

  String imageUrl =
      'https://ui-avatars.com/api/?name=Chat&background=0D8ABC&color=fff&size=128';

  @override
  void initState() {
    super.initState();
    // Start fetching chats when the widget is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatNotifier = Provider.of<ChatNotifier>(context, listen: false);
      chatNotifier.fetchChatRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    var chatNotifier = Provider.of<ChatNotifier>(context);
    bool loggedIn = loginNotifier.loggedIn;
    chatNotifier.onlineStatus(loggedIn, zoomNotifier);

    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: const Color(0xFF171717),
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(12.0),
          child: DrawerWidget(
            color: Colors.white,
          ),
        ),
        title: loggedIn == false
            ? SizedBox.fromSize()
            : TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0x00BABABA),
                  borderRadius: BorderRadius.circular(25),
                ),
                labelColor: Colors.white,
                padding: const EdgeInsets.all(3),
                labelStyle: appStyle(12, Colors.white, FontWeight.w500),
                unselectedLabelColor: Colors.grey.withOpacity(0.5),
                tabs: const [
                    Tab(
                      text: "MESSAGES",
                    ),
                    Tab(
                      text: "ONLINE",
                    ),
                    Tab(
                      text: "GROUPS",
                    ),
                  ]),
      ),
      body: loggedIn == false
          ? const NonUser()
          : TabBarView(
              controller: _tabController,
              children: [
                Stack(
                  children: [
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding:
                            const EdgeInsets.only(top: 15, left: 25, right: 0),
                        height: 220,
                        decoration: const BoxDecoration(
                            color: Color(0xFF3281E3),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ReusableText(
                                  text: "Agencies and Companies",
                                  style: appStyle(
                                      12, Colors.white, FontWeight.normal),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      AntDesign.ellipsis1,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                            Consumer<AgentsNotifier>(
                              builder: (context, agentsNotifier, child) {
                                var agents = agentsNotifier.getAgents();
                                return FutureBuilder<List<Agents>>(
                                    future: agents,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SizedBox(
                                          height: 90,
                                          child: ListView.builder(
                                              itemCount: 7,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return buildContactAvatar(
                                                    'Agent ${index}', imageUrl);
                                              }),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text("Error ${snapshot.error}");
                                      } else {
                                        return SizedBox(
                                          height: 90,
                                          child: ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              var agent = snapshot.data![index];
                                              return Consumer<AgentsNotifier>(
                                                  builder: (context,
                                                      agentsNotifier, child) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    agentsNotifier.agent =
                                                        agent;
                                                    Get.to(() =>
                                                        const AgentDetails());
                                                  },
                                                  child: buildContactAvatar(
                                                      agent.username,
                                                      agent.profile),
                                                );
                                              });
                                            },
                                          ),
                                        );
                                      }
                                    });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 180,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Color(0xFFEFFFFC),
                        ),
                        child: Consumer<ChatNotifier>(
                          builder: (context, chatNotifier, child) {
                            if (chatNotifier.isLoading && chatNotifier.chatRooms.isEmpty) {
                              return Center(
                                child: Image.asset('assets/images/loader.gif'),
                              );
                            }

                            if (chatNotifier.error.isNotEmpty && chatNotifier.chatRooms.isEmpty) {
                              return Center(
                                child: Text(
                                  'Error loading chats',
                                  style: appStyle(14, Colors.red, FontWeight.normal),
                                ),
                              );
                            }

                            if (chatNotifier.chatRooms.isEmpty) {
                              return const NoSearchResults(
                                text: 'Apply For Jobs To View Chats',
                              );
                            }

                            final chatList = chatNotifier.chatRooms;
                            return ListView.builder(
                                itemCount: chatList.length,
                                padding: const EdgeInsets.only(left: 25),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  final chat = chatList[index] as Map<String, dynamic>;
                                  
                                  // Parse lastMessageTime
                                  DateTime lastChatDateTime;
                                  try {
                                    if (chat['lastMessageTime'] is String) {
                                      lastChatDateTime = DateTime.parse(chat['lastMessageTime']);
                                    } else {
                                      lastChatDateTime = DateTime.now();
                                    }
                                  } catch (e) {
                                    lastChatDateTime = DateTime.now();
                                  }

                                  // Get the other participant's info
                                  final participants = chat['participants'] as List<dynamic>? ?? [];
                                  String displayName = 'Unknown';
                                  String displayProfile = '';
                                  
                                  for (var participant in participants) {
                                    if (participant['userId'] != userUid) {
                                      displayName = participant['username'] ?? 'Unknown';
                                      displayProfile = participant['profile'] ?? '';
                                      break;
                                    }
                                  }

                                  // Check if there are unread messages
                                  final unreadCount = chat['unreadCount'] is Map 
                                      ? (chat['unreadCount'][userUid] ?? 0)
                                      : 0;

                                  return Consumer<AgentsNotifier>(
                                    builder: (context, agentsNotifier, child) {
                                      return GestureDetector(
                                        onTap: () {
                                          // Mark as read when opening
                                          if (chat['sender'] != userUid) {
                                            chatNotifier.markAsRead(chat['chatRoomId']);
                                          }
                                          final enrichedChat = Map<String, dynamic>.from(chat);
                                          enrichedChat['job'] ??= {
                                            'company': displayName,
                                            'title': 'Chat',
                                            'salary': '',
                                            'image_url': displayProfile,
                                          };
                                          agentsNotifier.chat = enrichedChat;
                                          Get.to(() => const ChatPage());
                                        },
                                        child: buildConversationRow(
                                            displayName,
                                            chat['lastMessage'] ?? '',
                                            displayProfile,
                                            unreadCount,
                                            lastChatDateTime),
                                      );
                                    },
                                  );
                                });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding:
                            const EdgeInsets.only(top: 15, left: 25, right: 0),
                        height: 220,
                        decoration: const BoxDecoration(
                            color: Color(0xFF3281E3),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ReusableText(
                                  text: "Agencies and Companies",
                                  style: appStyle(12, Colors.white, FontWeight.normal),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.more_horiz,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                            Consumer<AgentsNotifier>(
                              builder: (context, agentsNotifier, child) {
                                var agents = agentsNotifier.getAgents();
                                return FutureBuilder<List<Agents>>(
                                    future: agents,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SizedBox(
                                          height: 90,
                                          child: ListView.builder(
                                              itemCount: 7,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return buildContactAvatar(
                                                    'Agent ${index}', imageUrl);
                                              }),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text("Error ${snapshot.error}");
                                      } else {
                                        return SizedBox(
                                          height: 90,
                                          child: ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              var agent = snapshot.data![index];
                                              return Consumer<AgentsNotifier>(
                                                  builder: (context,
                                                      agentsNotifier, child) {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    // Create/start chat with agent
                                                    final prefs = await SharedPreferences.getInstance();
                                                    final myUsername = prefs.getString('username') ?? 'User';
                                                    final myProfile = prefs.getString('profile') ?? '';
                                                    
                                                    final chatRoomId = '${userUid}_${agent.uid}';
                                                    final participants = [
                                                      {
                                                        'userId': userUid,
                                                        'username': myUsername,
                                                        'profile': myProfile
                                                      },
                                                      {
                                                        'userId': agent.uid,
                                                        'username': agent.username,
                                                        'profile': agent.profile
                                                      }
                                                    ];
                                                    
                                                    final chatData = {
                                                      'chatRoomId': chatRoomId,
                                                      'participants': participants,
                                                      'job': null
                                                    };
                                                    
                                                    agentsNotifier.chat = chatData;
                                                    Get.to(() => const ChatPage());
                                                  },
                                                  child: buildContactAvatar(
                                                      agent.username,
                                                      agent.profile),
                                                );
                                              });
                                            },
                                          ),
                                        );
                                      }
                                    });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 180,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: Color(0xFFEFFFFC),
                          ),
                          child: Consumer<ChatNotifier>(
                            builder: (context, chatNotifier, child) {
                              if (chatNotifier.isLoading && chatNotifier.chatRooms.isEmpty) {
                                return Center(
                                  child: Image.asset('assets/images/loader.gif'),
                                );
                              }

                              if (chatNotifier.error.isNotEmpty && chatNotifier.chatRooms.isEmpty) {
                                return Center(
                                  child: Text(
                                    'Error loading chats',
                                    style: appStyle(14, Colors.red, FontWeight.normal),
                                  ),
                                );
                              }

                              if (chatNotifier.chatRooms.isEmpty) {
                                return const NoSearchResults(
                                  text: 'No online chats yet',
                                );
                              }

                              final chatList = chatNotifier.chatRooms;
                              return ListView.builder(
                                  itemCount: chatList.length,
                                  padding: const EdgeInsets.only(left: 25),
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    final chat = chatList[index] as Map<String, dynamic>;

                                    DateTime lastChatDateTime;
                                    try {
                                      if (chat['lastMessageTime'] is String) {
                                        lastChatDateTime = DateTime.parse(chat['lastMessageTime']);
                                      } else {
                                        lastChatDateTime = DateTime.now();
                                      }
                                    } catch (e) {
                                      lastChatDateTime = DateTime.now();
                                    }

                                    final participants = chat['participants'] as List<dynamic>? ?? [];
                                    String displayName = 'Unknown';
                                    String displayProfile = '';
                                    for (var participant in participants) {
                                      if (participant['userId'] != userUid) {
                                        displayName = participant['username'] ?? 'Unknown';
                                        displayProfile = participant['profile'] ?? '';
                                        break;
                                      }
                                    }

                                    final unreadCount = chat['unreadCount'] is Map
                                        ? (chat['unreadCount'][userUid] ?? 0)
                                        : 0;

                                    return Consumer<AgentsNotifier>(
                                      builder: (context, agentsNotifier, child) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (chat['sender'] != userUid) {
                                              chatNotifier.markAsRead(chat['chatRoomId']);
                                            }
                                            final enrichedChat = Map<String, dynamic>.from(chat);
                                            enrichedChat['job'] ??= {
                                              'company': displayName,
                                              'title': 'Chat',
                                              'salary': '',
                                              'image_url': displayProfile,
                                            };
                                            agentsNotifier.chat = enrichedChat;
                                            Get.to(() => const ChatPage());
                                          },
                                          child: buildConversationRow(
                                              displayName,
                                              chat['lastMessage'] ?? '',
                                              displayProfile,
                                              unreadCount,
                                              lastChatDateTime),
                                        );
                                      },
                                    );
                                  });
                            },
                          ),
                        ))
                  ],
                ),
                Stack(
                  children: [
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding:
                            const EdgeInsets.only(top: 15, left: 25, right: 0),
                        height: 220,
                        decoration: const BoxDecoration(
                            color: Color(0xFF3281E3),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ReusableText(
                                  text: "Agencies and Companies",
                                  style: appStyle(12, Colors.white, FontWeight.normal),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.more_horiz,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                            Consumer<AgentsNotifier>(
                              builder: (context, agentsNotifier, child) {
                                var agents = agentsNotifier.getAgents();
                                return FutureBuilder<List<Agents>>(
                                    future: agents,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SizedBox(
                                          height: 90,
                                          child: ListView.builder(
                                              itemCount: 7,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return buildContactAvatar(
                                                    'Agent ${index}', imageUrl);
                                              }),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text("Error ${snapshot.error}");
                                      } else {
                                        return SizedBox(
                                          height: 90,
                                          child: ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              var agent = snapshot.data![index];
                                              return Consumer<AgentsNotifier>(
                                                  builder: (context,
                                                      agentsNotifier, child) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    agentsNotifier.agent =
                                                        agent;
                                                    Get.to(() =>
                                                        const AgentDetails());
                                                  },
                                                  child: buildContactAvatar(
                                                      agent.username,
                                                      agent.profile),
                                                );
                                              });
                                            },
                                          ),
                                        );
                                      }
                                    });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 180,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: Color(0xFFEFFFFC),
                          ),
                          child: const Center(
                            child: Text(
                              'Online chat coming soon',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ))
                  ],
                ),
              ],
            ),
    );
  }

  Column buildConversationRow(
      String name, String message, String filename, int msgCount, time) {
    return Column(
      children: [
        FittedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  UserAvatar(filename: filename),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableText(
                        text: name,
                        style: appStyle(12, Colors.grey, FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: width * 0.6,
                        child: ReusableText(
                          text: message,
                          style: appStyle(10, Colors.black, FontWeight.normal),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25, top: 5),
                child: Column(
                  children: [
                    ReusableText(
                      text: duTimeLineFormat(time),
                      style: appStyle(10, Colors.black, FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (msgCount > 0)
                      CircleAvatar(
                        radius: 7,
                        backgroundColor: const Color(0xFF3281E3),
                        child: ReusableText(
                          text: msgCount.toString(),
                          style: appStyle(8, Colors.white, FontWeight.normal),
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
        const Divider(
          indent: 70,
          height: 20,
        )
      ],
    );
  }

  Padding buildContactAvatar(String name, String filename) {
    
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          UserAvatar(
            filename: filename,
          ),
          const SizedBox(
            height: 5,
          ),
          ReusableText(
            text: name,
            style: appStyle(11, Colors.white, FontWeight.normal),
          ),
        ],
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String filename;
  const UserAvatar({
    super.key,
    required this.filename,
  });

  @override
  Widget build(BuildContext context) {
    String imageUrl =
      'https://ui-avatars.com/api/?name=Avatar&background=0D8ABC&color=fff&size=128';
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 3),
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        child: CachedNetworkImage(
          errorWidget: (context, url, error) {
            return Image.network(imageUrl);
          },
          imageUrl: filename,
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}
