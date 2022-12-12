part of '../../counter.dart';

Future<void> _dialogBuilderCal(context, updateRange) {
  String title = 'Выбор диапазона';
  var startDate = DateTime.now().toLocal();
  var endDate = DateTime.now().toLocal().add(const Duration(days: 30));
  return showDialog<void>(
    context: context,
    builder: (BuildContext contextClean) {
      void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
        if (args.value.startDate.runtimeType != Null &&
            args.value.endDate.runtimeType != Null) {
          startDate = args.value.startDate;
          endDate = args.value.endDate;
        }
      }

      return AlertDialog(
        alignment: Alignment.center,
        title: Row(children: [
          Icon(
              color: Theme.of(context).colorScheme.secondary,
              CupertinoIcons.calendar_today),
          Text('   $title')
        ]),
        content: SizedBox(
            width: 600,
            height: 500,
            child: SfDateRangePickerTheme(
              data: SfDateRangePickerThemeData(
                headerTextStyle:
                    TextStyle(color: Theme.of(context).colorScheme.primary),
                activeDatesTextStyle:
                    TextStyle(color: Theme.of(context).colorScheme.primary),
                viewHeaderTextStyle:
                    TextStyle(color: Theme.of(context).colorScheme.primary),
                todayTextStyle:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              child: SfDateRangePicker(
                headerHeight: 80,
                monthViewSettings:
                    const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                showTodayButton: true,
                onSelectionChanged: onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
              ),
            )),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Отмена'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () {
              updateRange(startDate, endDate);
              Navigator.of(context).pop();
            },
            child: Text(
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                'Применить'),
          ),
        ],
      );
    },
  );
}
