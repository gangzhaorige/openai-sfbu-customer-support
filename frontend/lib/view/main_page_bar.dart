import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 78,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            child: Row(
              children: [
                Image(
                  image: AssetImage('assets/SFBU-logo.png')
                ),
                Text(
                  'San Francisco Bay University',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            child: const Icon(
              Icons.settings,
              size: 30,
              color: Colors.white,
            ),
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
          )
        ],
      ),
    );
  }
}