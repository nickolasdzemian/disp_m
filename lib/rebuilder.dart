import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neptun_m/screens/assets.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:neptun_m/db/db.dart';
import './screens/theme/theme.dart';

typedef ErrorBuilder = Widget Function(BuildContext context, Object error);

typedef Builder = FutureOr<Widget> Function(BuildContext context, Widget child);

class Rebuilder extends StatefulWidget {
  /// called when while is waiting for [builder].
  final WidgetBuilder waiting;

  /// called when [builder] throw an error.
  final ErrorBuilder errorBuilder;

  /// called on [initState] or [Rebuilder.of(context).rebuild()].
  final Builder builder;

  /// use child for part of your widget with no need to be rebuilded.
  final Widget child;

  const Rebuilder({
    required Key key,
    required this.waiting,
    required this.errorBuilder,
    required this.builder,
    required this.child,
  }) : super(key: key);

  @override
  RebuilderState createState() => RebuilderState();

  static RebuilderState? of(BuildContext context) {
    return context.findAncestorStateOfType<RebuilderState>();
  }
}

class RebuilderState extends State<Rebuilder> {
  late Widget _child;

  @override
  void initState() {
    super.initState();
    _child = widget.waiting(context);
    _futureBuilder(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _child,
    );
  }

  void rebuild() {
    DataBase.updateEventList([
      4,
      'Перезапуск состояния системы',
      'Запрошен перезапуск дерева состояний приложения',
    ]);
    setState(() => _child = widget.waiting(context));
    _futureBuilder(context);
  }

  Future<void> _futureBuilder(BuildContext context) async {
    try {
      final w = await widget.builder(context, widget.child);
      setState(() => _child = w);
    } catch (e) {
      setState(() => _child = widget.errorBuilder(context, e));
    }
  }
}

class Waiting extends StatelessWidget {
  const Waiting({super.key});
  @override
  Widget build(BuildContext context) {
    bool t = settings.get('themeMode');
    return MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: t ? ThemeMode.light : ThemeMode.dark,
        home: Scaffold(
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
              ShakeWidget(
                  duration: const Duration(seconds: 20),
                  shakeConstant: ShakeVerticalConstant1(),
                  autoPlay: true,
                  enableWebMouseHover: true,
                  child: SvgPicture.asset(
                    !t ? AppImages.barLogoLight : AppImages.barLogo,
                    semanticsLabel: 'Neptun Smart',
                    fit: BoxFit.fitWidth,
                    height: 50,
                  )),
              const Text(
                textAlign: TextAlign.center,
                '\n',
              ),
              CircularProgressIndicator(
                  strokeWidth: 5,
                  color: Theme.of(context).colorScheme.secondary),
            ]))));
  }
}

rebuildErr() {
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 300,
            height: 300,
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 40, bottom: 65),
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.white10,
                  spreadRadius: 5,
                  blurRadius: 1,
                ),
              ],
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShakeWidget(
                      duration: const Duration(seconds: 20),
                      shakeConstant: ShakeVerticalConstant1(),
                      autoPlay: true,
                      enableWebMouseHover: true,
                      child: SvgPicture.asset(
                        AppImages.barLogo,
                        semanticsLabel: 'Neptun Smart',
                        fit: BoxFit.fitWidth,
                        height: 50,
                      )),
                  const CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 255, 255, 255))),
                ]))
      ]);
}
