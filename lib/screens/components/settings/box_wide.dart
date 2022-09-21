part of '../../settings.dart';

Container settingsBoxWide(context, child) {
  return Container(
      height: 375,
      width: 635,
      margin: const EdgeInsets.only(top: 25, left: 35),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: child);
}
