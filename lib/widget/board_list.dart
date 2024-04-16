import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:ydw_border/models/board_item.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:ydw_border/screen/comment_page.dart';

class BoardList extends StatefulWidget {
  const BoardList({super.key});

  @override
  State<BoardList> createState() => _BoardListState();
}

class _BoardListState extends State<BoardList> {
  List<BoardItem> _boardItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.parse('http://192.168.1.98:3000/all_board?page=1&limit=4');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print(response.body);
      }

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data. Please try again later';
        });
        return;
      }

      Map<String, dynamic> data = json.decode(response.body);
      int totalitems = data['meta']['totalItems'];
      print(response.body);
      if (totalitems == 0) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<BoardItem> loadedItems = [];

      final List<dynamic> items = listData['items']; // 'items' 배열 추출

      for (final data in items) {
        // 이미지 데이터 확인
        final photoData = data['photo'];
        Uint8List? photoBytes;
        if (photoData != null) {
          photoBytes = base64Decode(photoData);
        }

        // 시간 문자열을 날짜와 시간으로 분리
        String dateString = data['createdAt'];
        String datePart = dateString.split('T')[0];
        String timePart = dateString.split('T')[1].replaceAll('Z', '');
        List<String> timeComponents = timePart.split(':');
        String hour = timeComponents[0];
        String minute = timeComponents[1];

        // BoardItem 객체 생성하여 loadedItems에 추가
        loadedItems.add(
          BoardItem(
            postId: data['id'],
            username: data['user']['username'],
            body: data['description'],
            date: '$datePart $hour:$minute',
            like: data['like'],
            image: photoBytes, // 이미지 데이터 추가
          ),
        );
      }

      setState(() {
        _boardItems = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = error.toString();
      });

      print(_error);
    }
  }

  @override
  Widget build(BuildContext context) {
    void _showCommentPage(BuildContext context, int postId) {
      showDialog(
        context: context,
        builder: (context) => CommentPage(postId: postId),
      );
    }

    const imageurl = 'assets/images/kfjungle.png';

    Widget content = const Center(
      child: Text('게시글이 없습니다.'),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_boardItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _boardItems.length,
        itemBuilder: (context, index) {
          final item = _boardItems[index];
          return Card(
            margin: const EdgeInsets.all(8),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage(imageurl), // 프로필 이미지
                  ),
                  title: Text(item.username), // 사용자 이름
                  subtitle: Text(item.date),
                ),
                if (item.image != null)
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.memory(
                        item.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    item.body,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Implement like functionality
                      },
                      icon: const Icon(Icons.thumb_up),
                    ),
                    IconButton(
                      onPressed: () {
                        _showCommentPage(context, item.postId);
                      },
                      icon: const Icon(Icons.comment),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    return content;
  }
}
