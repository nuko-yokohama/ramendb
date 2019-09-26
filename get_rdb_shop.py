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
# get_site_flag(node)
#
def get_site_flag(node):
	if node.has_attr('class') :
		flag = "false"
	else :
		flag = "true"
	return flag

#
# get status(soup)
#

#
def get_status(soup):
	statusNode = soup.find('span', class_="plate retire")
	if statusNode is not None :
		return "closed"
	statusNode = soup.find('span', class_="plate moved")
	if statusNode is not None :
		return "moved"
	return "open"

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

		# shop status
		status = get_status(soup)

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

		if len(links) == 2 :
			# created and modified link empty
			created = "0"
			modified = "0"
		elif len(links) == 4 :
			# exist created only
			# TODO: moderator crated, user modified case. 
			created = url2uid(links[0].attrs['href'])
			modified = "0"
		else :
			# exist created and modified
			created = url2uid(links[0].attrs['href'])
			modified = url2uid(links[2].attrs['href'])

		# shop tabs
		div_shop_tabs = soup.find('div', id='shop-tabs')
		# print("div_shop_tabs=", div_shop_tabs)
		links = div_shop_tabs.find_all('a')
		if links is None :
			# Skip
			sys.stderr.write("num=',num, ',shop tabs links is None\n")
		ramendb = get_site_flag(links[1]) 
		currydb = get_site_flag(links[2]) 
		chahandb = get_site_flag(links[3]) 
		gyouzadb = get_site_flag(links[4]) 
		udondb = get_site_flag(links[5]) 
		sobadb = get_site_flag(links[6])

		site_info = '{' + '"ramendb":' + ramendb + ',"currydb":' + currydb + ',"chahandb":' + chahandb + ',"gyouzadb":' + gyouzadb + ',"udondb":' + udondb + ',"sobadb":' + sobadb + "}"

		# output shop record
		shop = format(num) + '\t'+ status + '\t' + shopName + '\t' + branch + '\t' + pref + '\t' + area + '\t' + created + '\t' + modified + '\t' + site_info
		try:
			print(shop.encode('cp932','ignore').decode('cp932'))
		except UnicodeError as e:
			print("Unicode error", e)
	except:
		sys.stderr.write ('exception, num=' + format(num) + '\n')
		pass

# メインメソッド
args = sys.argv
for num in range(int(args[1]), int(args[2]) + 1):
	printShop(num)
