import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
            ),
            StreamBuilder(
              stream: db
                  .collection("chat_room")
                  .doc("6lh4Ia8T3U56pwCeXDgT")
                  .collection("messages")
                  .snapshots(),
              builder: (context, snapshot) {
                // type -> 문서들
                var messages = snapshot.data;
                for (var message in messages!.docs) {
                  print(message.data()["content"]);
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: messages.size,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title:
                            Text("${messages.docs[index].data()["content"]}"),
                      );
                    },
                  ),
                );
              },
            ),
            Text(
              "디비 데이터",
              style: TextStyle(fontSize: 30),
            ),
            TextButton(
              onPressed: () async {
                // 모든 문서들!! (지금 현재는 문서가 하나 밖에 없음)
                QuerySnapshot<Map<String, dynamic>> chatRoomCollection =
                    await db.collection("chat_room").get();

                // 모든 문서들을 for문으로 조회 (한바퀴만 돌아갈 예정)
                for (var chatDoc in chatRoomCollection.docs) {
                  dynamic data = chatDoc.data();
                  print(data);
                }
              },
              child: Text(
                "chat_room 읽기",
                style: TextStyle(fontSize: 30),
              ),
            ),
            TextButton(
              onPressed: () async {
                var chatRoomDoc =
                    await db.collection("chat_room").doc("1").get();
                print("${chatRoomDoc.data()}");
              },
              child: Text(
                "chat_room의 문서 하나 읽기",
                style: TextStyle(fontSize: 30),
              ),
            ),
            TextButton(
              onPressed: () async {
                var messageCollection = await db
                    .collection("chat_room")
                    .doc("6lh4Ia8T3U56pwCeXDgT")
                    .collection("messages")
                    .get();
                for (var messageDoc in messageCollection.docs) {
                  dynamic data = messageDoc.data();
                  print(data);
                }
              },
              child: Text(
                "chat_room의 문서의 컬렉션 읽기",
                style: TextStyle(fontSize: 30),
              ),
            ),
            TextButton(
              onPressed: () async {
                Map<String, dynamic> data = {"id": 5353, "username": "cos"};
                db.collection("hello").add(data);
              },
              child: Text(
                "데이터 저장",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
