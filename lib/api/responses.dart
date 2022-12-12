// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables

part of './route.dart';

// ###########################################################################
// #                            RESPONSE FUNCS                               #
// ###########################################################################
const _jsonHeaders = {
  'content-type': 'application/json',
};
final _watch = Stopwatch();
int requestCount = 0;
final _dartVersion = () {
  final version = Platform.version;
  return version.substring(0, version.indexOf(' '));
}();
String _jsonEncode(Object? data) =>
    const JsonEncoder.withIndent(' ').convert(data);
_errHandle(e) {
  finresp = Response(
    403,
    headers: {
      ..._jsonHeaders,
      'Cache-Control': 'no-store',
    },
    body: 'Неверный запрос или ошибка сервера\n${e.toString()}\n$che',
  );
}

_succHandle(String s) {
  finresp = Response(
    200,
    headers: {
      ..._jsonHeaders,
      'Cache-Control': 'no-store',
    },
    body: s,
  );
}

// ********************************  GET  **************************************
Response _infoHandler(Request request) {
  requestCount++;
  return Response(
    200,
    headers: {
      ..._jsonHeaders,
      'Cache-Control': 'no-store',
    },
    body: _jsonEncode(
      {
        'Dart version': _dartVersion,
        'uptime': _watch.elapsed.toString(),
        'requestCount': requestCount,
        'developer': 'Nickolay Pozdnyakov (t.me/ndzz666)',
        'info':
            'If you want simplified API reponses without parsing data on your side or some custom functions, please, contact us.',
      },
    ),
  );
}

Response finresp = Response(
  403,
  headers: {
    ..._jsonHeaders,
    'Cache-Control': 'no-store',
  },
  body: 'Неверный запрос или ошибка сервера',
);

Response _allDevicesHandler(Request request) {
  requestCount++;
  try {
    var who = request.params['mac'];
    _all = devices.values.toList();
    List resp = who == 'all'
        ? _all
        : _all.where((element) => element.name == who).toList();
    finresp = Response(
      200,
      headers: {
        ..._jsonHeaders,
        'Cache-Control': 'no-store',
      },
      body: jsonEncode(resp),
    );
  } catch (e) {
    _errHandle(e);
  }
  return finresp;
}

Response _deviceState(Request request) {
  requestCount++;
  try {
    var who = request.params['name'];
    List resp = who == 'all'
        ? serveStates
        : serveStates.where((element) => element.name == who).toList();
    finresp = Response(
      200,
      headers: {
        ..._jsonHeaders,
        'Cache-Control': 'no-store',
      },
      body: jsonEncode(resp),
    );
  } catch (e) {
    _errHandle(e);
  }
  return finresp;
}

Response _eventList(Request request) {
  requestCount++;
  try {
    // DateTime format is ISO 8601
    DateTime date1 = DateTime.parse(request.params['date1']!);
    DateTime date2 = DateTime.parse(request.params['date2']!);
    _events = events.values.toList();
    List<EventItem> resp = _events
        .where((element) =>
            element.timestamp.isAfter(date1) &&
            element.timestamp.isBefore(date2))
        .toList();
    finresp = Response(
      200,
      headers: {
        ..._jsonHeaders,
        'Cache-Control': 'no-store',
      },
      body: jsonEncode(resp),
    );
  } catch (e) {
    _errHandle(e);
  }
  return finresp;
}

Response _statList(Request request) {
  requestCount++;
  try {
    // DateTime format is ISO 8601
    DateTime date1 = DateTime.parse(request.params['date1']!);
    DateTime date2 = DateTime.parse(request.params['date2']!);
    String key = '${request.params['mac']!}-CS${request.params['num']!}';
    _cstats = cstats.get(key)!.cast();
    inspect(_events);
    List<CounterSItem> resp = _cstats
        .where((element) =>
            element.date.isAfter(date1) && element.date.isBefore(date2))
        .toList();
    finresp = Response(
      200,
      headers: {
        ..._jsonHeaders,
        'Cache-Control': 'no-store',
      },
      body: jsonEncode(resp),
    );
  } catch (e) {
    _errHandle(e);
  }
  return finresp;
}

// *******************************  POST  **************************************
Future<Response> _command(Request request) async {
  requestCount++;
  try {
    if (request.isMultipartForm) {
      _all = devices.values.toList();
      List<Device> _device = _all
          .where((element) => element.mac == request.params['mac'])
          .toList();

      List<DeviceState> _devstate = serveStates
          .where((element) => element.index == _device[0].index)
          .toList();

      if (_device.length == 1 && _devstate.length == 1) {
        final parameters = <String, String>{
          await for (final formData in request.multipartFormData)
            formData.name: await formData.part.readString(),
        };
        parameters.values.cast();
        int reg = 0;
        String val = '0';
        int length = 0;
        int idx = 0;
        var updReg;
        List valueMap = parameters.values.toList();
        List keyMap = parameters.keys.toList();
        if (parameters.length == 4) {
          for (int k = 0; k < parameters.length; k++) {
            switch (keyMap[k]) {
              case 'register':
                reg = int.parse(valueMap[k]);
                break;
              case 'value':
                val = valueMap[k].toString();
                break;
              case 'length':
                length = int.parse(valueMap[k]);
                break;
              case 'index':
                idx = int.parse(valueMap[k]);
                break;
            }
          }
        } else {
          _errHandle('Неверное кол-во параметров запроса');
        }
        updReg = await sendOneRegister(_devstate[0].registersStates[0].value,
            idx, val, length, reg, _device[0]);
        if (updReg[0]) {
          _succHandle('Команда успешно выполнена и применена на устройстве');
        } else {
          _succHandle('Команда не выполнена');
        }
      } else {
        _errHandle('Устройство не найдено или не в сети');
      }
    } else {
      _succHandle('Not a multipart request');
    }
  } catch (e) {
    _errHandle(e);
  }
  return finresp;
}
