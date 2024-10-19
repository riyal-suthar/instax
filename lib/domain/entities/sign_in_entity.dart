import 'package:equatable/equatable.dart';
import 'package:instax/domain/entities/register_user.dart';

// class SignInEntity extends Equatable {
//   final String email;
//   final String password;
//
//   SignInEntity({required this.email, required this.password});
//
//   @override
//   List<Object?> get props => [email, password];
// }

class SignInEntity extends RegisteredUser {
  SignInEntity({super.email, super.password});
}
