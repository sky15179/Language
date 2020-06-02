/*
 * @Author: 王智刚
 * @Date: 2020-04-30 17:02:48
 * @LastEditTime: 2020-04-30 17:38:20
 * @LastEditors:  
 * @Description: 首页列表模型
 * @FilePath: /moviepro_flutter/lib/model/homeList.dart
 */
import 'dart:convert' show json;

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }

  return null;
}

class Root {
  Root({
    this.data,
    this.paging,
    this.success,
  });

  factory Root.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : Root(
          data: Data.fromJson(asT<Map<String, dynamic>>(jsonRes['data'])),
          paging: Paging.fromJson(asT<Map<String, dynamic>>(jsonRes['paging'])),
          success: asT<bool>(jsonRes['success']),
        );

  Data data;
  Paging paging;
  bool success;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': data,
        'paging': paging,
        'success': success,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Data {
  Data({
    this.feedCount,
    this.dataList,
  });

  factory Data.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }

    final List<DataList> dataList =
        jsonRes['dataList'] is List ? <DataList>[] : null;
    if (dataList != null) {
      for (final dynamic item in jsonRes['dataList']) {
        if (item != null) {
          dataList.add(DataList.fromJson(asT<Map<String, dynamic>>(item)));
        }
      }
    }
    return Data(
      feedCount: asT<int>(jsonRes['feedCount']),
      dataList: dataList,
    );
  }

  int feedCount;
  List<DataList> dataList;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'feedCount': feedCount,
        'dataList': dataList,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class DataList {
  DataList({
    this.attentioned,
    this.content,
    this.created,
    this.feedEventType,
    this.feedId,
    this.feedLike,
    this.feedTime,
    this.feedType,
    this.fixedPosition,
    this.followNumber,
    this.followed,
    this.followeeType,
    this.id,
    this.linkUrl,
    this.myPublish,
    this.publisherAvatar,
    this.publisherBody,
    this.publisherId,
    this.publisherType,
    this.templateId,
  });

  factory DataList.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }

    final List<String> content = jsonRes['content'] is List ? <String>[] : null;
    if (content != null) {
      for (final dynamic item in jsonRes['content']) {
        if (item != null) {
          content.add(asT<String>(item));
        }
      }
    }
    return DataList(
      attentioned: asT<bool>(jsonRes['attentioned']),
      content: content,
      created: asT<String>(jsonRes['created']),
      feedEventType: asT<int>(jsonRes['feedEventType']),
      feedId: asT<int>(jsonRes['feedId']),
      feedLike:
          FeedLike.fromJson(asT<Map<String, dynamic>>(jsonRes['feedLike'])),
      feedTime: asT<String>(jsonRes['feedTime']),
      feedType: asT<int>(jsonRes['feedType']),
      fixedPosition: asT<bool>(jsonRes['fixedPosition']),
      followNumber: asT<int>(jsonRes['followNumber']),
      followed: asT<bool>(jsonRes['followed']),
      followeeType: asT<int>(jsonRes['followeeType']),
      id: asT<int>(jsonRes['id']),
      linkUrl: asT<String>(jsonRes['linkUrl']),
      myPublish: asT<bool>(jsonRes['myPublish']),
      publisherAvatar: asT<String>(jsonRes['publisherAvatar']),
      publisherBody: asT<String>(jsonRes['publisherBody']),
      publisherId: asT<int>(jsonRes['publisherId']),
      publisherType: asT<String>(jsonRes['publisherType']),
      templateId: asT<int>(jsonRes['templateId']),
    );
  }

  bool attentioned;
  List<String> content;
  String created;
  int feedEventType;
  int feedId;
  FeedLike feedLike;
  String feedTime;
  int feedType;
  bool fixedPosition;
  int followNumber;
  bool followed;
  int followeeType;
  int id;
  String linkUrl;
  bool myPublish;
  String publisherAvatar;
  String publisherBody;
  int publisherId;
  String publisherType;
  int templateId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'attentioned': attentioned,
        'content': content,
        'created': created,
        'feedEventType': feedEventType,
        'feedId': feedId,
        'feedLike': feedLike,
        'feedTime': feedTime,
        'feedType': feedType,
        'fixedPosition': fixedPosition,
        'followNumber': followNumber,
        'followed': followed,
        'followeeType': followeeType,
        'id': id,
        'linkUrl': linkUrl,
        'myPublish': myPublish,
        'publisherAvatar': publisherAvatar,
        'publisherBody': publisherBody,
        'publisherId': publisherId,
        'publisherType': publisherType,
        'templateId': templateId,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class FeedLike {
  FeedLike({
    this.likePicDefaultUrl,
    this.likePicSelectedUrl,
    this.likeType,
    this.likeWords,
    this.likeWordsColor,
    this.likeWordsDefaultColor,
  });

  factory FeedLike.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : FeedLike(
          likePicDefaultUrl: asT<String>(jsonRes['likePicDefaultUrl']),
          likePicSelectedUrl: asT<String>(jsonRes['likePicSelectedUrl']),
          likeType: asT<int>(jsonRes['likeType']),
          likeWords: asT<String>(jsonRes['likeWords']),
          likeWordsColor: asT<String>(jsonRes['likeWordsColor']),
          likeWordsDefaultColor: asT<String>(jsonRes['likeWordsDefaultColor']),
        );

  String likePicDefaultUrl;
  String likePicSelectedUrl;
  int likeType;
  String likeWords;
  String likeWordsColor;
  String likeWordsDefaultColor;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'likePicDefaultUrl': likePicDefaultUrl,
        'likePicSelectedUrl': likePicSelectedUrl,
        'likeType': likeType,
        'likeWords': likeWords,
        'likeWordsColor': likeWordsColor,
        'likeWordsDefaultColor': likeWordsDefaultColor,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Paging {
  Paging({
    this.hasMore,
    this.limit,
    this.offset,
    this.total,
  });

  factory Paging.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : Paging(
          hasMore: asT<bool>(jsonRes['hasMore']),
          limit: asT<int>(jsonRes['limit']),
          offset: asT<int>(jsonRes['offset']),
          total: asT<int>(jsonRes['total']),
        );

  bool hasMore;
  int limit;
  int offset;
  int total;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'hasMore': hasMore,
        'limit': limit,
        'offset': offset,
        'total': total,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
