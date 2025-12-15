import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/controllers/agents_provider.dart';
import 'package:jobhubv2_0/controllers/chat_provider.dart';
import 'package:jobhubv2_0/controllers/image_provider.dart';
import 'package:jobhubv2_0/views/common/BackBtn.dart';
import 'package:jobhubv2_0/views/common/app_style.dart';
import 'package:jobhubv2_0/views/common/reusable_text.dart';
import 'package:jobhubv2_0/views/ui/auth/profile.dart';
import 'package:jobhubv2_0/views/ui/chat/widgets/messageList.dart';
import 'package:jobhubv2_0/views/ui/chat/widgets/textfield.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();

  TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  String imageUrl =
      'https://ui-avatars.com/api/?name=ChatUser&background=0D8ABC&color=fff&size=128';
  String? _username;
  String? _userProfile;
  String? _receiverName;
  String? _receiverProfile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Start polling messages when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatNotifier = Provider.of<ChatNotifier>(context, listen: false);
      final agentsNotifier = Provider.of<AgentsNotifier>(context, listen: false);
      final chat = agentsNotifier.chat;
      final chatRoomId = chat['chatRoomId'];

      // Resolve receiver info from participants
      final participants = chat['participants'] as List<dynamic>? ?? [];
      for (var participant in participants) {
        if (participant['userId'] != userUid) {
          _receiverName = participant['username'] ?? 'Chat';
          _receiverProfile = participant['profile'] ?? '';
          break;
        }
      }

      chatNotifier.startMessagePolling(chatRoomId);
      chatNotifier.markAsRead(chatRoomId);
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
      _userProfile = prefs.getString('profile') ?? '';
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    final chatNotifier = Provider.of<ChatNotifier>(context, listen: false);
    chatNotifier.stopPolling();
    super.dispose();
  }


  Future<void> sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    var chat = Provider.of<AgentsNotifier>(context, listen: false).chat;
    var chatNotifier = Provider.of<ChatNotifier>(context, listen: false);

    // Get receiver info from participants
    String receiver = '';
    final participants = chat['participants'] as List<dynamic>? ?? [];
    for (var participant in participants) {
      if (participant['userId'] != userUid) {
        receiver = participant['userId'];
        break;
      }
    }

    if (receiver.isEmpty) {
      print('Error: No receiver found');
      return;
    }

    final success = await chatNotifier.sendMessage(
      chatRoomId: chat['chatRoomId'],
      receiver: receiver,
      message: _messageController.text,
      senderName: _username ?? 'User',
      senderProfile: _userProfile ?? '',
      messageType: 'text',
    );

    if (success) {
      _messageController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    var imageNotifier = Provider.of<ImageUpoader>(context);
    var chatNotifier = Provider.of<ChatNotifier>(context);
    var agentsNotifier = Provider.of<AgentsNotifier>(context);

    String chatRoomId = agentsNotifier.chat['chatRoomId'];

    final participants = agentsNotifier.chat['participants'] as List<dynamic>? ?? [];
    String receiverName = _receiverName ?? 'Chat';
    String receiverProfile = _receiverProfile ?? imageUrl;
    for (var participant in participants) {
      if (participant['userId'] != userUid) {
        receiverName = participant['username'] ?? receiverName;
        receiverProfile = participant['profile']?.toString().isNotEmpty == true
            ? participant['profile']
            : receiverProfile;
        break;
      }
    }

    return Scaffold(
        backgroundColor: Color(kLight.value),
        appBar: AppBar(
          backgroundColor: Color(kLight.value),
          elevation: 0,
          leading: const Padding(
            padding: EdgeInsets.all(12.0),
            child: BackBtn(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReusableText(
                        text: receiverName,
                        style:
                            appStyle(11, Colors.black87, FontWeight.w600),
                      ),
                      Consumer<ChatNotifier>(
                        builder: (context, chatNotifier, child) {
                          final isTyping = chatNotifier.typingUsers.isNotEmpty;
                          return ReusableText(
                            text: isTyping ? "typing ..." : "online",
                            style: appStyle(
                                9, Colors.black54, FontWeight.normal),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            receiverProfile.isNotEmpty
                                ? receiverProfile
                                : imageUrl),
                        radius: 15,
                      ),
                      Positioned(
                        child: CircleAvatar(
                            backgroundColor: Colors.green.shade600,
                            radius: 4),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 5),
                  height: 120,
                  decoration: const BoxDecoration(
                      color: Color(0xFF3281E3),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      Consumer<AgentsNotifier>(
                        builder: (context, agentsNotifier, child) {
                          var jobDetails = agentsNotifier.chat['job'];
                          final hasJob = jobDetails != null;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (hasJob)
                                  Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ReusableText(
                                            text: "Company",
                                            style: appStyle(10, Colors.white54,
                                                FontWeight.w600),
                                          ),
                                          ReusableText(
                                            text: 'Job Title',
                                            style: appStyle(10, Colors.white54,
                                                FontWeight.normal),
                                          ),
                                          ReusableText(
                                            text: 'Salary',
                                            style: appStyle(10, Colors.white54,
                                                FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Container(
                                          height: 60,
                                          width: 1,
                                          color: Colors.amberAccent,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ReusableText(
                                            text: jobDetails['company'] ?? receiverName,
                                            style: appStyle(10, Colors.white,
                                                FontWeight.w600),
                                          ),
                                          ReusableText(
                                            text: jobDetails['title'] ?? 'Chat',
                                            style: appStyle(10, Colors.white,
                                                FontWeight.normal),
                                          ),
                                          ReusableText(
                                            text: jobDetails['salary'] ?? '',
                                            style: appStyle(10, Colors.white,
                                                FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                else
                                  Row(
                                    children: [
                                      ReusableText(
                                        text: receiverName,
                                        style: appStyle(12, Colors.white,
                                            FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                const SizedBox(
                                  width: 20,
                                ),
                                CircularAvata(
                                    w: 50,
                                    h: 50,
                                    image: hasJob
                                        ? jobDetails['image_url'] ?? receiverProfile
                                        : receiverProfile),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 85,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Color(0xFFEFFFFC),
                    ),
                    child: Stack(
                      children: [
                        MessageList(chatRoomId: chatRoomId),
                        Positioned(
                          bottom: 0.h,
                          child: MessagingTextController(
                              sendText: () {
                                sendMessage();
                              },
                              sendImages: () {
                                imageNotifier.pickImage();
                              },
                              onTapOutside: (p0) {
                                chatNotifier.isFocused = false;
                                chatNotifier.setTypingStatus(chatRoomId, false);
                              },
                              onTap: () {},
                              onEditingComplete: () {
                                chatNotifier.isFocused = false;
                                chatNotifier.setTypingStatus(chatRoomId, false);
                                FocusScope.of(context).unfocus();
                              },
                              onChanged: (message) => {
                                    if (message.isNotEmpty && message != '')
                                      {
                                        chatNotifier.isFocused = true,
                                        chatNotifier.setTypingStatus(chatRoomId, true)
                                      }
                                    else
                                      {
                                        chatNotifier.setTypingStatus(chatRoomId, false)
                                      }
                                  },
                              messageController: _messageController,
                              messageFocusNode: _messageFocusNode),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
