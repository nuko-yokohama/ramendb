from bs4 import BeautifulSoup
import urllib.request as req
import sys

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
			return

		# shop name
		shopNode = soup.find('span', class_="shopname")
		if shopNode is None :
			shopName = ""
		else :
			shopName =shopNode.string

		# shop branch

		branchNode  = soup.find('span', class_="branch")
		if branchNode is None :
			branch = ""
		else:
			branch = branchNode.string

		# pref and area
		links = soup.find('h2', class_="area").find_all('a')
		if len(links) == 1 :
			# Foreign Countory
			pref = "海外"
			area = links[0].text
		else :
			# Japan
			pref = links[0].text
			area = links[1].text

			
		# created, modefied
		div_created = soup.find('div', id="created")
		links = div_created.find_all('a')
		if links is None :
			# Skip
			print("num=',num, ',links is None")

		if len(links) == 4 :
			# exist created only
			created = url2uid(links[0].attrs['href'])
			modified = "0"
		else :
			# exist created and modified
			created = url2uid(links[0].attrs['href'])
			modified = url2uid(links[2].attrs['href'])

		# output shop record
		print(num, '\t', shopName, '\t', branch, '\t', pref, '\t', area, '\t', created, '\t', modified)
	except:
		pass

# メインメソッド
args = sys.argv
for num in range(int(args[1]), int(args[2]) + 1):
	printShop(num)
