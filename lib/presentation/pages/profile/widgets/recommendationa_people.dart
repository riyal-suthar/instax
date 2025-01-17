import 'package:flutter/material.dart';
import 'package:instax/presentation/cubit/user_info/users_info_in_reel_time/users_info_in_reel_time_bloc.dart';

class RecommendationPeople extends StatelessWidget {
  const RecommendationPeople({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        UsersInfoInReelTimeBloc.get(context).add(LoadAllUsersInfo());
      },
      child: Container(
        height: 35.0,
        width: 35,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(
              color: Theme.of(context).bottomAppBarTheme.color!, width: 1.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Icon(Icons.person_add_outlined,
              color: Theme.of(context).focusColor),
        ),
      ),
    );
  }
}
