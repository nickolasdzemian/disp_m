part of '../../home.dart';

deviceItemReorder(context, item) {
  final key = item.hashCode;
  var name = item.name;
  return Column(
      key: ValueKey(key),
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(AppImages.deviceImg, width: 80),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Text(style: subTitleStyle(context), '$name'),
            Text(style: descStyle(context), 'IP-адрес: ${item.ip}'),
            Text(style: descStyle(context), 'Mac-адрес: ${item.mac}'),
            const SizedBox(height: 42),
          ],
        ),
        Text(style: bigValueStyle(context), '${item.index + 1}'),
      ]);
}
