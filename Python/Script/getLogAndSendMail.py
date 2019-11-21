#!/usr/bin/python
# -*- coding:utf-8 -*-
from MySendMail import sendMail
from myGetLog import getLogFromSvn


class people(object):

    def __init__(self, info):
        self._name = info['Author']
        self._svnMessage = []
        self.addMessage(info)
        self._info = info

    @property
    def name(self):
        return self._name
        pass

    @property
    def messageList(self):
        return self._svnMessage
        pass

    def addMessage(self, msg):
        sinfo = svnInfo(msg)
        self._svnMessage.append(sinfo)
        pass

    def allMessage(self):
        result = '%s - 工作总结:\r\n' % self._name
        for i in range(len(self._svnMessage)):
            message = self._svnMessage[i]
            if not i == 0:
                result += ',%s' % message.Message
            else:
                result += message.Message
        return result

    def printMessageOneByOne(self):
        result = '详细流程:\r\n'
        num = 0
        for message in self._svnMessage:
            num += 1
            result += '%d.\n%s\r\n' % (num, message.allInfo())
        return result


class svnInfo(object):

    def __init__(self, arg):
        if not arg:
            print "信息初始化失败"
        else:
            self._Author = arg['Author']
            self._Time = arg['Time']
            self._Message = arg['Message']
            self._Revision = arg['Revision']
            self._Change_list = arg['Change_list']
        pass

    @property
    def Author(self):
        return self._Author
        pass

    @property
    def Time(self):
        return self._Time
        pass

    @property
    def Message(self):
        return self._Message
        pass

    @property
    def Revision(self):
        return self._Revision
        pass

    @property
    def Change_list(self):
        return self._Change_list
        pass

    def allInfo(self):
        result = '版本号:%s\n对应提交时间:%s\r\n对应工作:%s' % (
            self._Revision, self._Time, self._Message)
        return result
        pass

if __name__ == '__main__':
    svn_url = "https://vwsr100007.firstshare.cn:1688/svn/FS.iOS/branches/5.5.2work/Work"
    loginfo = getLogFromSvn(svn_url)
    loginfo.getLog()
    allPeople = {}
    for eyeryone in loginfo.result:
        name = eyeryone['Author']
        # print '遍历的key值存储的兼职:',name
        if not allPeople.has_key(name):
            # print '+创建key值存储的兼职:',name
            allPeople[name] = people(eyeryone)
        else:
            # print '+++添加key值存储的兼职:',name
            allPeople[name].addMessage(eyeryone)

    sm = sendMail.mySendMail('plain')
    theme = '工作汇总'
    content = ''
    for (k, v) in allPeople.items():
        content += '%s\r\n%s\r\n' % (allPeople[k].allMessage(),
                                     allPeople[k].printMessageOneByOne())
        pass
    sm.sendMail(['839836537@qq.com'], theme, content)
