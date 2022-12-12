import 'package:flutter/material.dart';

Container resizeBox(context, child) {
  double wsize = MediaQuery.of(context).size.width;
  return Container(
      width: 635,
      margin: const EdgeInsets.only(top: 25, left: 17.5, right: 17.5),
      padding: wsize > 800
          ? const EdgeInsets.all(20.0)
          : const EdgeInsets.only(top: 20, left: 10, right: 8, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: child);
}
