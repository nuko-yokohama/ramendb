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


def printComment(num):
	url = 'https://ramendb.supleks.jp/review/' + str(num) + '.html'
	try:
		res = req.urlopen(url)
		soup = BeautifulSoup(res, "html.parser")
		if soup is None :
			print ("BeautifulSoup error.")
			return

		# div props
		divPropse = soup.find('div', class_="props")
		links = divPropse.find_all('a')
		if links is None :
			# Skip
			print("num=',num, ',links is None")

		if len(links) == 5 :
			# Japan shop review
			# user_id
			user_id = url2uid(links[3].attrs['href'])
		else :
			# Foreign shop review
			# user_id
			user_id = url2uid(links[2].attrs['href'])


		# menu
		commentNode = soup.find('div', id="comment")
		if commentNode is None :
			return
		else :
#			print("commentNode=", commentNode)
			links = commentNode.find_all('a')
#			print("links=", links)

			if links is None :
				return


			a_count = len(links)
#			print("a_count=", a_count, " linkes=", links)

			for i in range(0, a_count):
				
				url = links[i].attrs['href']
				if not "html" in url :
					comment_id = url2uid(url)
					if comment_id != user_id :
#						print("comment_id=", comment_id)
						cm = format(num) + '\t' + format(user_id) + '\t' + format(comment_id)

						try:
							print(cm.encode('cp932','ignore').decode('cp932'))
						except UnicodeError as e:
							print("Unicode error", e)

			if (num % 100) == 0  :
				sys.stderr.write ('progress, num=' + format(num) + '\n')
	except:
		sys.stderr.write ('error, num=' + format(num) + '\n')
		pass

# メインメソッド
args = sys.argv
#sys.stdout = codecs.getwriter('utf8')(sys.stdout)
for num in range(int(args[1]), int(args[2]) + 1):
	printComment(num)
