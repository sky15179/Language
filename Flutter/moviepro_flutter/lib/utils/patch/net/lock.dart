import 'dart:async';

/**
 * @Description: 
 * @Author: 王智刚
 * @Date: 2020-05-29 14:47:36
 * @LastEditTime: 2020-05-29 15:00:09
 * @LastEditors:  
 */

class Lock {
  Future _lock;
  Completer _completer;
  bool get locked => _lock != null;

  void lock() {
    if (!locked) {
      _completer = Completer();
      _lock = _completer.future;
    }
  }

  void unlock() {
    if (locked) {
      _completer.complete();
      _lock = null;
    }
  }
}

void main () {

}