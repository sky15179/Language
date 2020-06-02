/**
 * @Description: 
 * @Author: 王智刚
 * @Date: 2020-05-14 13:52:12
 * @LastEditTime: 2020-05-29 17:06:27
 * @LastEditors:  
 */

abstract class Cancelable {
  bool isCancel;
  void cancel();
}

// class RequestCancel extends Cancelable {
//   CancelToken cancelToken;
//   RequestCancel({this.cancelToken});
// }
