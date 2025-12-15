import 'package:flutter/material.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/controllers/chat_provider.dart';
import 'package:jobhubv2_0/utils/date.dart';
import 'package:jobhubv2_0/views/common/app_style.dart';
import 'package:jobhubv2_0/views/common/loader.dart';
import 'package:jobhubv2_0/views/ui/chat/widgets/chat_left_item.dart';
import 'package:jobhubv2_0/views/ui/chat/widgets/chat_right_item.dart';
import 'package:provider/provider.dart';

class MessageList extends StatefulWidget {
  final String chatRoomId;
  const MessageList({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  late ScrollController _msgScrolling;
  bool spacing = true;

  @override
  void initState() {
    _msgScrolling = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _msgScrolling.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
      child: Consumer<ChatNotifier>(
        builder: (context, chatNotifier, child) {
          if (chatNotifier.isLoading && chatNotifier.messages.isEmpty) {
            return Center(
              child: Image.asset('assets/images/loader.gif'),
            );
          }

          if (chatNotifier.error.isNotEmpty && chatNotifier.messages.isEmpty) {
            return Center(
              child: Text(
                'Error loading messages',
                style: appStyle(14, Colors.red, FontWeight.normal),
              ),
            );
          }

          if (chatNotifier.messages.isEmpty) {
            return const NoSearchResults(
              text: 'Be the first to send a message',
            );
          }

          // Scroll to bottom when new messages arrive
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_msgScrolling.hasClients) {
              _msgScrolling.animateTo(
                _msgScrolling.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });

          return Column(
            children: [
              Container(
                height: hieght * .66,
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: chatNotifier.messages.length,
                  controller: _msgScrolling,
                  itemBuilder: (BuildContext context, index) {
                    var message = chatNotifier.messages[index];

                    // Parse message time
                    DateTime messageTime;
                    try {
                      if (message['time'] is String) {
                        messageTime = DateTime.parse(message['time']);
                      } else {
                        messageTime = DateTime.now();
                      }
                    } catch (e) {
                      messageTime = DateTime.now();
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            duTimeLineFormat(messageTime),
                            style: appStyle(10, Colors.grey, FontWeight.normal),
                          ),
                          message['sender'] == userUid
                              ? ChatRightItem(
                                  message['messageType'] ?? 'text',
                                  message['message'] ?? '',
                                  message['senderProfile'] ?? '')
                              : ChatLeftItem(
                                  message['messageType'] ?? 'text',
                                  message['message'] ?? '',
                                  message['senderProfile'] ?? ''),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 70,
              )
            ],
          );
        },
      ),
    );
  }
}
