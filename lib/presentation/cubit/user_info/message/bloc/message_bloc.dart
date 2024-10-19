import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/models/parent_classes/without_sub_classes/message.dart';
import '../../../../../domain/usecases/message/group_message/get_messages.dart';
import '../../../../../domain/usecases/message/single_message/get_messages.dart';

part 'message_event.dart';
part 'message_state.dart';

class GetMessagesBloc extends Bloc<GetMessagesEvent, GetMessagesState> {
  final GetMessagesUseCase _getMessageUseCase;
  final GetMessagesForGroupChatUseCase _getMessagesForGroupUseCase;
  GetMessagesBloc(this._getMessageUseCase, this._getMessagesForGroupUseCase)
      : super(MessageInitial()) {
    on<LoadMessagesForSingleChat>((event, emit) async => await emit.onEach(
        _getMessageUseCase.call(params: event.receiverId),
        onData: (messages) => add(UpdateMessages(messages))));

    on<UpdateMessages>(
        (event, emit) => emit(MessagesLoaded(messages: event.messages)));

    on<LoadMessagesForGroupChat>((event, emit) async => await emit.onEach(
        _getMessagesForGroupUseCase.call(params: event.groupChatUid),
        onData: (messages) => add(UpdateMessagesForGroup(messages))));

    on<UpdateMessagesForGroup>(
        (event, emit) => emit(MessagesLoaded(messages: event.messages)));
  }

  // Stream<GetMessagesState> mapEventToState(GetMessagesEvent event) async* {
  //   if (event is LoadMessagesForSingleChat) {
  //     yield* _mapLoadMessagesToState(event.receiverId);
  //   } else if (event is UpdateMessages) {
  //     yield* _mapUpdateMessagesToState(event);
  //   }
  //
  //   if (event is LoadMessagesForGroupChat) {
  //     yield* _mapLoadMessagesForGroupToState(event.groupChatUid);
  //   } else if (event is UpdateMessagesForGroup) {
  //     yield* _mapUpdateMessagesForGroupToState(event);
  //   }
  // }
  //
  // static GetMessagesBloc get(BuildContext context) => BlocProvider.of(context);
  //
  // Stream<GetMessagesState> _mapLoadMessagesToState(String receiverId) async* {
  //   _getMessageUseCase.call(params: receiverId).listen((messages) {
  //     add(UpdateMessages(messages));
  //   });
  // }
  //
  // Stream<GetMessagesState> _mapUpdateMessagesToState(
  //     UpdateMessages event) async* {
  //   yield MessagesLoaded(messages: event.messages);
  // }
  //
  // Stream<GetMessagesState> _mapLoadMessagesForGroupToState(
  //     String groupChatUid) async* {
  //   _getMessagesForGroupUseCase.call(params: groupChatUid).listen((messages) {
  //     add(UpdateMessagesForGroup(messages));
  //   });
  // }
  //
  // Stream<GetMessagesState> _mapUpdateMessagesForGroupToState(
  //     UpdateMessagesForGroup event) async* {
  //   yield MessagesLoaded(messages: event.messages);
  // }
}
