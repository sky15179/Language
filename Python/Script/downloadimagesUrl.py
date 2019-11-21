# import requests
#
#
# url = 'http://image.baidu.com/search/index?tn=baiduimage&ct=201326592&lm=-1&cl=2&ie=gbk&word=%C0%AF%B1%CA%D0%A1%D0%C2%CD%BC%C6%AC&hs=0&fr=ala&ori_query=%E8%9C%A1%E7%AC%94%E5%B0%8F%E6%96%B0%E5%9B%BE%E7%89%87&ala=0&alatpl=sp&pos=0'
# r = requests.get(url)
#
# print type(r)
# print r.status_code
# print r.encoding
# print r.cookies

import urllib2

response = urllib2.urlopen('http://www.baidu.com')

print response.read()
