part of '../../settings.dart';

AppBar settingsAppBar(context, themeMode, changeTheme) {
  return AppBar(
    title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            CupertinoIcons.square_list,
            size: 27,
          ),
          Text('  Настройки'),
        ]),
    actions: [
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                _dialogAbout(context);
              },
              child: Row(children: [
                const Icon(
                  CupertinoIcons.info,
                  size: 15,
                ),
                Text(
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                    '   О приложении'),
              ]),
            ),
            ElevatedButton(
              onPressed: () {
                changeTheme(!themeMode);
              },
              child: Row(children: [
                const Icon(
                  CupertinoIcons.square_lefthalf_fill,
                  size: 15,
                ),
                Text(
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                    themeMode ? '   Темная тема' : '   Светлая тема'),
              ]),
            )
          ]),
    ],
  );
}
