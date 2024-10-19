part of 'message_bloc.dart';

abstract class GetMessagesEvent extends Equatable {
  const GetMessagesEvent();
  @override
  List<Object?> get props => [];
}

class LoadMessagesForSingleChat extends GetMessagesEvent {
  final String receiverId;

  const LoadMessagesForSingleChat(this.receiverId);

  @override
  List<Object?> get props => [receiverId];
}

class LoadMessagesForGroupChat extends GetMessagesEvent {
  final String groupChatUid;

  const LoadMessagesForGroupChat({required this.groupChatUid});
  @override
  List<Object?> get props => [groupChatUid];
}

class UpdateMessages extends GetMessagesEvent {
  final List<Message> messages;

  const UpdateMessages(this.messages);
  @override
  List<Object?> get props => [messages];
}

class UpdateMessagesForGroup extends GetMessagesEvent {
  final List<Message> messages;

  const UpdateMessagesForGroup(this.messages);
  @override
  List<Object?> get props => [messages];
}
