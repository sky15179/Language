#!/usr/bin/python
# coding:utf-8
import os
import re
import fnmatch
import zipfile
import shutil
import getpass
import glob

PATH = "/Users/"+ getpass.getuser() + "/Downloads"
ProtectImagePath = "/Users/wzg/Downloads/testimage/help_images"
prefix = "FS_HelpGuide_"


#获取替换文件的路径
def realProtectImagePath():
    global ProtectImagePath
    if os.path.isdir(ProtectImagePath):
        pass
    else:
        inputContent = raw_input("请输入待替换图片文件的路径:")
        if os.path.isdir(ProtectImagePath):
            ProtectImagePath = inputContent
    pass


#删除已有图片文件夹
def deleteExistDirs():
    #  '''delete files and folders'''
    for path,dirs,files in os.walk(PATH):
        for secDir in dirs:
            if fnmatch.fnmatch(secDir,'*引导*'):
                turePath = os.path.join(PATH,secDir)
                shutil.rmtree(turePath)
    pass

#解压操作
def unzip(file_name):
    #    """unzip zip file"""
    zip_file = zipfile.ZipFile(file_name)
    zipDirName = file_name.replace('.zip','',1)
    if os.path.isdir(zipDirName):
        pass
    else:
        os.mkdir(zipDirName)
    for names in zip_file.namelist():
        if names.startswith('__MACOSX/'):
            continue
        zip_file.extract(names,zipDirName)
    zip_file.close()
    # zip_file.printdir()
    pass

#解压得路径
def unzipImages():
    for filename in os.listdir(PATH):
        if fnmatch.fnmatch(filename,'*引导*'):
            return os.path.join(PATH,filename)
    pass

#获取zip包的路径
def realPath():
    for path,dirs,files in os.walk(PATH):
        for secDir in dirs:
            if fnmatch.fnmatch(secDir,'*引导*'):
                # print '压缩包' + secDir
                turePath = os.path.join(PATH,secDir)
                # print '真实路径:' + turePath
                return turePath
    pass

# 替换文件名
def rename_fils(turePath):
    for path,secdirs,files in os.walk(turePath):
        for subDir in secdirs:
            subPath = os.path.join(turePath,subDir)
            for subfile in os.listdir(subPath):
                # print '文件:' + subfile
                subfilePath = os.path.join(subPath,subfile)
                if os.path.isfile(subfilePath):
                    if '.DS_Store' not in subfile:
                        newName = os.path.join(subPath,prefix+subDir+'_'+subfile.replace('0','',1))
                        os.rename(subfilePath,newName)
    pass

# 根目录下得文件完整路径
def fileInDirPath(turePath):
    fileList = []
    for path,secdirs,files in os.walk(turePath):
        for subDir in secdirs:
            subPath = os.path.join(turePath,subDir)
            for subfile in os.listdir(subPath):
                subfilePath = os.path.join(subPath,subfile)
                if os.path.isfile(subfilePath):
                    if '.DS_Store' not in subfile:
                        newName = os.path.join(subPath,subfile)
                        fileList.append(newName)

    return fileList
    pass

#替换图片
def repalceImages(newImageDirPath,oldImageDirPath):
    if (os.path.isdir(newImageDirPath)) and (os.path.isdir(oldImageDirPath)):
        for newImageFilePath in fileInDirPath(newImageDirPath):
            if os.path.isfile(newImageFilePath):
                shutil.copy(newImageFilePath,oldImageDirPath)
                print "替换成功" + os.path.basename(newImageFilePath)
    pass

if __name__ == '__main__':
    deleteExistDirs()
    unzipPath = unzipImages()
    if os.path.isfile(unzipPath):
        unzip(unzipPath)
        rename_fils(realPath())
        realProtectImagePath()
        repalceImages(realPath(),ProtectImagePath)
    else:
        print '无效解压地址'
