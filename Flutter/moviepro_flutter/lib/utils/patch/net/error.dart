/**
 * @Description: 
 * @Author: 王智刚
 * @Date: 2020-05-14 13:52:00
 * @LastEditTime: 2020-06-02 11:37:56
 * @LastEditors:  
 */

class ErrorCodeOptions {
  static const baseError = 100001;
  static const parseError = baseError >> 1;
  static const businessError = baseError >> 2;
  static const clientError = baseError >> 3;
  static const serveError = baseError >> 4;
  static const netError = baseError >> 5;
  static const validateError = baseError >> 6;
}

abstract class ErrorType {}

class Error extends ErrorType {
  final int code;
  final String description;

  Error(this.code, this.description);
}

class Never extends ErrorType {}

//  ------------- 网络胶水层基础能力组件：错误

enum APIErrorType { StatusCode, JsonMapping, ObjectMapping }

class APIError extends ErrorType {}

enum HomeAPIErrorType { Empty, ServeError, ClientError }

const Map<HomeAPIErrorType, String> HomeAPIErrorMap = {
  HomeAPIErrorType.Empty: '没有数据',
  HomeAPIErrorType.ServeError: '服务端错误原因',
  HomeAPIErrorType.ClientError: '客户端错误原因',
};

class HomError extends Error {
  HomError(int code, String description) : super(code, description);
}

class ParseError extends Error {
  ParseError(int code, String description) : super(code, description);
  
}

class ToastErrorHandler {
  
}

class AlertErrorHandler {
  
}