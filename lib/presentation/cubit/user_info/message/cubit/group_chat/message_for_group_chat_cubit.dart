import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/message.dart';

import '../../../../../../domain/usecases/message/group_message/add_message.dart';
import '../../../../../../domain/usecases/message/group_message/delete_messages.dart';

part 'message_for_group_chat_state.dart';

class MessageForGroupChatCubit extends Cubit<MessageForGroupChatState> {
  final AddMessageForGroupChatUseCase _addMessageForGroupChatUseCase;
  final DeleteMessageForGroupChatUseCase _deleteMessageForGroupChatUseCase;
  MessageForGroupChatCubit(this._addMessageForGroupChatUseCase,
      this._deleteMessageForGroupChatUseCase)
      : super(MessageForGroupChatInitial());

  static MessageForGroupChatCubit get(BuildContext context) =>
      BlocProvider.of(context);

  late Message lastMessage;

  static Message getLastMessage(BuildContext context) =>
      BlocProvider.of<MessageForGroupChatCubit>(context).lastMessage;

  Future<void> sendMessage(
      {required Message messageInfo,
      Uint8List? pathOfPhoto,
      File? recordFile}) async {
    emit(MessageForGroupChatLoading());
    await _addMessageForGroupChatUseCase
        .call(
            paramsOne: messageInfo,
            paramsTwo: pathOfPhoto,
            paramsThree: recordFile)
        .then((value) {
      lastMessage = value;
      emit(MessageForGroupChatLoaded(value));
    }).catchError((e) {
      emit(MessageForGroupChatFailed(e));
    });
  }

  Future<void> deleteMessage(
      {required Message messageInfo,
      required String chatOfGroupUid,
      Message? replacedMessage}) async {
    emit(DeleteMessageForGroupChatLoading());
    await _deleteMessageForGroupChatUseCase
        .call(
            paramsOne: chatOfGroupUid,
            paramsTwo: messageInfo,
            paramsThree: replacedMessage!)
        .then((value) {
      emit(DeleteMessageForGroupChatLoaded());
    }).catchError((e) {
      emit(MessageForGroupChatFailed(e));
    });
  }
}
