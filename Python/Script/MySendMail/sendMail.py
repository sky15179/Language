#!/usr/bin/python
# -*- coding:utf-8 -*-
from email import encoders
from email.header import Header
from email.mime.text import MIMEText
from email.utils import parseaddr, formataddr
import smtplib
import requests
import sys
reload(sys)  # Python2.5 初始化后会删除 sys.setdefaultencoding 这个方法，我们需要重新载入
sys.setdefaultencoding('utf-8')


class mySendMail(object):
    """docstring for ."""

    def __init__(self, msgType):
        self._msgType = msgType
        self._host = "smtp.126.com"
        self._user = "sky15179@126.com"
        self._password = "472abaoy"
        self._fromMail = "协同今日工作汇总"

    def sendMail(self, mailto_list, subject, body, format='plain'):
        if not self.checkInstance():
            print "检查msgType,只能发送text和html,默认使用text"

        if isinstance(body, unicode):
            body = str(body)
        me = ("%s<" + self._user + ">") % (Header(self._fromMail, 'utf-8'),)
        msg = MIMEText(body, format, 'utf-8')
        if not isinstance(subject, unicode):
            subject = unicode(subject)
        msg['Subject'] = subject
        msg['From'] = me
        msg['To'] = ";".join(mailto_list)
        msg["Accept-Language"] = "zh-CN"
        msg["Accept-Charset"] = "ISO-8859-1,utf-8"
        try:
            s = smtplib.SMTP()
            s.connect(self._host)
            s.login(self._user, self._password)
            s.sendmail(me, mailto_list, msg.as_string())
            s.close()
            print '发送成功'
            return True
        except Exception, e:
            print str(e)
            print '发送失败'
            return False

    def checkInstance(self):
        if self._msgType == 'html':
            return True
        elif self._msgType == 'plain':
            return True
        else:
            return False

if __name__ == '__main__':
    sdl = mySendMail('plain')
    sdl.sendMail(['839836537@qq.com'], '今日计划', '内容')
