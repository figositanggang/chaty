class LastPositionModel {
  final String userId;
  final num lastPosition;

  LastPositionModel({required this.userId, required this.lastPosition});

  Map<String, dynamic> toMap() => {
        "userId": this.userId,
        "lastPosition": this.lastPosition,
      };

  factory LastPositionModel.fromMap(Map<String, dynamic> map) {
    return LastPositionModel(
      userId: map["userId"],
      lastPosition: map["lastPosition"],
    );
  }
}
