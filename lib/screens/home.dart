import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neptun_m/screens/assets.dart';
import 'package:neptun_m/lib/getters.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neptun_m/db/db.dart';
import 'package:neptun_m/lib/getters.dart';
import 'package:neptun_m/screens/settings.dart';

part 'components/home_appbar.dart';

@immutable
class HomePage extends StatelessWidget {
  const HomePage({Key? key, this.title}) : super(key: key);

  // var all = allDevicesDb();
  // var set = allSettingsDb();
  // var jou = allEventsDb();
  // bool fuckOrNotFuck = true;

  // @protected
  // @mustCallSuper
  // void initState() {
  //   if (devices.isNotEmpty) context.read<StatesModel>().zaloop();
  // }

  final String? title;

  @override
  Widget build(BuildContext context) {
    void started() async {
      if (allDevicesDb().isNotEmpty) await context.read<StatesModel>().zaloop();
    }

    started();

    return BlocBuilder<StatesModel, List>(
      buildWhen: (previousState, state) {
        return previousState != state;
      },
      builder: (context, devicesStatesNew) => Scaffold(
          appBar: homeAppBar(context, started),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CircularProgressIndicator(),
                Text(
                  'ВЫЕБИ!!!',
                ),
              ],
            ),
          )),
    );
  }
}
