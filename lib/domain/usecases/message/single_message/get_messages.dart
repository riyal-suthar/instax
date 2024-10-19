import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class GetMessagesUseCase implements StreamUseCase<List<Message>, String> {
  final FireStoreUserRepository _userRepository;

  GetMessagesUseCase(this._userRepository);

  @override
  Stream<List<Message>> call({required String params}) =>
      _userRepository.getMessages(receiverId: params);
}
