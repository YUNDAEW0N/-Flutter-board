import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ydw_border/models/board_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final url = Uri.parse('http://192.168.1.98:3000/all_board');

    try {
      final response = await http.get(url);

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

      for (final itemData in items) {
        // 이미지 데이터 확인
        final photoData = itemData['photo'];
        Uint8List? photoBytes;
        if (photoData != null) {
          photoBytes = base64Decode(photoData);
        }

        // 시간 문자열을 날짜와 시간으로 분리
        String dateString = itemData['createdAt'];
        String datePart = dateString.split('T')[0];
        String timePart = dateString.split('T')[1].replaceAll('Z', '');
        List<String> timeComponents = timePart.split(':');
        String hour = timeComponents[0];
        String minute = timeComponents[1];

        // BoardItem 객체 생성하여 loadedItems에 추가
        loadedItems.add(
          BoardItem(
            username: itemData['id'].toString(),
            body: itemData['description'],
            date: '$datePart $hour:$minute',
            like: itemData['like'],
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
        _error = 'Something went wrong! Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Card(
              elevation: 4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage(imageurl),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.username),
                              Text(item.date),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(item.body),
                        ),
                        Container(
                          height: 200, // 이미지 미리보기를 위한 높이 설정
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey), // 테두리 추가
                          ),
                          child: item.image != null
                              ? Image.memory(
                                  item.image!,
                                  fit: BoxFit.cover,
                                )
                              : const Center(
                                  child: Icon(Icons.image),
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
                                // Implement comment functionality
                              },
                              icon: const Icon(Icons.comment),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return content;
  }
}
