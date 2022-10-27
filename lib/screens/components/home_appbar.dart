part of '../home.dart';

AppBar homeAppBar(
    context, started, initHistory, thisHistory, resetThisHistory) {
  String phone = resp != null ? resp?.support : '+7 (903) 666 11 28';
  String warn = resp != null ? resp?.notification : '';
  final int initialLength = allDevicesDb().length;
  bool t = settings.get('themeMode');
  return AppBar(
      leadingWidth: 242,
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
          Text(
            'Техническая поддержка: $phone',
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w300,
              fontSize: 10.3,
            ),
          ),
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
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/settings').then((_) {
                    final nextLength = devices.values.toList();
                    if (!run && initialLength != nextLength.length) {
                      equalal0 = [];
                      equalal1 = [];
                      Rebuilder.of(context)?.rebuild();
                    } else if (!run && initialLength == nextLength.length) {
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
            ]),
      ]);
}
