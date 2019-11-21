#!/usr/bin/python
# -*- coding:utf-8 -*-
import pysvn
import time

class getLogFromSvn:
    """docstring for ."""

    def __init__(self, url):
        self._username = "wangzg"
        self._password = "472abaoy.."
        self._logLimitNum = 10

    def get_login(self, realm, username, may_save):
        return True, self._username, self._password, True

    def ssl_server_trust_prompt(trust_dict):
        return True, 0, True

    def getLog(self):
        try:
            client = pysvn.Client()
            client.callback_ssl_server_trust_prompt = self.ssl_server_trust_prompt
            client.callback_get_login = self.get_login
            log = client.log(svn_url, revision_start=pysvn.Revision(
                pysvn.opt_revision_kind.head), limit=self._logLimitNum)
            for info in log:
                logAuthor = info.author
                logTime = time.strftime(
                    '%Y-%m-%d %H:%M:%S', time.localtime(info.date))
                logMessage = info.message
                logRevision = info.revision.number
                logChange_list = info.changed_paths
                print "提交人:", logAuthor, "提交时间:", logTime, "提交信息:", logMessage, "svn版本号:", logRevision
            return True
        except Exception as e:
            print '获取日志失败,错误信息:', e
            return False

if __name__ == '__main__':
    svn_url = "https://vwsr100007.firstshare.cn:1688/svn/FS.iOS/branches/5.5.2work/Work"
    glfs = getLogFromSvn(svn_url)
    glfs.getLog()
