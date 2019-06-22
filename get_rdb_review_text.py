from bs4 import BeautifulSoup
import urllib.request as req
import sys
import codecs
import types

import signal
signal.signal(signal.SIGINT, signal.SIG_DFL)

#
# url2uid
# replace /u/xxxx.html to xxxx
#
def url2uid(url):
	return url.replace('/u/','').replace('.html', '')

#
# url2uid
# replace /s/xxxx.html to xxxx
#
def url2sid(url):
	return url.replace('/s/','').replace('.html', '')


def printReview(num):
	url = 'https://ramendb.supleks.jp/review/' + str(num) + '.html'
	try:
		res = req.urlopen(url)
		soup = BeautifulSoup(res, "html.parser")
		if soup is None :
			print ("BeautifulSoup error.")
			return

		# description
		descNode= soup.find('span', itemprop="description")
		if descNode is None :
			description = ""
		else :
			description = descNode.text.replace('\n', ' ').replace('\r', ' ').replace('\t', ' ').replace('\\', '￥')

		try:
			description.encode('cp932','ignore').decode('cp932')
		except UnicodeError as e:
			print("Unicode error", e)

		print(num, '\t', description)
	except:
		sys.stderr.write ('error, num=' + format(num) + '\n')
		pass

# メインメソッド
args = sys.argv
#sys.stdout = codecs.getwriter('utf8')(sys.stdout)
for num in range(int(args[1]), int(args[2]) + 1):
	printReview(num)
