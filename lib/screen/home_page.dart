import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ydw_border/widget/board_list.dart';
import 'package:ydw_border/widget/drawer.dart';
import 'package:ydw_border/widget/new_item.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('JUNGLE 게시판'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const NewItem(),
                  ),
                );
              },
              icon: const Icon(Icons.create),
            ),
          ],
        ),
        drawer: const DrawerWidget(),
        body: const BoardList(),
      ),
    );
  }
}
