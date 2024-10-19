import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instax/domain/repositories/group_message_repository.dart';

class GetMessagesForGroupChatUseCase implements StreamUseCase<List<Message>, String> {
  final FireStoreGroupMessageRepository _groupMessageRepository;

  GetMessagesForGroupChatUseCase(this._groupMessageRepository);
  @override
  Stream<List<Message>> call({required String params}) =>
      _groupMessageRepository.getMessages(groupChatUid: params);
}
