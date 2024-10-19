part of 'message_for_group_chat_cubit.dart';

abstract class MessageForGroupChatState extends Equatable {
  const MessageForGroupChatState();
  @override
  List<Object> get props => [];
}

class MessageForGroupChatInitial extends MessageForGroupChatState {
  @override
  List<Object> get props => [];
}

class MessageForGroupChatLoading extends MessageForGroupChatState {}

class DeleteMessageForGroupChatLoading extends MessageForGroupChatState {}

class MessageForGroupChatLoaded extends MessageForGroupChatState {
  final Message messageInfo;

  MessageForGroupChatLoaded(this.messageInfo);
  @override
  // TODO: implement props
  List<Object> get props => [messageInfo];
}

class DeleteMessageForGroupChatLoaded extends MessageForGroupChatState {}

class MessageForGroupChatFailed extends MessageForGroupChatState {
  final String error;

  MessageForGroupChatFailed(this.error);
  @override
  // TODO: implement props
  List<Object> get props => [error];
}
