import 'dart:async';
import 'package:clock_app/models/alarm/alarm.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

enum status { start, stop }

class Model extends GetxController {
  List<Alarm> _alarms = [];

  // List<Alarm> get alarms => _alarms;

  static Database? _database;

  // List<bool> week = [false, false, false, false, false, false, false];

  // toggleWeek(int i) {
  //   week[i] = !week[i];
  //   notifyListeners();
  //   print(week);
  // }

  Future setDatabase() async {
    var directory = await getDatabasesPath();
    var path = join(directory, 'sahiny');
    _database =
        await openDatabase(path, version: 1, onCreate: onCreatingDatabase);
    return _database;
  }

  onCreatingDatabase(Database database, int version) async {
    await database.execute(
        '''CREATE TABLE sahiny(id INTEGER PRIMARY KEY autoincrement ,title TEXT ,datetime TEXT,isActive boolean )''');
  }

  Future deletedata(int id) async {
    if (_database == null) return;
    _database?.delete('sahiny', where: 'id=?', whereArgs: [id]);
    print('done');
    await allalarms();
    update();
  }

  Future deleteDataBase() async {
    if (_database == null) return;
    _database?.delete('sahiny');
    update();
  }

  int? stops = 0;
  int? starts = 0;
  int repeats = 0;

  setNumbers({int? stop, int? start, int? repeat}) {
    if (stops != 0 && starts != 0) {
      startTimer.cancel();
      stopTimer.cancel();
    }
    stops = stop!;
    starts = start!;
    repeats = repeat!;
    Repeat();
    update();
  }

  void Repeat() {
    if (repeats > 0) {
      stopCountDown();
    }
    update();
  }

  var stopTimer;
  var startTimer;
  stopCountDown() {
    repeats--;
    print('repeats is $repeats');
    int stop = stops!;
    stopTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (stops! > 0) {
        stops = stops! - 1;
      } else {
        stops = stop;
        timer.cancel();
        startCountDown();
      }
    });
  }

  startCountDown() {
    int start = starts!;
    startTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (starts! > 0) {
        starts = starts! - 1;
      } else {
        timer.cancel();
        starts = start;
        Repeat();
      }
    });
  }
  // Timer? time;
  // void countDown(int num, nu val) {
  //   // time.cancel();
  //   int stop = stops;
  //   int start = starts;
  //   print('0');
  //   // print('tapped 2');
  //   time = Timer.periodic(Duration(seconds: 1), (Timer timer) {
  //     // if (num < 0) {
  //     //   timer.cancel();
  //     //   print('1');
  //     //
  //     //   // update();
  //     // }
  //     // else
  //     if (num > 0) {
  //       num--;
  //       print('2');
  //       val == nu.stop ? stops = num : starts = num;
  //       // update();
  //     } else if (num == 0 && (starts > 0 || stops > 0)) {
  //       // timer.cancel();
  //       print('3');
  //       // timer.cancel();
  //       countDown(starts, nu.start);
  //     } else if (starts == 0 && stops == 0 && repeats > 0) {
  //       print(stops);
  //       print('4');
  //       print(starts);
  //       // timer.cancel();
  //       setNumbers(stop: stop, start: start, repeat: repeats);
  //     } else {
  //       timer.cancel();
  //       return;
  //     }
  //   });
  //
  //   update();
  // }

  Future<Database> get database async {
    print('....... start database');
    if (_database != null) return _database!;
    var database = await setDatabase();
    return database;
  }

  insertAlarm(Alarm alarm) async {
    var db = await database;
    var result = await db.insert('sahiny', alarm.toMap());
    print(' num in db : $result');
    return result;
  }

  toggle(int index, Alarm alarm) async {
    _alarms[index].isActive = !_alarms[index].isActive;
    await _database?.update('sahiny', _alarms[index].toMap(),
        where: 'id = ?', whereArgs: [_alarms[index].id]);
    update();
  }

  Future<List> allalarms() async {
    var db = await database;
    var all = await db.query('sahiny');
    _alarms = all.map((e) => Alarm.fromMap(e)).toList();
    print(_alarms.length);
    return _alarms;
  }

  delete(int id) async {
    var db = await database;
    return db.delete('sahiny', where: 'id = ?', whereArgs: [id]);
  }
}
