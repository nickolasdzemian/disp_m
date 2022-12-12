part of '../../settings.dart';

Container settingsNaviWide(context, String route) {
  double wsize = MediaQuery.of(context).size.width;
  return Container(
      height: wsize > 800 ? 79 : 88,
      width: wsize > 800 ? 635 : wsize - 35,
      margin: const EdgeInsets.only(top: 25, left: 17.5, right: 17.5),
      padding: wsize > 800
          ? const EdgeInsets.all(20.0)
          : const EdgeInsets.only(top: 20, left: 10, right: 8, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Row(children: [
                    Icon(
                        color: Theme.of(context).colorScheme.secondary,
                        CupertinoIcons.calendar_today),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              style: subTitleStyle(context),
                              text: '  Расписание',
                            ),
                          ),
                          Text(
                              style: descStyle(context),
                              '   Настройки программирования')
                        ]),
                  ])
                ],
              ),
              IconButton(
                icon: Icon(
                  CupertinoIcons.right_chevron,
                  size: 22,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, route);
                },
              ),
            ],
          ),
        ],
      ));
}
