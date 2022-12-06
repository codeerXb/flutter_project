
/// 消息实体类
class MessageModel{

  /// 消息id
  String? id;
  /// 消息标题
  String? title;
  /// 发送时间
  DateTime? createTime;
  /// 发送人
  String? send;
  /// 接收人
  String? receiver;
  /// 消息内容
  String? content;
  /// 月度数量
  int? lookNum;
  /// 点赞数
  int? likesNum;

  MessageModel({this.id, this.title, this.createTime, this.send, this.receiver,
      this.content, this.lookNum, this.likesNum});

  @override
  String toString() {
    return 'MessageModel{id: $id, title: $title, createTime: $createTime, send: $send, receiver: $receiver, content: $content, lookNum: $lookNum, likesNum: $likesNum}';
  }
}