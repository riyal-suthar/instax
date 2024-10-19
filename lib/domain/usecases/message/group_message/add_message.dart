import 'dart:io';
import 'dart:typed_data';

import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instax/domain/repositories/group_message_repository.dart';

class AddMessageForGroupChatUseCase
    implements UseCaseThreeParams<Message, Message, Uint8List?, File?> {
  final FireStoreGroupMessageRepository _groupMessageRepository;

  AddMessageForGroupChatUseCase(this._groupMessageRepository);
  @override
  Future<Message> call(
          {required Message paramsOne,
          required Uint8List? paramsTwo,
          required File? paramsThree}) =>
      _groupMessageRepository.sendMessage(
          messageInfo: paramsOne,
          pathOfPhoto: paramsTwo,
          recordFile: paramsThree);
}
