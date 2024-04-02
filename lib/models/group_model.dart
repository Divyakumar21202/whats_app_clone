class GroupModel {
  final String name;
  final String groupId;
  final String groupPic;
  final String lastMessage;
  final String SenderUserId;
  final List<dynamic> membersUid;
  final DateTime timeSent;
  GroupModel({
    required this.name,
    required this.groupId,
    required this.groupPic,
    required this.lastMessage,
    required this.SenderUserId,
    required this.membersUid,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'groupId': groupId,
      'groupPic': groupPic,
      'lastMessage': lastMessage,
      'SenderUserId': SenderUserId,
      'membersUid': membersUid,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      groupPic: map['groupPic'] as String,
      lastMessage: map['lastMessage'] as String,
      SenderUserId: map['SenderUserId'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      membersUid: List<dynamic>.from(
        (map['membersUid'] as List<dynamic>),
      ),
    );
  }
}
