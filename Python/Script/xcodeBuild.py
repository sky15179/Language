#!/usr/bin/python
# coding:utf-
import os
import fnmatch
import commands
import subprocess

buildDirPath = '/Users/wzg/Desktop/code/workCode/protect4/Sunshine_5.5/FaciShare'

sdkDevice="iphoneos9.3"
sdkSimulator="iphonesimulator9.3"
configuration_array=("Release" "Debug")
arch_array=("iphoneos" "iphonesimulator")
arch_device_array=("armv7" "arm64")
arch_iphonesimulator_array=("i386" "x86_64")

# ignoreList = ['FaciShare']
handleList = ['FSTools','FSUIKit']

def build_debug(protectPath,ignoreProtects=[]):
    if  globals().has_key('ignoreList') and len(ignoreList) > 0:
        shouldIgnore = False
        for ignore in ignoreList:
            if ignore == os.path.basename(protectPath):
                shouldIgnore = True
        if shouldIgnore == False:
            os.chdir(protectPath)
            child = subprocess.Popen('xcodebuild clean -configuration Debug',shell=True)
            print "开始build:"
            child = subprocess.Popen('xcodebuild -configuration Debug',shell=True)
            child.wait()
            print "结束build."
        else:
            print "过滤的工程" + os.path.basename(protectPath)

    # if len(handleList) > 0:
    #     print "进入build_debug:" + protectPath + "\r\n"
    #     shouldHandle = False
    #     for handle in handleList:
    #         # print 'handle值:' + handle + 'basename:' + os.path.basename(protectPath)
    #         if handle == os.path.basename(protectPath):
    #             shouldHandle = True
    #     if shouldHandle == True:
    #         os.chdir(protectPath)
    #         child = subprocess.Popen('xcodebuild clean -configuration Debug',shell=True)
    #         child.wait()
    #         print "开始build:"
    #         child = subprocess.Popen('xcodebuild -configuration Debug',shell=True)
    #         child.wait()
    #         print "结束build."


if __name__ == '__main__':
    # build_debug(buildDirPath)
    protectDirPath = raw_input("请输入工程路径:\r\n")
    protectDirPath = protectDirPath.replace(' ','')
    for path,secdirs,files in os.walk(protectDirPath):
        for dirName in secdirs:
            if fnmatch.fnmatch(dirName,'*.xcodeproj'):
                # print "路径:" + os.path.dirname(os.path.join(path,dirName))
                buildDirPath = os.path.dirname(os.path.join(path,dirName))
                build_debug(buildDirPath)
