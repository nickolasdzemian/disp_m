part of '../../settings.dart';

Container settingsBoxView(context, child) {
  return Container(
      height: 200,
      width: 300,
      margin: const EdgeInsets.only(top: 25, left: 17.5, right: 17.5),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: child);
}
