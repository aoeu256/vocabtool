import os, sys


import time
from datetime import date

import SendKeys as sk

SendKeys = sk.SendKeys

def changestuff():
	def butpress(c='1'):
		sk.key_down(91)
		SendKeys(c)
		sk.key_up(91)
	butpress('1')
	SendKeys('{F5}')
	#SendKeys('a')
	butpress('2')

print 'starting'

depfiles = ['%s/js/game.coffee' % os.getcwd(), '%s/dummy.html' % os.getcwd(), '%s/a.htm' % os.getcwd()]
names = ['game', 'dummy', 'a']
oldtimes = dict((k, -1) for k in depfiles)
while True:	
	for filename, name in zip(depfiles, names):
		newt = os.path.getmtime(filename)
		if oldtimes[filename] != newt:
			oldtimes[filename] = newt
			file('archive/%s_%s'%(date.today(), name), 'w').write(file(filename).read())
			if 'dummy' in filename:
				os.system(r'c:\Python27\python.exe addfooter.py')
			changestuff()
			print 'changed ', filename

	time.sleep(.15)
	
os.system("pause")