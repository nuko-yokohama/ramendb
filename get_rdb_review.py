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

#
# getCategory(t)
#
def getCategory(t):
	if t.find('/') != -1 :
		category = 'ラーメン'
	elif t == 'カレーライス' or t == '欧風カレー' or t == 'インドカレー' or t == 'タイカレー' or \
	     t == 'スープカレー' or t == 'ドライカレー' or t == '焼きカレー・カレードリア' or t == 'カレーパスタ' :
		category = 'カレー'
	elif t == 'チャーハン' or t == 'あんかけチャーハン' :
		category = 'チャーハン'
	elif t == '焼き餃子' or t == '水餃子' or t == '揚げ餃子' :
		category = 'ぎょうざ'
	elif t == 'かけうどん' or t == 'つけうどん' or t == '釜揚げうどん' or \
	     t == '鍋焼きうどん' or t == '味噌煮込みうどん' or t == 'カレーうどん' or t == '焼きうどん' :
		category = 'うどん'
	elif t == '冷たいおそば' or t == '温かいおそば' :
		category = 'そば'
	else :
		category = 'その他'
	return category
	

def printReview(num):
	url = 'https://supleks.jp/review/' + str(num) + '.html'
	try:
		res = req.urlopen(url)
		# print("req.urlopen")
		if res is None :
			print("urlopen error.")
			retrun

		soup = BeautifulSoup(res, "html.parser")
		if soup is None :
			print ("BeautifulSoup error.")
			return

		# print("get soup")
		# menu
		# menuNode = soup.find('span', itemprop="itemReviewed")
		menuNode = soup.find('div', class_="menu")
		if menuNode is None :
			menu = ""
		else :
			menu_a = menuNode.find_all('a')
			menu = menu_a[0].text
			menu = menu.replace(chr(165), '￥').replace('\\', '￥').replace('&','＆')
			menu = menu.replace('	', ' ')

		# score
		scoreNode = soup.find('div', class_="score")
		if scoreNode is None :
			score = -1

		score = scoreNode.text.replace('点','')
		score = score.replace('未満','')
		if score == '-' :
			# null data
			score = '\\N'
		
		# category
		styleNode = soup.find('span', class_="style")
		t = styleNode.text.replace('[','').replace(']','')
		category = getCategory( t )

		# noodle_type, soup_type
		if category == 'ラーメン' :
			styleArray = t.split('/')
			
			if len(styleArray) == 2 :
				_type = styleArray[0]
				soup_type = styleArray[1]
			else :
				return
		else :
			_type = t
			soup_type = ''

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
		rv = format(num) + '\t' + menu + '\t' + score + '\t' + category + '\t' + _type + '\t' + soup_type + '\t' + shop_id + '\t' + user_id + '\t' + likes + '\t' + review_timestamp[:10]

		try:
			print(rv.encode('cp932','ignore').decode('cp932'))
		except UnicodeError as e:
			print("Unicode error", e)

#		print(num, '\t', menu, '\t', score, '\t', category, '\t', _type, '\t', soup_type, '\t', shop_id, '\t', user_id, '\t', likes, '\t', review_timestamp[:10])
	except:
		sys.stderr.write ('error, num=' + format(num) + '\n')
		pass

# メインメソッド
args = sys.argv
#sys.stdout = codecs.getwriter('utf8')(sys.stdout)
for num in range(int(args[1]), int(args[2]) + 1):
	printReview(num)
