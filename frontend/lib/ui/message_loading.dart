import 'package:flutter/material.dart';
import 'package:flutter_front_end/ui/ui_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../models/message_model.dart';

class MessageLoading extends StatelessWidget {
  const MessageLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            const FaIcon(
              FontAwesomeIcons.robot,
              color: Colors.white,
              size: 30
            ),
            horizontalSpaceSmall,
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SFBU ChatBot',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
                  LoadingAnimationWidget.prograssiveDots(
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}