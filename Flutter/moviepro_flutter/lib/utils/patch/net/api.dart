/**
 * @Description: 
 * @Author: 王智刚
 * @Date: 2020-05-14 14:48:10
 * @LastEditTime: 2020-05-29 10:50:47
 * @LastEditors:  
 */
// /**
//  * @Description: 
//  * @Author: 王智刚
//  * @Date: 2020-05-14 14:48:10
//  * @LastEditTime: 2020-05-15 13:52:12
//  * @LastEditors:  
//  */

// enum HTTPMethod { get, post }

// abstract class APIType {
//   String get baseUrl;
//   String get path;
//   HTTPMethod get method;
//   Map<String, dynamic> get params;
//   Map<String, dynamic> get body;
//   Map<String, dynamic> get headers;
// }

// class HTTPHost {
//   static const String moviePro = 'http://api.maoyan.com';
// }

// class BaseAPI implements APIType {
//   @override
//   String get baseUrl => HTTPHost.moviePro;

//   @override
//   Map<String, dynamic> get body => null;

//   @override
//   Map<String, dynamic> get headers => null;

//   @override
//   HTTPMethod get method => null;

//   @override
//   Map<String, dynamic> get params => null;

//   @override
//   String get path => '/celebrity/follow/followingList';
// }

// class PageAPI extends BaseAPI {
//   final int limit;
//   final int offset;

//   PageAPI(this.limit, this.offset);

//   next() {
    
//   }

//   nextOffset(int offset) {
    
//   }

//   reset() {
    
//   }
// }

// enum HomeAPIBusiness {
//   getList
// }

// class HomeAPI extends BaseAPI {
//   @override
//   HTTPMethod get method => HTTPMethod.get;

// }

// class APIProvider<T extends APIType>  {
//   final T api;

//   APIProvider(this.api);

//   fetch() {
//     this.api.baseUrl;
//   }
// }