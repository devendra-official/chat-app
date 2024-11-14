import 'package:flutter/material.dart';
import 'package:messenger/core/themes/colors.dart';
import 'package:messenger/features/chats/view/pages/chats_list.dart';
import 'package:messenger/features/meta/view/pages/meta.dart';
import 'package:messenger/features/stories/view/pages/stories.dart';

class BtmNav extends StatefulWidget {
  const BtmNav({super.key});

  @override
  State<BtmNav> createState() => _BtmNavState();
}

class _BtmNavState extends State<BtmNav> {
  final List<Widget> pages = [
    const ChatsList(),
    const MetaAI(),
    const Stories()
  ];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    String title = index == 0 ? "Chats" : "Stories";
    return Scaffold(
      appBar: index != 1
          ? AppBar(
              title: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.6),
              ),
              actions: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: lightBlack,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.edit),
                  ),
                ),
              ],
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        unselectedItemColor: greyTextColor,
        selectedItemColor: blueColor,
        unselectedFontSize: 14,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_rounded),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.circle_outlined),
            label: "MetaAI",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: "Stories",
          ),
        ],
      ),
      body: pages[index],
    );
  }
}
