part of '../../settings.dart';

AppBar settingsAppBar(context, themeMode, changeTheme, update, appName,
    packageName, version, buildNumber, newVersion) {
  bool wsize = MediaQuery.of(context).size.width > 800;
  return AppBar(
    toolbarHeight: !wsize ? 50 : null,
    leading: IconButton(
      icon:
          Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: wsize
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Icon(
                  CupertinoIcons.square_list,
                  size: 27,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text(
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    '  Настройки'),
              ])
        : const SizedBox(),
    actions: [
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
                direction: wsize ? Axis.vertical : Axis.horizontal,
                spacing: wsize ? 3 : 10,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _dialogAbout(context, update, appName, packageName,
                          version, buildNumber, newVersion);
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
                ])
          ]),
    ],
  );
}
