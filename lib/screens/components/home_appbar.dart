part of '../home.dart';

AppBar homeAppBar(
    context, started, initHistory, thisHistory, resetThisHistory) {
  String warn = resp != null ? resp?.notification : '';
  final int initialLength = allDevicesDb().length;
  bool t = settings.get('themeMode');
  bool wsize = MediaQuery.of(context).size.width > 800;
  return AppBar(
      leadingWidth: 242,
      toolbarHeight: !wsize ? 50 : null,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SvgPicture.asset(
            !t ? AppImages.barLogoLight : AppImages.barLogo,
            semanticsLabel: 'Neptun Smart',
            fit: BoxFit.fitWidth,
            height: 50,
          ),
          wsize
              ? Text(
                  'Техническая поддержка: $phone',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w300,
                    fontSize: 10.3,
                  ),
                )
              : const SizedBox(),
        ],
      ),
      title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(warn),
          ]),
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
                        Navigator.pushNamed(context, '/settings').then((_) {
                          final nextLength = devices.values.toList();
                          if (!run && initialLength != nextLength.length) {
                            Rebuilder.of(context)?.rebuild();
                          } else if (!run &&
                              initialLength == nextLength.length) {
                            started();
                          }
                        });
                      },
                      child: Row(children: [
                        const Icon(
                          CupertinoIcons.gear,
                          size: 15,
                        ),
                        Text(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                            '   Настройки'),
                      ]),
                    ),
                    Badge(
                      badgeContent: Text('$thisHistory'),
                      position: wsize
                          ? BadgePosition.topEnd()
                          : BadgePosition.center(),
                      showBadge: initHistory - thisHistory != initHistory,
                      child: ElevatedButton(
                        onPressed: () {
                          resetThisHistory();
                          Navigator.pushNamed(context, '/history');
                        },
                        child: Row(children: [
                          const Icon(
                            CupertinoIcons.doc_text,
                            size: 15,
                          ),
                          Text(
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                              '   Журнал'),
                        ]),
                      ),
                    ),
                  ])
            ]),
      ]);
}
