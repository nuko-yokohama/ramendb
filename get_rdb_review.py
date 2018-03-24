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

		# menu
		menuNode = soup.find('span', itemprop="itemReviewed")
		if menuNode is None :
			menu = ""
		else :
			menu =menuNode.string
			menu = menu.replace(chr(165), '￥').replace('\\', '￥').replace('&','＆')

		# score
		scoreNode = soup.find('div', class_="score")
		if scoreNode is None :
			score = -1
		else :
			score = scoreNode.text.replace('点','')

		# noodle_type, soup_type
		styleNode = soup.find('span', class_="style")
		styleArray = styleNode.text.replace('[','').replace(']','').split('/')
			
		if len(styleArray) == 2 :
			noodle_type = styleArray[0]
			soup_type = styleArray[1]
		else :
			return

		# div props
		divPropse = soup.find('div', class_="props")
		links = divPropse.find_all('a')
		if links is None :
			# Skip
			print("num=',num, ',links is None")

		# shop_id
		shop_id = url2sid(links[0].attrs['href'])

		if len(links) == 5 :
			# Japan shop review
			# user_id
			user_id = url2uid(links[3].attrs['href'])
		else :
			# Foreign shop review
			# user_id
			user_id = url2uid(links[2].attrs['href'])

		# likes
		likesLink = soup.find('a', class_="iine disabled")
		likes = likesLink.text.replace('いいね (', '').replace(')', '')


		# timestamp
		review_timestamp = soup.find('time').attrs['datetime']

		# print review information
		rv = format(num) + '\t' + menu + '\t' + score + '\t' + noodle_type + '\t' + soup_type + '\t' + shop_id + '\t' + user_id + '\t' + likes + '\t' + review_timestamp[:10]

		try:
			print(rv.encode('cp932','ignore').decode('cp932'))
		except UnicodeError as e:
			print("Unicode error", e)

#		print(num, '\t', menu, '\t', score, '\t', noodle_type, '\t', soup_type, '\t', shop_id, '\t', user_id, '\t', likes, '\t', review_timestamp[:10])
	except:
		sys.stderr.write ('error, num=' + format(num) + '\n')
		pass

# メインメソッド
args = sys.argv
#sys.stdout = codecs.getwriter('utf8')(sys.stdout)
for num in range(int(args[1]), int(args[2]) + 1):
	printReview(num)
