import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instax/domain/repositories/group_message_repository.dart';

class DeleteMessageForGroupChatUseCase
    implements UseCaseThreeParams<void, String, Message, Message> {
  final FireStoreGroupMessageRepository _groupMessageRepository;

  DeleteMessageForGroupChatUseCase(this._groupMessageRepository);
  @override
  Future<void> call(
          {required String paramsOne,
          required Message paramsTwo,
          required Message paramsThree}) =>
      _groupMessageRepository.deleteMessage(
          messageInfo: paramsTwo,
          chatOfGroupUid: paramsOne,
          replacedMessage: paramsThree);
}
