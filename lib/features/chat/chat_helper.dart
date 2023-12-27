import 'package:cloud_firestore/cloud_firestore.dart';

class ChatHelper {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ! Get My Chats
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyChats() {
    return firestore.collection("chats").snapshots();
  }
}
