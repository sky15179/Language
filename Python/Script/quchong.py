
rfile = open('/Users/wzg/Desktop/temp/quchong.txt','r')
wfile = open('/Users/wzg/Desktop/temp/result.txt','w')
alines = rfile.readlines()
rfile.close()

h = {}

for i in alines:
    if not h.has_key(i):
        h[i] = 1
        wfile.write(i)

wfile.close()
