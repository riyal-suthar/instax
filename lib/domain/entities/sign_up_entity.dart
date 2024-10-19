import 'package:equatable/equatable.dart';
import 'package:instax/domain/entities/register_user.dart';

// class SignUpEntity extends Equatable {
//   final String name;
//   final String email;
//   final String password;
//   final String repeatedPassword;
//
//   SignUpEntity(
//       {required this.name,
//       required this.email,
//       required this.password,
//       required this.repeatedPassword});
//
//   @override
//   List<Object?> get props => [name, email, password, repeatedPassword];
// }

class SignUpEntity extends RegisteredUser {
  SignUpEntity({super.email, super.password});
}
