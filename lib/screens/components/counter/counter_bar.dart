part of '../../counter.dart';

AppBar counterAppBar(context, title, key, updateState, allevents, devname) {
  bool wsize = MediaQuery.of(context).size.width > 800;
  Container clearButton() {
    return Container(
      height: 33,
      width: 140,
      margin:
          EdgeInsets.only(top: wsize ? 2.5 : 7, bottom: 2.5, left: 5, right: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      child: TextButton(
        onPressed: () {
          _dialogBuilderClean(context, updateState, key);
        },
        child: Text(style: titleStyleErr(context), 'Очистка'),
      ),
    );
  }

  Container exportButton() {
    return Container(
      height: 33,
      width: 140,
      margin:
          EdgeInsets.only(top: wsize ? 2.5 : 7, bottom: 2.5, left: 5, right: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      child: TextButton(
        onPressed: () {
          _dialogBuilderExport(context, allevents, title, devname);
        },
        child: Text(style: titleStyleBl(context), 'Экспорт'),
      ),
    );
  }

  return AppBar(
      toolbarHeight: !wsize ? 50 : null,
      leading: IconButton(
        icon: Icon(Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: MediaQuery.of(context).size.width > 800
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Icon(
                    CupertinoIcons.gauge,
                    size: 22,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      '  $title'),
                ])
          : const SizedBox(),
      actions: [
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                direction: wsize ? Axis.vertical : Axis.horizontal,
                children: [
                  clearButton(),
                  exportButton(),
                ],
              ),
            ])
      ]);
}
