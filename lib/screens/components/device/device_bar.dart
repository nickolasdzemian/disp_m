part of '../../device.dart';

AppBar deviceAppBar(context) {
  return AppBar(
    leading: IconButton(
      icon:
          Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.hammer,
            size: 22,
            color: Theme.of(context).colorScheme.primary,
          ),
          Text(
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              '  Конфигурация'),
        ]),
  );
}
