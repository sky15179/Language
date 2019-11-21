#!/usr/bin/python
# coding:utf-8
import os
import fnmatch
import shutil

path = ""
tarPath = ""
protectPath = ""
incFileMap = {}

def getFilesNameFromDir(filePath,ignoreStr=[]):
    fileMap = {}
    if os.path.isdir(path):
        filesName = os.listdir(path)
        for fn in filesName:
            if not fileMap.has_key(fn):
                if len(ignoreStr) > 0:
                    # 过滤多个有逻辑问题
                    for ig in ignoreStr:
                        if not fnmatch.fnmatch(fn,ig):
                            fileMap[fn] = 1
                else:
                    fileMap[fn] = 1
        return fileMap
    pass

def removeFilesInDir(targetPath,fiterMap={},flagStr=[]):
    if os.path.isdir(targetPath):
        for path,secdirs,files in os.walk(targetPath):
            for tarFile in files:
                if fiterMap.has_key(tarFile):
                    if fiterMap[tarFile]:
                        if fnmatch.fnmatch(tarFile,'*.h*'):
                            os.remove(os.path.join(path,tarFile))
                            print "删除文件:" + os.path.join(path,tarFile)
    pass

def traverseIncDirInPath(targetPath):
    global path,tarPath
    for path,secdirs,files in os.walk(targetPath):
        for subDir in secdirs:
            if subDir == 'inc':
                path = os.path.join(path,subDir)
                tarPathName = os.path.basename(os.path.dirname(path))
                tarPath = path.replace('inc',tarPathName)
                incFileMap = getFilesNameFromDir(path,['.DS_Store'])
                removeFilesInDir(tarPath,incFileMap)
                print "根据inc文件对工程进行了操作:"+ path
                # 不能直接移动,在遍历目录树的过程中改变目录树结构会出问题
                # print "移动的源文件地址:" + path
                # shutil.move(path,tarPath)
                # 移动inc文件夹到
                # print "移动inc文件夹到:"+ tarPath
    pass

def getProtectPath():
    global protectPath
    inputContent = raw_input("请输入工程地址的路径:\r\n")
    inputContent = inputContent.replace(' ','')
    if os.path.isdir(inputContent):
        protectPath = inputContent
    pass

if __name__ == '__main__':
    getProtectPath()
    traverseIncDirInPath(protectPath)
