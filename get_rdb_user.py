from bs4 import BeautifulSoup
import urllib.request as req
import sys

import signal
signal.signal(signal.SIGINT, signal.SIG_DFL)

def printUser(num):
	url = 'https://supleks.jp/u/' + str(num) + '.html'
	try:
		res = req.urlopen(url)
		soup = BeautifulSoup(res, "html.parser")
		# user name
		nameLevel = soup.find('div', id="name-level")
		userName = nameLevel.find('h2').string

		# user profile string
		prop  = soup.select_one(".profile > div.props")
		if prop is None :
			userProfile = "なし"
		else:
			userProfile = prop.string

		links = soup.find('table', class_="counts").find_all('td')
		reviews = links[0].text.replace(',', '')
		shops = links[1].text.replace(',', '')
		favorites = links[2].text.replace(',', '')
		likes = links[3].text.replace(',', '')

		print(num, '\t', userName, '\t', reviews, '\t', shops, '\t', favorites, '\t', likes, '\t', userProfile)
	except:
		pass

# メインメソッド
args = sys.argv
for num in range(int(args[1]), int(args[2]) + 1):
	printUser(num)
