import 'package:flutter/material.dart';
import 'package:instax/config/routes/app_routes.dart';
import 'package:instax/presentation/pages/messages/select_for_group_chat.dart';
import 'package:instax/presentation/pages/messages/widgets/list_of_messages.dart';
import '../../../core/utils/constants.dart';

class MessagesPageForMobile extends StatelessWidget {
  const MessagesPageForMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isThatMobile ? buildAppBar(context) : null,
      body: const ListOfMessages(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        IconButton(
          onPressed: () {
            Go(context).push(page: const SelectForGroupChat());
          },
          icon: Icon(
            Icons.add,
            color: Theme.of(context).focusColor,
            size: 30,
          ),
        )
      ],
    );
  }
}
