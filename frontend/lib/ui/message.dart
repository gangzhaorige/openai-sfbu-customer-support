import 'package:flutter/material.dart';
import 'package:flutter_front_end/ui/ui_helper.dart';

import '../models/message_model.dart';

class Message extends StatelessWidget {
  const Message({
    super.key,
    required this.messageInfo,
  });

  final MessageModel messageInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Icon(
              messageInfo.isSender ? Icons.message_sharp : Icons.chat_bubble,
              color: Colors.white,
              size: 30
            ),
            horizontalSpaceSmall,
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    messageInfo.isSender ? 'You' : 'SFBU ChatBot',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
                  Text(
                    messageInfo.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}