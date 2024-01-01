enum MessageEnum {
  text('text'),
  video('video'),
  audio('audio'),
  gif('gif'),
  image('image');

  const MessageEnum(this.type);
  final String type;
}

//Using an extension
// Enhanced enums

extension ConvertMessage on String {
  MessageEnum toEnum() {
    switch (this) {
      case 'audio':
        return MessageEnum.audio;
      case 'image':
        return MessageEnum.image;
      case 'text':
        return MessageEnum.text;
      case 'video':
        return MessageEnum.video;
      case 'gif':
        return MessageEnum.gif;
      default:
        return MessageEnum.text;
    }
  }
}
