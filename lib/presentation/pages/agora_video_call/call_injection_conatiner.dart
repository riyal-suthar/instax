import 'package:get_it/get_it.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/agora/call_remote_data_source_impl.dart';
import 'package:instax/data/repositories/agora/call_repo_impl.dart';
import 'package:instax/domain/repositories/agora_video_call_repository.dart';
import 'package:instax/domain/usecases/agora_usecases/end_call_usecase.dart';
import 'package:instax/domain/usecases/agora_usecases/get_call_channelId_usecase.dart';
import 'package:instax/domain/usecases/agora_usecases/get_my_call_history_usecase.dart';
import 'package:instax/domain/usecases/agora_usecases/get_user_calling_usecase.dart';
import 'package:instax/domain/usecases/agora_usecases/make_call_usecase.dart';
import 'package:instax/domain/usecases/agora_usecases/save_call_history_usecase.dart';
import 'package:instax/domain/usecases/agora_usecases/update_call_history_status_usecase.dart';
import 'package:instax/presentation/cubit/agora_cubit/agora/agora_cubit.dart';
import 'package:instax/presentation/cubit/agora_cubit/call/call_cubit.dart';
import 'package:instax/presentation/cubit/agora_cubit/my_call_history/my_call_history_cubit.dart';

Future<void> callInjectionContainer() async {
  // * CUBITS INJECTION
  final sl = GetIt.instance;

  sl.registerFactory<CallCubit>(() => CallCubit(
      endCallUseCase: sl.call(),
      getUserCallingUseCase: sl.call(),
      makeCallUseCase: sl.call(),
      saveCallHistoryUseCase: sl.call(),
      updateCallHistoryStatusUseCase: sl.call()));

  sl.registerFactory<MyCallHistoryCubit>(
      () => MyCallHistoryCubit(getMyCallHistoryUseCase: sl.call()));

  sl.registerLazySingleton<AgoraCubit>(() => AgoraCubit());

  // * USE CASES INJECTION

  sl.registerLazySingleton<GetMyCallHistoryUseCase>(
      () => GetMyCallHistoryUseCase(repository: sl.call()));

  sl.registerLazySingleton<EndCallUseCase>(
      () => EndCallUseCase(repository: sl.call()));

  sl.registerLazySingleton<SaveCallHistoryUseCase>(
      () => SaveCallHistoryUseCase(repository: sl.call()));

  sl.registerLazySingleton<MakeCallUseCase>(
      () => MakeCallUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetUserCallingUseCase>(
      () => GetUserCallingUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetCallChannelIdUseCase>(
      () => GetCallChannelIdUseCase(repository: sl.call()));

  sl.registerLazySingleton<UpdateCallHistoryStatusUseCase>(
      () => UpdateCallHistoryStatusUseCase(repository: sl.call()));

  // * REPOSITORY & DATA SOURCES INJECTION

  sl.registerLazySingleton<CallRepository>(
      () => CallRepositoryImpl(remoteDataSource: sl.call()));

  sl.registerLazySingleton<CallRemoteDataSource>(() => CallRemoteDataSourceImpl(
        fireStore: sl.call(),
      ));
}
