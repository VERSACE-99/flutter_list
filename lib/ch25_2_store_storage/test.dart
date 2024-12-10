import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_lab_202116013/firebase_options.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String msg, {Color backgroundColor = Colors.red}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: backgroundColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

class Content {
  final String content;
  final String downloadUrl;
  final String date;

  Content(
      {required this.content, required this.downloadUrl, required this.date});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      content: json['content'] ?? '',
      downloadUrl: json['downloadUrl'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content,
        'downloadurl': downloadUrl,
        'date': date,
      };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/list',
      routes: {
        '/list': (context) => const ListScreen(),
        '/input': (context) => const InputScreen(),
      },
    );
  }
}

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contentsRef = FirebaseFirestore.instance
        .collection('content')
        .withConverter<Content>(
          fromFirestore: (snapshots, _) => Content.fromJson(snapshots.data()!),
          toFirestore: (content, _) => content.toJson(),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Test')),
      body: StreamBuilder<QuerySnapshot<Content>>(
        stream: contentsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;
          return ListView.builder(
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              final content = data.docs[index].data();
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(content.downloadUrl),
                    Text(content.date,
                        style: const TextStyle(color: Colors.black54)),
                    Text(content.content, style: const TextStyle(fontSize: 20)),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/input'),
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  InputScreenState createState() => InputScreenState();
}

class InputScreenState extends State<InputScreen> {
  final TextEditingController controller = TextEditingController();
  XFile? _image;
  String? downloadUrl;
  bool isUploading = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> uploadFile() async {
    if (_image == null) {
      showToast('No file selected');
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      final ref =
          FirebaseStorage.instance.ref().child('images/${_image!.name}');
      await ref.putFile(File(_image!.path));
      downloadUrl = await ref.getDownloadURL();
      showToast('File uploaded successfully', backgroundColor: Colors.green);
    } catch (e) {
      showToast('Upload faild: $e');
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  Future<void> saveContent() async {
    if (controller.text.isEmpty || _image == null || downloadUrl == null) {
      showToast('Invalid data for saving');
      return;
    }
    final content = Content(
      content: controller.text,
      downloadUrl: downloadUrl!,
      date: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
    );

    try {
      await FirebaseFirestore.instance
          .collection('content')
          .add(content.toJson());
      Navigator.pop(context);
    } catch (e) {
      showToast('Save faild: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store, Storege Test'),
        actions: [
          IconButton(icon: const Icon(Icons.photo_album), onPressed: pickImage),
          IconButton(icon: const Icon(Icons.save), onPressed: saveContent),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_image != null)
              Container(
                height: 200,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Image.file(File(_image!.path)),
              )
            else
              const Center(
                  child: Text("No image selected",
                      style: TextStyle(color: Colors.grey))),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Date',
                prefixIcon: Icon(Icons.input),
                border: OutlineInputBorder(),
                hintText: 'Enter data',
                helperText: 'Please enter the content data',
              ),
            ),
            if (isUploading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
