import 'dart:io';
import 'dart:typed_data';

import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class AddMessageUseCase
    implements UseCaseThreeParams<Message, Message, Uint8List?, File?> {
  final FireStoreUserRepository _userRepository;

  AddMessageUseCase(this._userRepository);
  @override
  Future<Message> call(
          {required Message paramsOne,
          required Uint8List? paramsTwo,
          required File? paramsThree}) =>
      _userRepository.sendMessage(
          messageInfo: paramsOne,
          pathOfPhoto: paramsTwo,
          recordFile: paramsThree);
}
