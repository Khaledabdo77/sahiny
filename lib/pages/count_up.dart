import 'dart:async';

enum CountMode { start, stop, reset }

class CountTimer {
  int _start = 0;
  int sec = 0;
  bool isRunning = false;
  int min = 0;

  String get start => _start.toString().padLeft(2, '0');

  void inisialize({CountMode mode = CountMode.stop}) {
    Timer.periodic(Duration(seconds: 1), (timer) {
      isRunning = true;
      if (mode == CountMode.start) {
        __start();
      } else if (mode == CountMode.stop) {
        timer.cancel();
      } else {
        _start = 0;
        sec = 0;
        min = 0;
      }
    }
        // } else {
        //   _start = _start! + timer.tick;
        // }
        );
  }

  __start() {
    _start++;
    if (_start % 60 == 0) {
      _start %= 60;
      min++;
    }
  }
}
