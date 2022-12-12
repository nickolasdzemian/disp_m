part of '../../device.dart';

AppBar deviceAppBar(context, timer) {
  bool wsize = MediaQuery.of(context).size.width > 800;
  return AppBar(
    toolbarHeight: !wsize ? 50 : null,
    leading: IconButton(
      icon:
          Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
      onPressed: () {
        timer?.cancel();
        Navigator.of(context).pop();
      },
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
