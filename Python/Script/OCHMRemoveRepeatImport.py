
#coding:utf-8
import os
import re

testPath = "/Users/wzg/Desktop/code/workCode/protect4/Phoenix_5.4-Refactor/FaciShare/FaciShare/Class/UIViewController/FeedDetail_Page/EssayDetail.h"
breakSet = set(["@protocol","@interface","@implementation"])

# 读取文件内容
# def readFileFromPath(path):
f = open(testPath)
# print (f.read())

def findStr(str):
    if re.search('@protocol|@interface|@implementation|typedef enum',str):
        return True
    pass

line = f.readline()
while line:
    print(f.readline())
    line = f.readline()
    # if findStr(f.readline()):
    #     break
    # else:
    #     print f.readline()


# result = list()
# for line in open(testPath):
#     line = f.readline()
#     for child in breakSet:
#         if child in line:
#             print "已经过滤完成"
#             break
#         else:
#             print line
#     result.append(line)
#     pass
f.close()
