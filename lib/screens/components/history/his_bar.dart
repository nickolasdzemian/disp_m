part of '../../history.dart';

AppBar historyAppBar(context, reorder, filterValue, invertOrder, filterType,
    updateState, allevents) {
  return AppBar(
    leading: IconButton(
      icon:
          Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.doc_text,
            size: 22,
            color: Theme.of(context).colorScheme.primary,
          ),
          Text(
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              '  Журнал событий'),
        ]),
    actions: [
      Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              clearButton(context, updateState),
              exportButton(context, allevents),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              editOrder(context, reorder, invertOrder),
              editFliter(context, reorder, filterValue, filterType),
            ],
          )
        ],
      )
    ],
  );
}
