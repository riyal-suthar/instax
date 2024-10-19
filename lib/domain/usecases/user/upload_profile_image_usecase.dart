import 'dart:typed_data';

import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class UploadProfileImageUseCase
    implements UseCaseThreeParams<String, Uint8List, String, String> {
  final FireStoreUserRepository _userRepository;

  UploadProfileImageUseCase(this._userRepository);

  @override
  Future<String> call(
          {required Uint8List paramsOne,
          required String paramsTwo,
          required String paramsThree}) =>
      _userRepository.uploadProfileImage(
          photo: paramsOne, userId: paramsTwo, previousImageUrl: paramsThree);
}
