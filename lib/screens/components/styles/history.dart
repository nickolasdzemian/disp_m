part of '../../history.dart';

TextStyle titleStyle(context) {
  return TextStyle(
    color: Theme.of(context).colorScheme.primary,
    fontWeight: FontWeight.normal,
    fontSize: 12,
  );
}

TextStyle titleStyleErr(context) {
  return TextStyle(
    color: Theme.of(context).colorScheme.error,
    fontWeight: FontWeight.normal,
    fontSize: 12,
  );
}

TextStyle titleStyleBl(context) {
  return TextStyle(
    color: Theme.of(context).colorScheme.secondary,
    fontWeight: FontWeight.normal,
    fontSize: 12,
  );
}

TextStyle subTitleStyle(context) {
  return TextStyle(
    color: Theme.of(context).colorScheme.primary,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
}

TextStyle subTitleValueStyle(context) {
  return TextStyle(
    color: Theme.of(context).colorScheme.primary,
    fontWeight: FontWeight.normal,
    fontSize: 14,
  );
}

TextStyle bigValueStyle(context) {
  return TextStyle(
    color: Theme.of(context).colorScheme.secondary,
    fontWeight: FontWeight.w600,
    fontSize: 25,
  );
}

TextStyle bigValueIntStyle(context, bigValue) {
  return TextStyle(
    color: (bigValue < 3 || bigValue > 200)
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.secondary,
    fontWeight: FontWeight.w600,
    fontSize: 25,
  );
}

TextStyle descStyle(context) {
  return TextStyle(
    color: Theme.of(context).colorScheme.primary,
    fontWeight: FontWeight.w200,
    fontSize: 10,
  );
}

TextStyle descButton(context) {
  return TextStyle(
    color: Theme.of(context).colorScheme.secondary,
    fontWeight: FontWeight.w300,
    fontSize: 10,
  );
}

Container linesBox(child, context) {
  return Container(
      key: UniqueKey(),
      // height: 200,
      // width: 300,
      margin: const EdgeInsets.only(top: 5, bottom: 25, left: 5, right: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: child);
}
