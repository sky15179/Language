/**
 * @Description: 
 * @Author: 王智刚
 * @Date: 2020-05-06 11:07:36
 * @LastEditTime: 2020-06-01 11:32:38
 * @LastEditors:  
 */
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import './patch/net/index.dart';
import '../model/listModel.dart';
import 'package:dio/src/response.dart';
import 'package:dio/src/dio_error.dart';
import './environment.dart';
import '../model/homeList.dart';
import './patch/net/index.dart';
import 'dart:convert';
import 'dart:ffi';
import './patch/net/result.dart';

//  -------------------------------------- 业务网络胶水层 - 业务测试

void main() {
  HomeAPI.getList().then((v) {
    print('测试请求结果: $v');
  });
}

//  -------------------------------------- 业务网络胶水层 - 业务配置

class MessageApi {
  static String getHistoryPath = '/celebrity/follow/followingList';

  static Future<dynamic> getHistoryList() async {
    var isError = false;
    final jsonStr =
        await API.get(getHistoryPath).catchError((_) => isError = true);
    Map<String, dynamic> rootMap = json.decode(jsonStr);
    var root = new Root.fromJson(rootMap);
    return isError ? true : root.data.dataList;
  }
}

class HomeAPIPath {
  static const list = '/celebrity/follow/followingList';
  static getFllowUsers(int id) => 'fllow/$id/users';
}

class HomeAPI {
  static Future getList() async {
    return await API.get(HomeAPIPath.list);
  }
}

//  -------------------------------------- 业务网络胶水层 - 基本组成模块

final API apiManager = API();

class HTTPHost {
  static const moviepro = 'http://api.maoyan.com';
}

enum HTTPMethod { GET, POST }

const httpMethodValues = <HTTPMethod, String>{
  HTTPMethod.GET: 'get',
  HTTPMethod.POST: 'post',
};

//  -------------------------------------- 业务网络胶水层 - 核心请求发起

extension ResultErrorTransform on DioError {
  Error transform() {
    return Error(this.hashCode, this.message);
  }
}

typedef CancelHandler = void Function(Cancelable canceltoken);
typedef Completion = void Function(Result<Map<String, dynamic>, Error>);
typedef ProgressHandler = void Function(Progress progress);

class API {
  static Dio _dio;
  static Map<String, dynamic> get config {
      Map<String, dynamic> result = {};
      return result;
  }
  static final _fetchTypes = <String, Function>{
    httpMethodValues[HTTPMethod.GET]: _dio.get,
    httpMethodValues[HTTPMethod.POST]: _dio.post,
  };
  static List<PluginType> plugins = [NetWorkLoggerPlugin()];

  static void init() {
    _dio = Dio()
      ..options.baseUrl = HTTPHost.moviepro
      ..interceptors.add(InterceptorsWrapper(onRequest: _handleRequest));
    _environmentHandle();
  }

  static void _environmentHandle() {
    if (!Environment.isRelease) {
      _addProxy();
    }
  }

  static RequestOptions _handleRequest(RequestOptions options) {
    String fullPath = options.baseUrl + options.path;
    if (options.method == 'GET' && options.queryParameters.length > 0) {
      List params = [];
      options.queryParameters.forEach((k, v) => params.add('$k=$v'));
      fullPath += '?' + params.join('&').toString();
      print(fullPath);
    }
    return options;
  }

  ///internal
  static Future<Result<Map<String, dynamic>, Error>> _fehtch(
      HTTPMethod method, String url, Map<String, dynamic> data,
      {ProgressHandler progressHandler}) async {
    plugins.forEach((p) => p.prepare());
    Result<Map<String, dynamic>, ErrorType> result;
    void progressCallBack(int count, int total) {
      Progress progress = Progress();
      progress.totalCount = total;
      progress.completedCount = count;
      if (progressHandler != null) {
        progressHandler(progress);
      }
    }

    try {
      plugins.forEach((p) => p.willSend());
      final Response response = method == HTTPMethod.GET
          ? await _dio.get(url,
              queryParameters: data, onReceiveProgress: progressCallBack)
          : await _fetchTypes[method](url, queryParameters: data);
      result = Result<Map<String, dynamic>, Error>(ResultType.success);
      result.value = response.data;
      plugins.forEach((p) => p.didReceive());
    } catch (e) {
      final error = (e is DioError &&
              e.response != null &&
              (e.response.statusCode > 400 || e.response.statusCode < 200))
          ? e.response.data
          : {"message": "服务器网络繁忙，请稍后再试", "status_code": 1001};
      result = Result<Map<String, dynamic>, Error>(ResultType.failure);
      result.error = (error as DioError).transform();
      plugins.forEach((p) => p.didReceive());
    }
    return result;
  }

  static Future<Result<Map<String, dynamic>, Error>> fehtch(
      HTTPMethod method, String url, Map<String, dynamic> data,
      {ProgressHandler progressHandler}) async {
        return await _fehtch(method, url, data);
      }

  static Future get(String url, {Map<String, dynamic> data}) async {
    return await _fehtch(HTTPMethod.GET, url, data);
  }

  static Future post(String url, {Map<String, dynamic> data}) async {
    return await _fehtch(HTTPMethod.POST, url, data);
  }

  static String _getCurrentProxy() {
    //172.19.160.227
    return 'PROXY 172.19.160.227:8888';
  }

  static _addProxy() {
    var client = (_dio.httpClientAdapter as DefaultHttpClientAdapter);
    client.onHttpClientCreate = (client) {
      client.findProxy = (url) {
        ///设置代理 电脑ip地址
        return _getCurrentProxy();

        ///不设置代理
//          return 'DIRECT';
      };
      // ///忽略证书
      // client.badCertificateCallback =
      //     (X509Certificate cert, String host, int port) => true;
    };
  }
}

//  ------------- 网络胶水层基础能力组件：aop切面

abstract class PluginType {
  void prepare() {}
  void willSend() {}
  void didReceive() {}
  void process() {}
}

class NetWorkLoggerPlugin implements PluginType {
  @override
  void didReceive() {
    print('NetWorkLoggerPlugin: didReceive打印准备节点');
  }

  @override
  void prepare() {
    print('NetWorkLoggerPlugin: prepare打印准备节点');
  }

  @override
  void process() {
    print('NetWorkLoggerPlugin: process打印准备节点');
  }

  @override
  void willSend() {
    print('NetWorkLoggerPlugin: process打印准备节点');
  }
}

//  ------------- 网络胶水层基础能力组件：完成回调和过程

class Progress {
  void cancel() {}
  void pause() {}
  void resume() {}
  int totalCount;
  int completedCount;
  bool get isCanceled {
    return false;
  }

  bool get isPaused {
    return false;
  }
}

extension ResponseExtension on Response {
  bool isSuccess() {
    return data is DioError &&
        this != null &&
        statusCode >= 200 &&
        statusCode <= 400;
  }
}

extension ErrorExtension on Response {
  bool isSuccess() {
    return data is DioError &&
        this != null &&
        statusCode >= 200 &&
        statusCode <= 400;
  }
}
