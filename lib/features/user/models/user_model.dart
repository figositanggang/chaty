import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String username;
  final String email;
  final String fullName;

  final Timestamp createdAt;

  final List chats;

  String photoUrl;

  UserModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.fullName,
    required this.chats,
    required this.createdAt,
    this.photoUrl =
        "https://res.cloudinary.com/unlinked/image/upload/v1703853324/cute-angry-red-dinosaur-cartoon-vector-icon-illustration-animal-nature-icon-concept-isolated-flat_138676-6013_nxzvjz.jpg",
  });

  Map<String, dynamic> toJson() => {
        "userId": this.userId,
        "username": this.username,
        "email": this.email,
        "fullName": this.fullName,
        "createdAt": this.createdAt,
        "chats": this.chats,
        "photoUrl": this.photoUrl,
      };

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;

    return UserModel(
      userId: snap['userId'],
      username: snap['username'],
      email: snap['email'],
      fullName: snap['fullName'],
      createdAt: snap['createdAt'],
      chats: snap['chats'],
      photoUrl: snap['photoUrl'],
    );
  }
}
