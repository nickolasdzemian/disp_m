part of '../settings.dart';

Future<void> _dialogHelp(context, title, help) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext contextHelper) {
      return AlertDialog(
        alignment: Alignment.topLeft,
        title: Row(children: [
          Icon(
              color: Theme.of(context).colorScheme.secondary,
              CupertinoIcons.book),
          Text('  $title')
        ]),
        content: SingleChildScrollView(
            scrollDirection: Axis.vertical, child: Text(help)),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Закрыть'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
