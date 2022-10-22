part of '../../home.dart';

ShakeWidget deviceReorderBoxView(context, item, child) {
  final key = item.index;
  return ShakeWidget(
      key: ValueKey(key),
      duration: const Duration(seconds: 25),
      shakeConstant: ShakeDefaultConstant1(),
      autoPlay: true,
      enableWebMouseHover: true,
      child: Container(
          height: 200,
          width: 300,
          margin: const EdgeInsets.only(top: 25, left: 17.5, right: 17.5),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                offset: const Offset(1, 5),
                spreadRadius: -10,
                blurRadius: 10,
              ),
            ],
          ),
          child: child));
}
