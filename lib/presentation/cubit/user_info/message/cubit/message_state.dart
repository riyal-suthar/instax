part of 'message_cubit.dart';

abstract class MessageState extends Equatable {
  const MessageState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MessageInitial extends MessageState {
  @override
  List<Object> get props => [];
}

class SendMessageLoading extends MessageState {}

// class CreatingChatForGroupLoading extends MessageState {}

class GetSpecificChatLoading extends MessageState {}

class DeleteMessageLoading extends MessageState {}

class SendMessageLoaded extends MessageState {
  final Message messageInfo;

  SendMessageLoaded(this.messageInfo);
  @override
  // TODO: implement props
  List<Object?> get props => [messageInfo];
}

// class CreatingChatForGroupLoaded extends MessageState {
//   final Message messageInfo;
//
//   CreatingChatForGroupLoaded(this.messageInfo);
//   @override
//   // TODO: implement props
//   List<Object?> get props => [messageInfo];
// }

class GetSpecificChatLoaded extends MessageState {
  final SenderInfo coverMessageDetails;

  GetSpecificChatLoaded(this.coverMessageDetails);
  @override
  // TODO: implement props
  List<Object?> get props => [coverMessageDetails];
}

class DeleteMessageLoaded extends MessageState {}

class SendMessageFailed extends MessageState {
  final String error;

  SendMessageFailed(this.error);
}

// class CreatingChatForGroupFailed extends MessageState {
//   final String error;
//
//   CreatingChatForGroupFailed(this.error);
// }

class GetMessageSuccess extends MessageState {}

class GetMessageFailed extends MessageState {
  final String error;

  GetMessageFailed(this.error);
}
