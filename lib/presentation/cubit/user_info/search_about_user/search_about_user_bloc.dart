import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../../domain/usecases/user/getUseInfo/search_about_user_usecase.dart';

part 'search_about_user_event.dart';
part 'search_about_user_state.dart';

class SearchAboutUserBloc
    extends Bloc<SearchAboutUserEvent, SearchAboutUserState> {
  final SearchAboutUserUseCase _searchAboutUserUseCase;
  SearchAboutUserBloc(this._searchAboutUserUseCase)
      : super(SearchAboutUserInitial()) {
    on<SearchAboutUserEvent>((event, emit) async {
      if (event is FindSpecificUser) {
        await emit.onEach(
            _searchAboutUserUseCase.call(
                paramsOne: event.name, paramsTwo: event.searchForSingleLetter),
            onData: (users) => add(UpdateUser(users)));
      } else if (event is UpdateUser) {
        return emit(SearchAboutUserLoaded(users: event.users));
      }
    });
  }

  static SearchAboutUserBloc get(BuildContext context) =>
      BlocProvider.of(context);

  // @override
  // Stream<SearchAboutUserState> mapEventToState(
  //     SearchAboutUserEvent event) async* {
  //   if (event is FindSpecificUser) {
  //     yield* _mapLoadSearchToState(event.name, event.searchForSingleLetter);
  //   } else if (event is UpdateUser) {
  //     yield* _mapUpdateSearchToState(event);
  //   }
  // }

  // Stream<SearchAboutUserState> _mapLoadSearchToState(
  //     String receiverId, bool searchforSingleLetter) async* {
  //   _searchAboutUserUseCase
  //       .call(paramsOne: receiverId, paramsTwo: searchforSingleLetter)
  //       .listen((users) => add(UpdateUser(users)));
  // }
  //
  // Stream<SearchAboutUserState> _mapUpdateSearchToState(
  //     UpdateUser event) async* {
  //   yield SearchAboutUserLoaded(users: event.users);
  // }
}
