import 'package:flutter/material.dart';
import 'package:flutter_front_end/locator.dart';
import 'package:flutter_front_end/services/audio_services.dart';
import 'package:flutter_front_end/ui/ui_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constant.dart';
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
            FaIcon(
              messageInfo.isSender ? FontAwesomeIcons.userPlus : FontAwesomeIcons.robot,
              color: Colors.white,
              size: 30
            ),
            horizontalSpaceSmall,
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        messageInfo.isSender ? 'You' : 'SFBU ChatBot',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20
                        ),
                      ),
                      horizontalSpaceSmall,
                      if(!messageInfo.isSender)...[
                        GestureDetector(
                          onTap: () async {
                            await locator<AudioPlayerService>().playAudio('$url/mp3/${messageInfo.url}');
                          },
                          child: const Icon(
                            Icons.volume_up,
                            size: 20,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ],
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