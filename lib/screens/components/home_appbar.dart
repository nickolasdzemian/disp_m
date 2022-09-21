part of '../home.dart';

AppBar homeAppBar(context, started) {
  return AppBar(
      leadingWidth: 242,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SvgPicture.asset(
            AppImages.barLogo,
            semanticsLabel: 'Neptun Smart',
            fit: BoxFit.fitWidth,
            height: 50,
          ),
          Text(
            'Техническая поддержка: +7 (903) 666 11 28',
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w300,
              fontSize: 8,
            ),
          ),
        ],
      ),
      actions: [
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/settings').then((_) {
                    started();
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
              ElevatedButton(
                onPressed: () {
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
              )
            ]),
      ]);
  // body: BlocBuilder<StatesModel, String>(
  //     buildWhen: (previousState, state) {
  //       return previousState != state;
  //     },
  //     builder: (context, count) => Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               CircularProgressIndicator(),
  //               Text(
  //                 'You have pushed the button this many times: $count',
  //               ),
  //               // Consumer<StatesModel>(builder: (context, viewModel, child) {
  //               //   return Text(
  //               //     '${context.watch<StatesModel>().counter}',
  //               //     style: Theme.of(context).textTheme.headline4,
  //               //   );
  //               // }),
  //             ],
  //           ),
  //         )),
  // floatingActionButton: FloatingActionButton(
  //   onPressed: (() {
  //     // Provider.of<StatesModel>(context, listen: false).zaloop();
  //     fuckOrNotFuck ? context.read<StatesModel>().zaloop() : stopTimer();
  //     fuckOrNotFuck = !fuckOrNotFuck;
  //   }),
  //   tooltip: 'Increment',
  //   child: const Icon(Icons.account_tree_rounded),
  // ),
}
