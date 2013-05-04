#
from google.appengine.ext.webapp import util #@UnresolvedImport
from google.appengine.ext.webapp import template #@UnresolvedImport
from google.appengine.api import channel #@UnresolvedImport
from google.appengine.api import users #@UnresolvedImport
from google.appengine.ext import ndb as db #@UnresolvedImport
from django.utils import simplejson
from google.appengine.api import memcache
from google.appengine.ext.webapp.util import login_required
from google.appengine.api import urlfetch
import pdb, sys, logging, webapp2
from datetime import datetime
import settings
from xml.dom import minidom
import urllib
import base64
import cgi
import random

logging.getLogger().setLevel(logging.INFO)


class UserPrefs(db.Model):
	user = db.UserProperty()
	data = db.JsonProperty()
	registration_status = db.TextProperty(default="Unregistered")
	key = db.TextProperty()
	
	@staticmethod
	def current():
		user = users.get_current_user()
		try:
			nup = UserPrefs.gql("WHERE user = :1", user).get()
			return nup
		except KeyError:
			return None
			#nup = UserPrefs(user=user, data=d)			
	
class Qtd(db.Model):
	current = 0
	text = db.TextProperty()
	@staticmethod
	def populate():
		filename = 'quotes.json'
		bigs = simplejson.load(file('%s' % (filename)))
		import datetime
		myitem = None
		for letter, stories in bigs.iteritems():
			for quote in stories:
				q = Qtd(parent=letter, text=quote)
				q.put()
			break
		#print self.get_stories(myitem)	
	@staticmethod
	def get():
		return Qtd().text
		#n = Qtd.count  % Qtd.count()
		#letter = random.randint(0, )
		
		#Qtd.count += 1

class Card:
	hanzi = db.TextProperty()
	meaning = db.TextProperty()
	pinyin = db.TextProperty()
	#sound = db.TextProperty()
	#fields = db.JsonProperty()




#class WordList(db.Model):



class Item(db.Model):
	name = db.TextProperty(required=True)

class Story(db.Model):
	#id = db.TextProperty(required=True)
	user = db.TextProperty()
	text = db.TextProperty()
	#item = db.KeyProperty(Item)
	vote = db.IntegerProperty()
	rank = db.IntegerProperty()
	date = db.DateTimeProperty()

class VoteReg(db.Model):
	#id = db.TextProperty()
	#user = db.UserProperty()
	#item = db.KeyProperty(Item)
	vote = db.IntegerProperty() # 0 or 1
	
class FakeUsers(object):
	def get_current_user():
		class Lol:
			def nickname():
				import random
				return 'aoeu%d' % (random.random()*256)
		return Lol()
# users = FakeUsers()

class MainHandler(webapp2.RequestHandler):
 	
	def handle(self, way, traced=False):
		#if way == 'get':
		#pdb.set_trace()

		if way == 'post':
			callfunc = db.transaction
			self.response.write('success')
			source = simplejson.loads(self.request.body)
		else:
			source = simplejson.loads(self.request.GET.keys()[0])			
			def callfunc(f):				
				self.response.headers.add_header('content-type', 'application/json', charset='utf-8')
				self.response.write(simplejson.dumps(f()))
		logging.info('aoeu %s ' %(self.request.GET))
		#pdb.set_trace()
		def f():
			return getattr(self, source[u'function'])(*source[u'args'])
		
		callfunc(f)		
	
	def get(self, what):
		#self.runtests()
		user = users.get_current_user()

		if user:
			logging.debug('headres%s'%self.request.headers)
			if 'X-Requested-With' in self.request.headers:
				#nup = UserPrefs.gql("WHERE user = :1", user).get()
				#self.response.headers.add_header('content-type', 'application/json', charset='utf-8')
				#self.response.write(nup.data)
				self.handle('get')
			else:
				buttonname = 'newbutton.html'
				if settings.SANDBOX:
					merchantId, checkUrl, _ = settings.sandboxInfo
				else:
					merchantId, checkUrl, _ = settings.realInfo
				
				price = 40 # Make sure that the price changes, and that it has some coupon code or something.
				button = template.render(buttonname, {'price':price, 'merchantId':merchantId, 'checkoutUrl':checkUrl, 'url':self.request.url})
				
				qotd = Qtd.get()
				self.response.out.write(template.render('output.html', {'button':button, 'qotd':qotd}))



		else:
			self.redirect(users.create_login_url(self.request.uri))
	
	def get_save(self):
		user = users.get_current_user()
		nup = UserPrefs.gql("WHERE user = :1", user).get()
		self.response.headers.add_header('content-type', 'application/json', charset='utf-8')
		self.response.write(nup.data)

	def post_save(self):
		user = users.get_current_user()
		logging.debug('body:%s' % self.request.body)
		logging.debug('post:%s' % self.request.POST['data'])
		d = self.request.POST['data']
		try:
			nup = UserPrefs.gql("WHERE user = :1", user).get()
			nup.data = d
		except KeyError:
			nup = UserPrefs(user=user, data=d)
		
		nup.put()
		
	
	def post_vote(self, ouser, item, v):
		#pdb.set_trace()
		story = Story.get_by_id(ouser, parent=db.Key(Item, item))
		story.vote += int(v)
		story.rank = story.vote*32 + (datetime.now() - story.date).days
		story.put()
		#votereg = VoteReg(user=ouser, parent=self.item(item), vote=v)
		
	#def item(name):	
	
	def get_stories(self, item): 
		#pdb.set_trace()
		stories = Story.query(ancestor=db.Key(Item, item))
		import time
		st = [[s.user, s.vote, s.text, time.mktime(datetime.timetuple(s.date))] for s in stories]
		return st
	
	#def get_vote(self, ouser, item):
	#	story = Story.gql('WHERE user = :1', ouser).get()
	#	return story.vote
	#	#self.response.write(story.vote)
	
	def post_story(self, itemn, text, username=None, date=None, vote=0):
		item = Item.get_by_id(itemn)
		if item is None:
			item = Item(id=itemn, name=itemn)
			item.put()
		if username is None:
			username = users.get_current_user().nickname()
		story = Story(id=username, user=username, text=text, parent=item.key, vote=vote, rank=0)
		if date is not None:
			story.date = date
		story.put()
	
	def populateStories(self):
		filename = 'chin3000'
		bigs = simplejson.load(file('%s' % (filename)))
		import datetime
		myitem = None
		for item, stories in bigs.iteritems():
			myitem = item
			for value in stories:
				d = [int(i) for i in value['lastmod'].split('-')]
				
				date = datetime.datetime(d[2], d[1], d[0])
				print date, d
				self.post_story(item, value['text'], value['author'], date, value['rating'])
			break
		print self.get_stories(myitem)		
				
	def post(self, what):
		self.handle('post')
		#user = users.get_current_user()
		#logging.debug('body:%s' % self.request.body)
		#logging.debug('post:%s' % self.request.POST['data'])
		#d = self.request.POST['data']p
		#try:
		#	nup = UserPrefs.gql("WHERE user = :1", user).get()
		#	nup.data = d
		#except KeyError:
		#	nup = UserPrefs(user=user, data=d)
		
		#nup.put()
		#self.response.headers.add_header('content-type', 'application/json', charset='utf-8')
		#self.response.write('%s' % (nup.data))
		#self.response.write('hi')
		
	#def runtests(self):
		#write = lambda s: sys.stdout.write(str(s))
		#pdb.set_trace()
		#self.post_story('lol', 'Die maggots')
		#self.post_story('lal', 'Die1 maggots')
		#self.post_story('lel', 'Dieu maggots')
		#self.post_story('lil', 'Die3 maggots')
		#pdb.set_trace()
		#self.post_vote(users.get_current_user().nickname(), 'lol', 1)
		#self.post_vote(users.get_current_user().nickname(), 'lal', -1)
		#write(self.get_stories('lol)'))
		#write(self.get_stories('lal'))
		#pdb.set_trace
		
class BuyHandler(webapp2.RequestHandler):
	@login_required
	def get(self):
		price  = 40
		if settings.SANDBOX:
			merchantId, checkUrl, key = settings.sandboxInfo
		else:
			merchantId, checkUrl, key = settings.realInfo
				
		import random
		key = '-'.join([''.join([str(random.randint(0, 9)) for i in range(4)]) for i in range(4)])
		redurl = self.request.host_url+'/register/'+''.join(key.split('-'))
		
		form_data = template.render('keyurl.xml', {'price':price, 'merchantId':merchantId, 'checkoutUrl':checkUrl, 'url':redurl, 'key':cgi.escape(key)})
		form_data = form_data.encode('utf-8', 'xmlcharrefreplace')
		#form_data = unicode(form_data)
		
		
		merid = '139786509611316'
		merkey = 'urUZ-4RVdtlVBW58c7VClQ'

		auth_string = 'Basic ' + base64.b64encode(merid + ':' + merkey)
		pref = UserPrefs.current()
		pref.key = key
		pref.put()
		url = settings.checkUrl+'/api/checkout/v2/merchantCheckout/Merchant/'+str(settings.merchantId)
		result = urlfetch.fetch(url=url,
								payload=form_data,
								method=urlfetch.POST,
								headers={'Content-Type': 'application/xml; charset=UTF-8', 'Authorization':auth_string, 'Accept':'application/xml; charset=UTF-8'})

		#log.debug(result.status_code)
		try:
			dom = minidom.parseString(result.content)
			redirect_url = dom.getElementsByTagName('redirect-url')[0].firstChild.data
			self.redirect(redirect_url)
		except:
			self.response.out.write('%s | %s' % (result.content, form_data))
	
class RegisterHandler(webapp2.RequestHandler):
	@login_required
	def get(self, id):
		logging.debug('id is ' + str(id))
		pref = UserPrefs.current()
		if ''.join(pref.key.split('-')) == id:
			pref.registration_status = 'registered'
			pref.put()
			self.redirect('/')
		else:
			self.response.out.write('The registration id is incorrect')
		self.response.out.write('Congratulations %s' % (self.request.__dict__))
		logging.debug(list(self.request.GET))
		logging.debug(self.request.body)
		logging.debug(self.request.headers)
		pdb.set_trace()
		

def main():
	application = webapp2.WSGIApplication([ ('/buy', BuyHandler),
											('/register/(.*)', RegisterHandler), 
											('/(.*)', MainHandler)],
                                         debug=True)

	util.run_wsgi_app(application)

if __name__ == '__main__':
	main()
