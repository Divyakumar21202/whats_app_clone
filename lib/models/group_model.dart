class GroupModel {
  final String name;
  final String groupId;
  final String groupPic;
  final String lastMessage;
  final String SenderUserId;
  final List<String> membersUid;
  GroupModel({
    required this.name,
    required this.groupId,
    required this.groupPic,
    required this.lastMessage,
    required this.SenderUserId,
    required this.membersUid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'groupId': groupId,
      'groupPic': groupPic,
      'lastMessage': lastMessage,
      'SenderUserId': SenderUserId,
      'membersUid': membersUid,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
        name: map['name'] as String,
        groupId: map['groupId'] as String,
        groupPic: map['groupPic'] as String,
        lastMessage: map['lastMessage'] as String,
        SenderUserId: map['SenderUserId'] as String,
        membersUid: List<String>.from(
          (map['membersUid'] as List<String>),
        ));
  }
}
