part of '../../settings.dart';

Container settingsBoxView(context, child) {
  return Container(
      height: 200,
      width: 300,
      margin: const EdgeInsets.only(top: 25, left: 35),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        // boxShadow: [
        //   BoxShadow(
        //     color: Theme.of(context).colorScheme.shadow,
        //     offset: const Offset(1, 5),
        //     spreadRadius: -10,
        //     blurRadius: 10,
        //   ),
        // ],
      ),
      child: child);
}
