import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/calling_room/get_calling_status.dart';

part 'calling_status_event.dart';
part 'calling_status_state.dart';

class CallingStatusBloc extends Bloc<CallingStatusEvent, CallingStatusState> {
  final GetCallingStatusUseCase _getCallingStatusUseCase;
  CallingStatusBloc(this._getCallingStatusUseCase)
      : super(CallingStatusInitial()) {
    on<LoadCallingStatus>((event, emit) async => await emit.onEach(
        _getCallingStatusUseCase.call(params: event.channelUid),
        onData: (status) => add(UpdateCallingStatus(status)),
        onError: (e, s) => emit(CallingStatusFailed(e.toString()))));
    on<UpdateCallingStatus>((event, emit) =>
        emit(CallingStatusLoaded(callingStatus: event.callingStatus)));
  }

  // static CallingStatusBloc get(BuildContext context) =>
  //     BlocProvider.of(context);

  // @override
  // Stream<CallingStatusState> mapEventToState(CallingStatusEvent event) async* {
  //   if (event is LoadCallingStatus) {
  //     yield* _mapLoadInfoToState(event.channelUid);
  //   } else if (event is UpdateCallingStatus) {
  //     yield* _mapUpdateInfoToState(event);
  //   }
  // }

  // Stream<CallingStatusState> _mapLoadInfoToState(String channelUid) async* {
  //   // _getCallingStatusUseCase.call(params: channelUid).listen((isHeOnline) {
  //   //   add(UpdateCallingStatus(isHeOnline));
  //   }).onError((e) async* {
  //     yield CallingStatusFailed(e.toString());
  //   });
  // }
  //
  // Stream<CallingStatusState> _mapUpdateInfoToState(
  //     UpdateCallingStatus event) async* {
  //   yield CallingStatusLoaded(callingStatus: event.callingStatus);
  // }
}
