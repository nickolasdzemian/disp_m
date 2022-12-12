part of '../../history.dart';

Container editOrder(context, reorder, invertOrder) {
  List<String> list = <String>['true', 'false'];
  String parceToTxt(v) {
    String res = 'Ошибка';
    switch (v) {
      case 'true':
        res = 'Новые в конце  ';
        break;
      case 'false':
        res = 'Сначала новые  ';
        break;
    }
    return res;
  }

  String dropdownValue = reorder.toString();
  return Container(
      height: 33,
      width: 140,
      margin: const EdgeInsets.only(top: 2.5, bottom: 2.5, left: 5, right: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      child: DropdownButton<String>(
        key: UniqueKey(),
        alignment: AlignmentDirectional.center,
        value: dropdownValue,
        icon: reorder
            ? const Icon(size: 15, CupertinoIcons.sort_up)
            : const Icon(size: 15, CupertinoIcons.sort_down),
        elevation: 16,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        underline: const SizedBox(),
        onChanged: (String? value) {
          value == 'true' ? invertOrder(true) : invertOrder(false);
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            alignment: AlignmentDirectional.center,
            value: value,
            child: Text(style: titleStyle(context), parceToTxt(value)),
          );
        }).toList(),
      ));
}

Container editFliter(context, reorder, filterValue, filterType) {
  List<String> list = <String>['-1', '10', '0', '1', '2', '3', '4', '5', '6'];
  String parceToTxt(v) {
    String res = 'Ошибка';
    switch (v) {
      case '-1':
        res = 'По умолчанию  ';
        break;
      case '10':
        res = 'Показать все  ';
        break;
      case '0':
        res = 'Тревога  ';
        break;
      case '1':
        res = 'Потеря  ';
        break;
      case '2':
        res = 'Разряд  ';
        break;
      case '3':
        res = 'Нет связи  ';
        break;
      case '4':
        res = 'Системные  ';
        break;
      case '5':
        res = 'Счётчики  ';
        break;
      case '6':
        res = 'Превышение  ';
        break;
    }
    return res;
  }

  String dropdownValue = filterValue.toString();
  return Container(
      height: 33,
      width: 140,
      margin: const EdgeInsets.only(top: 2.5, bottom: 2.5, left: 5, right: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      child: DropdownButton<String>(
        key: UniqueKey(),
        alignment: AlignmentDirectional.center,
        value: dropdownValue,
        icon: const Icon(size: 15, CupertinoIcons.folder),
        elevation: 16,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        underline: const SizedBox(),
        onChanged: (String? value) {
          int apply = int.parse(value.toString());
          filterType(reorder, apply);
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            alignment: AlignmentDirectional.center,
            value: value,
            child: Text(style: titleStyle(context), parceToTxt(value)),
          );
        }).toList(),
      ));
}

Container clearButton(context, updateState) {
  return Container(
    height: 33,
    width: 140,
    margin: const EdgeInsets.only(top: 2.5, bottom: 2.5, left: 5, right: 5),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      borderRadius: const BorderRadius.all(Radius.circular(50)),
    ),
    child: TextButton(
      onPressed: () {
        _dialogBuilderClean(context, updateState);
      },
      child: Text(style: titleStyleErr(context), 'Очистка'),
    ),
  );
}

Container exportButton(context, allevents) {
  return Container(
    height: 33,
    width: 140,
    margin: const EdgeInsets.only(top: 2.5, bottom: 2.5, left: 5, right: 5),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      borderRadius: const BorderRadius.all(Radius.circular(50)),
    ),
    child: TextButton(
      onPressed: () {
        _dialogBuilderExport(context, allevents);
      },
      child: Text(style: titleStyleBl(context), 'Экспорт'),
    ),
  );
}
