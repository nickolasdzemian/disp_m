part of '../../home.dart';

TextStyle titleStyle(context) {
  return TextStyle(
    color: Theme.of(context).colorScheme.primary,
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
