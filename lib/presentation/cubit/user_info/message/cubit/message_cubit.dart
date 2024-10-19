import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instax/domain/entities/sender_receiver_info.dart';

import '../../../../../domain/usecases/message/commen/get_specific_chat_info.dart';
import '../../../../../domain/usecases/message/single_message/add_message.dart';
import '../../../../../domain/usecases/message/single_message/delete_message.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final AddMessageUseCase _addMessageUseCase;
  final GetSpecificChatInfoUseCase _getSpecificChatInfo;
  final DeleteMessageUseCase _deleteMessageUseCase;
  MessageCubit(this._addMessageUseCase, this._getSpecificChatInfo,
      this._deleteMessageUseCase)
      : super(MessageInitial());

  static MessageCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> sendMessage(
      {required Message messageInfo,
      Uint8List? pathOfPhoto,
      File? recordFile}) async {
    emit(SendMessageLoading());
    await _addMessageUseCase
        .call(
            paramsOne: messageInfo,
            paramsTwo: pathOfPhoto,
            paramsThree: recordFile)
        .then((value) {
      emit(SendMessageLoaded(value));
    }).catchError((e) {
      emit(SendMessageFailed(e));
    });
  }

  Future<void> getSpecificChatInfo(
      {required String chatUid, required bool isThatGroup}) async {
    emit(GetSpecificChatLoading());
    await _getSpecificChatInfo
        .call(paramsOne: chatUid, paramsTwo: isThatGroup)
        .then((value) {
      emit(GetSpecificChatLoaded(value));
    }).catchError((e) {
      emit(GetMessageFailed(e));
    });
  }

  Future<void> deleteMessage(
      {required Message messageInfo,
      Message? replacedMessage,
      bool isThatOnlyMessageInChat = false}) async {
    emit(DeleteMessageLoading());
    await _deleteMessageUseCase
        .call(
            paramsOne: messageInfo,
            paramsTwo: replacedMessage!,
            paramsThree: isThatOnlyMessageInChat)
        .then((value) {
      emit(DeleteMessageLoaded());
    }).catchError((e) {
      emit(SendMessageFailed(e));
    });
  }
}
