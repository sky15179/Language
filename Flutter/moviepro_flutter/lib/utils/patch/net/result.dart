/**
 * @Description: 
 * @Author: 王智刚
 * @Date: 2020-05-15 15:46:46
 * @LastEditTime: 2020-05-28 17:24:36
 * @LastEditors:  
 */

import './error.dart';

enum ResultType { success, failure }

class Result<Success, Failure extends ErrorType> {
  final ResultType type;
  Success value;
  Failure error;
  
  Result(this.type, {this.value, this.error});
  Success get() {
    switch (type) {
      case ResultType.success:
        return value;
        break;
      case ResultType.failure:
        throw error;
        break;
    }
  }
}

void main() {
  var result = Result<String, Never>(ResultType.success, value: '123');
  print(result.value);
  print('${result.get()}');
}
