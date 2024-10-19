part of 'message_bloc.dart';

abstract class GetMessagesState extends Equatable {
  const GetMessagesState();
  @override
  List<Object?> get props => [];
}

class MessageInitial extends GetMessagesState {}

class MessagesLoaded extends GetMessagesState {
  final List<Message> messages;

  const MessagesLoaded({this.messages = const <Message>[]});
  @override
  List<Object?> get props => [messages];
}
