import 'package:instax/data/models/parent_classes/without_sub_classes/message.dart';
import '../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';

class SenderInfo {
  List<UserPersonalInfo>? receiversInfo;
  List<dynamic>? receiversIds;
  Message? lastMessage;
  final bool isThatGroupChat;

  SenderInfo({
    this.receiversInfo,
    this.receiversIds,
    this.lastMessage,
    this.isThatGroupChat = false,
  });
}
