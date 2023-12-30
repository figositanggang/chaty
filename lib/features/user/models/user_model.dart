import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String username;
  final String email;
  final String fullName;
  String photoUrl;
  final Timestamp createdAt;

  UserModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.fullName,
    this.photoUrl =
        "https://res.cloudinary.com/unlinked/image/upload/v1703853324/cute-angry-red-dinosaur-cartoon-vector-icon-illustration-animal-nature-icon-concept-isolated-flat_138676-6013_nxzvjz.jpg",
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        "userId": this.userId,
        "username": this.username,
        "email": this.email,
        "fullName": this.fullName,
        "photoUrl": this.photoUrl,
        "createdAt": this.createdAt,
      };

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;

    return UserModel(
      userId: snap['userId'],
      username: snap['username'],
      email: snap['email'],
      fullName: snap['fullName'],
      createdAt: snap['createdAt'],
    );
  }
}
