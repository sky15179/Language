/**
 * @Description: 
 * @Author: 王智刚
 * @Date: 2020-06-02 10:54:33
 * @LastEditTime: 2020-06-02 14:10:18
 * @LastEditors:  
 */
class RequestValidator {
  final String url;
  RequestValidator(this.url);
}

class ResponseValidator {}

class URLParser {
  final String absoluteUrl;
  String get host {}
  String get path {}
  Map<String, dynamic> get param {}
  String get query {}
  URLParser(this.absoluteUrl);
}

