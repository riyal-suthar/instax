part of 'reply_info_cubit.dart';

abstract class ReplyInfoState extends Equatable {
  const ReplyInfoState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ReplyInfoInitial extends ReplyInfoState {
  @override
  List<Object> get props => [];
}

class ReplyInfoLoading extends ReplyInfoState {}

class ReplyInfoLoaded extends ReplyInfoState {
  final List<Comment> repliesOnComments;

  ReplyInfoLoaded(this.repliesOnComments);
}

class ReplyInfoFailure extends ReplyInfoState {
  final String error;

  ReplyInfoFailure(this.error);
}
