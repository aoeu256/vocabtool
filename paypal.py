import urllib, urllib2, os 
from google.appengine.ext import webapp 
from google.appengine.ext import db 
from google.appengine.api import mail 
from google.appengine.api import urlfetch 
from google.appengine.ext.webapp import template 
from google.appengine.ext.webapp.util import run_wsgi_app 
PP_URL = "https://www.sandbox.paypal.com/cgi-bin/webscr" 
AccountEmail = "mysandbox_1234542796_...@example.com" 
#PP_URL = "https://www.paypal.com/cgi-bin/webscr" 
#AccountEmail = "myrealem...@example.com" 
class MyPayPalHandler(webapp.RequestHandler): 
        def post(self): 
                parameters = None 
                if self.request.get('payment_status') == 'Completed': 
                        if self.request.POST: 
                                parameters = self.request.POST.copy() 
                        if self.request.GET: 
                                parameters = self.request.GET.copy() 
                else: 
                        self.response.out.write('Error, sorry.') 
                if parameters: 
                        parameters['cmd']='_notify-validate' 
                        params = urllib.urlencode(parameters) 
                        status = urlfetch.fetch( 
                                url = PP_URL, 
                                method = urlfetch.POST, 
                                payload = params, 
                                ).content 
                        if not status == "VERIFIED": 
                                self.response.out.write('error') 
                                parameters['homemadeParameterValidity'] 
=False # I still log users 
data in my db, just in case 
                if parameters['receiver_email'] == AccountEmail: 
                        #invoiceID = parameters['invoice'] etc etc 
etc... 
                        self.response.out.write('ok') 
