from bs4 import BeautifulSoup
import urllib.request as req
import sys
import datetime

import json

import signal
signal.signal(signal.SIGINT, signal.SIG_DFL)

#
# url2uid
# replace /u/xxxx.html to xxxx
#
def url2uid(url):
	return url.replace('/u/','').replace('.html', '')
	
#
# print shop infomation
#
def printShop(num):
	url = 'https://supleks.jp/s/' + str(num) + '.html'
	try:
		res = req.urlopen(url)
		soup = BeautifulSoup(res, "html.parser")
		if soup is None :
			sys.stderr.write ('html.paser error, num=' + format(num) + '\n')
			return

		scriptNode = soup.find('script', type="application/ld+json")
		if scriptNode is None :
			print("scriptNode is None")
			retutn

		scriptJson = json.loads(scriptNode.string)
		if scriptJson is None :
			print ("scriptJson is None")
		else :
			latitude = scriptJson['geo']['latitude']
			longitude = scriptJson['geo']['longitude']

		# output shop location record
		shop = format(num) + '\t' + latitude + '\t' +longitude
		try:
			print(shop.encode('cp932','ignore').decode('cp932'))
		except UnicodeError as e:
			print("Unicode error", e)
	except:
		sys.stderr.write ('\n' + 'exception, num=' + format(num) + '\n')
		pass

# メインメソッド
args = sys.argv
for num in range(int(args[1]), int(args[2]) + 1):
	printShop(num)
