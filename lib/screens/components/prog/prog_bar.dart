import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

AppBar progAppBar(context) {
  bool wsize = MediaQuery.of(context).size.width > 800;
  return AppBar(
    toolbarHeight: !wsize ? 50 : null,
    leading: IconButton(
      icon:
          Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),
    title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.calendar,
            size: 22,
            color: Theme.of(context).colorScheme.primary,
          ),
          Text(
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              '  Расписание'),
        ]),
  );
}
