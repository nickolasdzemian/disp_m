// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:neptun_m/db/db.dart';
import 'package:neptun_m/lib/models.dart';
import 'package:neptun_m/lib/err_push.dart';
import 'package:neptun_m/lib/setters.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_multipart/form_data.dart';

part 'responses.dart';
part 'egg.dart';

// #############################################################################
// #                            LOCAL SERVER (API)                             #
// #############################################################################
var server;
// bool isTurned = false; // See comments below
String api = 'Сервер не активен';
String userport = '3003';

void killServe() {
  server?.close();
  server = null;
}

List<Device> _all = [];
List<DeviceState> serveStates = [];
List<EventItem> _events = [];
List<CounterSItem> _cstats = [];

/// Runs local server
serve() async {
  Future init() async {
    userport = settings.get('serverPort').toString();
    for (var interface in await NetworkInterface.list()) {
      // print('== Interface: ${interface.name} ==');
      for (var addr in interface.addresses) {
        api = '${addr.type.name} ${addr.address}:$userport';
        // print(api);
      }
    }
  }

  init();

  final port = int.parse(Platform.environment['PORT'] ?? userport);
  final router = shelf_router.Router()
    ..get('/api/devices/<mac>', _allDevicesHandler)
    ..get('/api/states/<name>', _deviceState)
    ..get('/api/events/<date1>/<date2>', _eventList)
    ..get('/api/stats/<mac>/<num>/<date1>/<date2>', _statList)
    ..get(
      '/api/time',
      (request) => Response.ok(DateTime.now().toUtc().toIso8601String()),
    )
    ..get('/api/info.json', _infoHandler)
    ..post('/api/device/<mac>', _command);

  final cascade = Cascade().add(router);

  // if (!isTurned) {
  //   isTurned = true;
  //   // This is not really used because of restarting whole app via btn at home
  //   // PUT server = await shelf_io.serve here to avoid shared port errors
  // }
  try {
    server = await shelf_io.serve(
      cascade.handler,
      shared: true,
      InternetAddress.anyIPv4,
      port,
    );
    _watch.start();
  } catch (e) {
    showErrPush('Ошибка запуска локального сервера\n${e.toString()}');
    DataBase.updateEventList([
      4,
      'Локальный сервер',
      'Ошибка запуска локального сервера\n${e.toString()}',
    ]);
  }
}
