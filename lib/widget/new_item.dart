import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ydw_border/provider/token_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ydw_border/screen/home_page.dart';

class NewItem extends ConsumerStatefulWidget {
  const NewItem({super.key});

  @override
  NewItemState createState() {
    return NewItemState();
  }
}

class NewItemState extends ConsumerState<NewItem> {
  final _formKey = GlobalKey<FormState>();

  var _enteredBody = '';
  Image? image;
  var _isSending = false;
  XFile? _selectedImage;

  //이미지 선택 기능
  void _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  void _saveItem(String token) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });

      final url = Uri.parse('http://192.168.1.98:3000/boards');
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      if (_selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'photo',
            _selectedImage!.path,
          ),
        );
      }

      request.fields['title'] = 'titlie';
      request.fields['description'] = _enteredBody;

      final response = await request.send();

      if (response.statusCode == 201) {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const HomePage(),
          ),
        );

        print('게시물이 성공적으로 생성되었습니다.');
      } else {
        // 게시물 생성에 실패했을 때의 처리
        print('게시물 생성에 실패했습니다.');
      }

      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 게시글 작성'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImage != null
                      ? Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.image,
                              size: 50,
                            ),
                            onPressed: _selectImage,
                          ),
                        ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 400,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          '무슨 생각을 하고 계신가요?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        autofocus: true,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '내용을 입력하세요',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '본문을 입력하세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredBody = value!;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isSending
                      ? null
                      : () => _saveItem(ref.read(tokenProvider.notifier).state),
                  child: _isSending
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('게시글 작성'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
