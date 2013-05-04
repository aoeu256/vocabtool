#dir = (ob) ->
#  out = []
#  for attr of ob
#    out.push attr
#  out.sort()
#  out
"strict"

DEBUG = false
VERSION = 3

# if DEBUG is true
# 	Global = {obj:{}}
# 	Global.obj.__noSuchMethod__ = ((s) -> return ((s) -> null))
# 	$ = ->
# 		return Global.obj

Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

loadImage = (name) ->
	img = new Image()
	img.src = "images/" + name + ".png"
	log "failed loading image"  unless img
	img
fixAng = (a) ->
	ang = a
	ang -= 2 * Math.PI  while ang > 2 * Math.PI
	ang += 2 * Math.PI  while ang < 0
	ang
zfill = (n, v, optC) ->
	s = n + ""
	c = optC or "0"
	i = s.length

	while i < v
		s = c + s
		i++
	s

createObject = (o) ->
  F = -> {}
  F.prototype = o
  return new F()

clamp = (a, mn, mx) ->
	Math.max Math.min(a, mx), mn

#if !(console in window)
#	window.console.log = (s) -> null

Object.clone = (obj) ->
	target = {}
	for i of obj
		target[i] = obj[i]  if obj.hasOwnProperty(i)
	target

Object.update = (target, obj) ->
	for i of obj
		target[i] = obj[i]  if obj.hasOwnProperty(i)

construct = (constructor, args) ->
	F = ->
		return constructor.apply(this, args)
	F.prototype = constructor.prototype
	return new F()

copyObject = (cls, data, args=[]) ->
	o = construct cls, args
	for k in data
		o[i] = data[i] if data.hasOwnProperty(i)
	return o

Object.size = (obj) ->
	(1 for key of obj).length

Object.keys = (obj) -> (x for x in obj if obj.hasOwnProperty(x))
Object.values = (obj) -> (obj[x] for x in obj if obj.hasOwnProperty(x))
	
load = ->
	parseData = (line) ->
		ndat = line.split(" ")
		key = ndat[1]
		pron = [ndat[2].slice(1)]
		s = ""
		i = 3
		loop
			pron.push ndat[i]
			if ndat[i][ndat[i].length - 1] is "]"
				last = pron.length - 1
				pron[last] = pron[last].slice(0, pron[last].length - 1)
				break
			i++
		meaning = ndat.slice(i + 1).join()
		meaning = meaning.slice(1, meaning.length - 1)
		#hanzi2data[key] = [pron, meaning]
	loadData = (dat) ->
		lines = dat.split("\n")
		for line of lines
			parseData line
	$.ajax
		url: "cmudict.txt"
		success: loadData
		dataType: "text"

arrayRepeat = (val, n) ->
	if n > 1
		(val for i in [1..n])
	else
		[]
randItem = (lst) ->
	lst[Math.floor(Math.random() * lst.length)]

arrayCut = (arr, x) ->
	arr.slice(0, x).concat arr.slice(x + 1, arr.length)

# $(window).load ->

arrayCut = (arr, x) ->
	arr.slice(0, x).concat arr.slice(x + 1, arr.length)

shift = (arr) ->
	newarr = (i for i in arr when i isnt "")
	tail = arrayRepeat("", arr.length-newarr.length)
	[newarr.concat(tail), newarr.length]

hashFromPairs = (pairs) ->
	hash = {}
	for [key, value] in pairs
		hash[key] = value
	hash

permute = (lst) ->
	newlst = (x for x in lst)
	for x of lst
		r = Math.floor Math.random()*lst.length        
		[newlst[x],newlst[r]] = [newlst[r], newlst[x]]
	newlst

set = (lst) ->
	d = {}
	for x in lst
		d[x] = true
	d

getdefault = (obj, key, v) ->
	if key in obj
		obj[key]
	else
		v	

playchainsound = (n) ->
	null

class MyLog
	constructor: (@list=[]) ->

	put: (args...) ->
		@list.push args

	output: ->
		for i in @list
			console.log i

sm2interval = (EF, intv, q) ->
	ef=Math.max(EF+(0.1-(5-q)*(0.08+(5-q)*0.02)), 1.3)
	pv = parseInt intv
	if pv is 0
		return [1, ef]
	else if pv is 1
		#return [6, ef]
		return [5+randItem([0,1,2]), ef]
	else
		return [intv*ef, ef]

filterlist = (listA, subList) ->
	rb = set(subList)
	(i for i in listA when not rb[i]?)

daydiff = (a, b=0) ->
	(a-b)/24.0/3600.0/1000

splitAt = (n, lst) ->
	[lst[0..n], lst[n+1..]]

tomorrow = (day=1) ->
	Date.now() + 24.0*3600*1000.0*day

cleared = (lst) ->
	all (i is '' for i in lst)

Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc


addOrSet = (d, k, v=1) ->
	if d[k]?
		d[k] += v
	else
		d[k] = v

			# makeBlink = (ob, cls) ->
			# 	(t) ->
			# 		if t % 4 < 2
			# 			ob.addClass cls
			# 		else
			# 			ob.removeClass cls
			# @timer.push #error timer
			# 	t: 10
			# 	action: makeBlink(ob, clas)

DISABLE_SOUND = true

class SoundEffect
	constructor: (@name) ->
		if not DISABLE_SOUND
			@_snd = new Audio('');
			@_snd.src = '/sounds/'+@name+'.wav'
	play: ->
		if not DISABLE_SOUND
			@_snd.play()
		#console.log 'playing', @name

sounds = ['click1', 'click2', 'click3', 'success', 'failure', 'click']

Sound = {}
for i in sounds
	Sound[i] = new SoundEffect i

Sound.click.play = -> 
	Sound[i+randItem([1, 2, 3])].play()

class StatDay
	constructor: (@date=0, @time=0, @new=0, @review=0) ->

tapev = (e) ->
	if e.target.classList[0] is 'ui-icon'
		e = $(e.target).parent()
	else
		e = e.target
	$(e).parent()

tapid = (e) ->
	$(tapev(e)).attr('id').split('_')


class Stats
	constructor: (game) ->
		@days = {}
		@nreviewed = {}
		@nNew = {}
		avg = new StatDay()
		@startday = new Date(game.now())

	average: (game, day1, day2) ->
		sum = new StatDay()
		avg = new StatDay()
		nday = 0
		for i in [day1..day2]
			nday++
			for stat in sum
				sum[stat] +=  getdefault @days, i, 0
		for stat in sum
			avg[stat] = sum[stat] / nday
		return avg
	push: (game, d) ->
		nowdate = new Date game.now()
		mastered = (i for i in game.interval if i > 150)
		@days[nowdate.toDateString()] = new StatDay nowdate, d.time
		#console.log 'days is ', @days

	addreviewed: (game, n) ->
		nowdate = new Date game.now() 
		addOrSet @nreviewed, nowdate.toDateString(), n

	addnov: (game, n) ->
		nowdate = new Date game.now() 
		addOrSet @nNew, nowdate.toDateString(), n

class WordList
	constructor: (@title, @tabdata, @cols, @author, @nusers) ->

	showmode: ->
		null

class Game
	now: ->
		if @nowtime
			return @nowtime
		else
			return Date.now()

	constructor: (@words, @hanzi2data, @DEBUG={}, @cols = ['hanzi', 'pinyin', 'keyword']) ->
		@_nowtime = null
		@_oldtime = null
		Object.defineProperty @, 'nowtime',
			get: -> @_nowtime - @_oldtime + Date.now()
			set: (v) -> 
				@_nowtime = v
				@_oldtime = Date.now()
		@Nitems = 10
		@ndone = 0

		@showqueue = []
		@failqueue = []
		@errorqueue = []
		@history = []
		@interval = {}
		@reviewcards = []
		@keyword = arrayRepeat "", @Nitems
		@pinyin = arrayRepeat "", @Nitems
		@hanzi = arrayRepeat "", @Nitems#new Proxy(arrayRepeat( "", @Nitems), hanzHand)
		@slotmode = arrayRepeat "", @Nitems
		@errormode = arrayRepeat "", @Ntimes
		@rowq = arrayRepeat -1, @Nitems
		@_Tips = new Tips()
		@tip = (t) -> @_Tips.tip t
		@stat = new Stats @
		#@hanzi = arrayRepeat "", @Nitems
		#Globals.CLEARROW = false
		#Globals.loc = ''
		# hanzHand = 
		# 	n: 0
		# 	prev: arrayRepeat "", @Nitems
		# 	get: (target, id) ->
		# 		return target[id]
		# 	set: (target, id, val) ->
		# 		target[id] = val
		# 		if all (i is '' for i in target)
		# 			hanzHand.n++
		# 			if not Globals.CLEARROW
		# 				console.log 'hset', hanzHand.n, [target, id, val].toSource()
		# 				hanzHand.prev = target[..]
		# 			if Globals.loc is 'm'
		# 				console.log 'mset', hanzHand.n, [target, id, val].toSource() 
		@word2col = {}
		@select = {}
		@wordid = 0
		@mode = {}
		@timer = {}
		@Updatetable = true
		@loopcount = 0
		@gamehistory = []
		@laststate = []
		@clicktime = {}
		@laststatec = 0
		@hanzi2clicktime = {}
		@review = {}
		@error = {}
		@penalty = {}
		@locked = false
		@maxreviews = 80
		@errorwords = []
		@matchwords = []
		@errormatch = []
		@newperday = 20
		@shownday = 0
		@lasttime = @now()
		@goaltime = 0
		@dueday = {}
		@deltaday = {}
		@lastseen = {}
		@newperweekday = {}
		@round2 = false
		@curstate = ['show', 1, false]
		@avg_zinterval = {} # average interval of all cards hanving zi
		@datalen = @cols.length-1
		@key = @cols[0]
		@datacols = @cols[1..]
		@ncongrats = 0
		@chains = {}
		@skipcorrect = 0
		@skipped = {}
		@succfail = {} # for leeches
		@leechrate = 5		
		@skipped = {}
		@storyRating = {}
		@storyRated = {}
		@colTitles = @cols
		
		if @words.length % (@Nitems * 2) != 0
			alert 'words is not divisible by ', (@Nitems * 2)

		#@makezigroups()

	popupStories: (it) ->
		#console.log 'lol'
		#text = """ """
		
		storyelement = (text, author, date, rating) =>
			item = '私'
			userid = 'lol'+randItem [0..20]
			storyid = userid+'_'+item
			storycont = '<div style="display=block; float: left;">'
			storycont += '<p style="margin-bottom:0px">'+text+'</p>'	
			minbot = '<a data-role="button" data-iconpos="notext" id="plus_'+storyid+'" class="ratebut" data-inline="true" data-theme="b" data-icon="plus"></a>'
			plusbot  = '<a data-role="button" data-iconpos="notext" id="min_'+storyid+'" class="ratebut" data-inline="true" data-theme="b" data-icon="minus"></a>'
			a = '<a>'+author+'</a>  Rating:<span id="rating_'+storyid+'">'+rating+'</span>'
			b = plusbot+minbot
			#c = '<div class="ui-block-c">'+minbot+'</div>'
			d = new Date(date)
			d = d.toLocaleDateString()
			grid = '<div class="lol style="display:table;"><h3 style="margin-top:0px; margin-bottom:0px; float: left">'+a+b+'</h3><small style="float: right; line-heighT: 300%;">'+d+'</small></div>'
			storycont += grid
			storycont += '</div>'
			storycont += '<hd/>'
			@storyRating[storyid] = rating
			@storyRated[storyid] = false
			return storycont

		stories = ''
		storylst = []

		$('#storypopup').show()
		$('#storypopup div h3').html($('#storypopup div h3').html()+' - '+it)
		$.mobile.changePage('#storypopup', 'pop', true, true)		
		$cont = $('#storypopup [data-role="content"]')
		$cont.html($cont.html()+'<div id="loadcont">Loading...</div>')
		$cont.trigger 'create'


		@call 'get_stories', it, (data, a, b) => 
			storylst = JSON.parse data
			for [author, rating, text, date] in storylst
				console.log [author, rating, text, date]
				#text = ('AAA ' for i in [0..Math.random()*10+3])
				#text = text.toString()
				stories += storyelement(text, author, date, rating)
			$('#loadcont').html(stories)	
			$cont.trigger 'create'
		
			$('#storypopup a[data-role="button"]').unbind('tap').tap (e) =>
				[typ, userid, item] = tapid e
				id = userid+'_'+item
				console.log 'oeu', [typ, userid, item]
				
				n = 1 if typ is 'plus'
				n = -1 if typ is 'min'
				other = if typ =='plus' then 'min' else 'plus'
				if $('#'+other+'_'+id).hasClass 'ui-disabled'
					$('#'+other+'_'+id).removeClass 'ui-disabled'
				else
					$('#'+typ+'_'+id).addClass 'ui-disabled'
							
				@storyRated[id] = true			

				addOrSet @storyRating, id, n
				
				console.log id
				$('#rating_'+id).text @storyRating[id]
				@call 'post_vote', [userid, item, n]

		# closebtn = '<a href="#" data-rel="back" data-role="button" data-theme="a" data-icon="delete" data-iconpos="notext" data-shadow="false" data-iconshadow="false" class="ui-btn-right">Close</a>'
		# top = '<div id="poptop" data-role="header" data-theme="a" class="ui-corner-top"> Choose your story' + closebtn + '</div>'
		# textarea = '<div id="textpop" data-role="content" data-theme="d" class="ui-corner-bottom ui-content" max-height="75%" overflow-y="scroll">'+text+'</div>'
		# popup = '<div data-role="popup" id="popup" data-theme="d" data-overlay-theme="a" data-corners="false" class="ui-corner-all" data-tolerance="15">' + top + textarea + '</div>';

		# $.mobile.activePage.append(popup).trigger 'pagecreate'
		# $('#popup').popup()
		# console.log $('#popup')
		

		
		#$('#storypopup a')[0].trigger 'click'
		#$("#popup").popup 'open'

			# // Set a max-height to make large images shrink to fit the screen.
			# $( document ).on( "popupbeforeposition", ".ui-popup", function() {
			# 	// 68px: 2 * 15px for top/bottom tolerance, 38px for the header.
			# 	var maxHeight = $( window ).height() - 68 + "px";

			# 	$( "img.photo", this ).css( "max-height", maxHeight );
			# });

		$(document).on "popupafterclose", ".ui-popup", (e) ->
			$(e.target).hide()
	matchdata: (zi) ->
		rhand = (@[i][@select[i]] for i in @datacols)
		console.log 'rhand', rhand
		return  JSON.stringify(@hanzi2data[zi]) is JSON.stringify(rhand)
		#JSON.stringify(@hanzi2data[zi]) is JSON.stringify([@pinyin[@select['pinyin']], @keyword[@select['keyword']]])

	makezigroups: ->
		@zigroup = {}

		for word in @words
			for zi in word
				if @zigroup[zi]?
					@zigroup[zi].push word
				else
					@zigroup[zi] = [word]
	updateZiGroup: (zi) ->
		words = @zigroup[zi]
		otherwords = (i for i in words when i isnt zi)
		ointv = (@interval[i][0] for i in otherwords)
		allintv = (@interval[i][0] for i in words)
		sum = (lst) ->
			s = 0
			for o in lst
				s += o
			return s
		oavg = sum(ointv)/ointv.length
		allavg = sum(allintv)/allintv.length
		adjf = allavg/oavg

	newtoday: ->
		return @newperweekday[(new Date(@now())).getDay()]
	
	switchPage: (page) ->
		$.mobile.changePage('#'+page+'page')
		if @[page+'_start']?
			@[page+'_start']()

	goal_start: -> # Please finish
		elapsedTime = @now() - @gamestarttime
		#console.log elapsedTime, @minuteFormat(999999999999)
		string2id = 
			ctime: 'Completion Time:'+@minuteFormat elapsedTime
			cardsdue: "Tomorrow at this time #{@dueTomorrow().length} cards are due for review."
			newcards: "Tomorrow #{@newperday} new cards will be shown."
		for key, tex of string2id
			$('#'+key).text(tex)
		@stat.push @, {time:elapsedTime}

		$('#finishbut').unbind('click').click =>
			@switchPage 'start'
		console.log string2id

	start_start: ->
		@shownday = 0
		@curstate = ['show', 1, false]
		dd = daydiff @now(), @lasttime
		string2id = 
			ndue: @dueToday(dd).length
			wordid: @wordid
			wordlen: @words.length
		for key, tex of string2id
			$('#'+key).text(tex)
		$('#reviewbut').unbind('click').click =>
			@newperday = parseInt $("#newperday input[type='radio']:checked").val()
			@maxreviews = parseInt $("#maxreviews input[type='radio']:checked").val()
			#alert 'new, max', @newperday, @maxreviews
			#if @wordid < words.length
			@switchPage 'game'
			#else
				

	game_start: ->
		@slottime = arrayRepeat 0, @Ntimes
		@slotq = arrayRepeat 0, @Ntimes
		@nreviewed = 0
		@zishift = {}
		@gamestarttime = @now()
		#console.log @curstate
		@curstate = ['show', 1, false]
		@chainn = 0
		@drawTab()
		#console.log 'gamestart is called'		
		@nextloop()

	geticon: (state, errorstate) ->
		if state is "match"
			{'correct':'check', 'wrong':'delete', 'none':'alert'}[errorstate]
		else
			{'show':'radio-off', 'done':'radio-on', 'wrong':'close'}[state]
	
	doslot: (col, tr, state=null, contents=null) -> 
		if DEBUG is true
			return
		# if state is 'hilight' or state is 'match' and @select[col] is tr
		# 	theme = 'e'
		# else
		# 	theme = 'c'

		$elt = $("##{col}_#{tr}")
		state = state ? @slotmode[tr]

		icon = @geticon state, @errormode[tr]
		$elt.buttonMarkup icon:icon if icon
		
		$elt.find('a').text contents 	if contents isnt null
		if col is 'hanzi' and state is 'match' and @rowq[tr] >= 2
			
			$elt.find('a').text(@hanzi[tr]+' '+(@rowq[tr]-1))
		if contents is 'empty' # or state is 'match' and @errormode[tr] in ['correct', 'wrong']
			$elt.addClass('ui-disabled')
		else
			$elt.removeClass('ui-disabled')
		
	updateSlot: (tr) ->
		if DEBUG is true
			return
		state = @slotmode[tr]
		change = (s, val, icon=null) ->
			$elt = $ '#'+s
			$elt.find('a').text(val)
			if val is 'empty'
				$elt.addClass('ui-disabled')
				$elt.buttonMarkup {'icon':''}
			else
				$elt.removeClass('ui-disabled')
			if icon isnt null
				$elt.buttonMarkup {'icon': icon}
		
		state2icon = {'show':'radio-off', 'done':'radio-on'}
		if state in ["show", "done"]
			#$but.attr 'class', 'changestate'
			change 'hanzi_'+tr, @hanzi[tr], state2icon[state]
			for col in ['pinyin', 'keyword']
				change col+'_'+tr, @[col][tr], 'info'
		else if state is "match"
			error2icon = {'correct':'check', 'wrong':'close', 'none':'alert'}
			for col in @cols
				@doslot col, tr, 'match', @[col][tr]
				#change col+'_'+tr, @[col][tr]
				#replaceIcon "#{col}_#{tr}", error2icon[@errormode[tr]] if col is 'hanzi'
				
		else if state is ''
			for col in @cols
				change col+'_'+tr, 'empty'
				
		#$('ul').listview('refresh')

	changeSlot: (tr, state) ->
		@slotmode[tr] = state
		@errormode[tr] = 'none' if state is 'match'
		@slottime[tr] = 0		if state is 'match'
		@updateSlot tr

	zimode: (tr, state) =>
		@mode[@hanzi[tr]] = state
		# if its visible change the appearance of the slot...
		@updateSlot tr
	
	queuepop: (n, queu) ->
		lst = []
		for qu in queu
			if qu.t is 0
				while lst.length<n and qu.items.length>0
					lst.push [qu.items.pop(), 'match']
		lst
	getWords: (n) ->
		lst = @queuepop(n, @errorqueue)
		lst = @queuepop(n-lst.length, @showqueue)
		if @DEBUG['queue']
			@log "@showqueue is #{lst.toSource()}"
		@showqueue = (i for i in @showqueue when i.items.length > 0)		

		wd = n-lst.length
		@wordid += wd
		tail = ([i, 'show'] for i in @words[@wordid-wd..@wordid-1] )		
		return lst.concat tail

	log: (s) ->
		console.log s
	
	clone: ->
		removeSet = 'gamehistory laststate laststatec _looplog save'
		removeSet = set removeSet.split(' ')
		target = {}
		for i of @
			target[i] = @[i]  if @.hasOwnProperty(i) and not removeSet[i]?
		target

	shifthanzi: (debug=false) ->
		hanzi2slot = {}
		for i in [0..@hanzi.length-1]
			if @hanzi[i]
				hanzi2slot[@hanzi[i]] = [@slotmode[i], @errormode[i], @slottime[i], @pinyin[i], @keyword[i]]
		if @loopcount > 0 and debug
			@log [@hanzi, hanzi2slot, @.clone()]	
		[@hanzi, beg] = shift @hanzi
		if @loopcount > 0 and debug
			@log [@hanzi, beg]
		for key, data of hanzi2slot
			i = @hanzi.indexOf key
			[@slotmode[i], @errormode[i], @slottime[i], @pinyin[i], @keyword[i]] = data
			@changeSlot i, @slotmode[i]
		return beg
		
	updateAllSlots: ->
		for i in [0..@hanzi.length-1]
			@changeSlot i, @slotmode[i]
	
	newgamehistory: (locals) ->
		d = Object.clone(@)
		delete d['gamehistory']
		for key, value of locals
			d[key] = value
		@gamehistory.push d

	row: (i) ->
		[@slotmode[i], @errormode[i], @slottime[i], @hanzi[i], @pinyin[i], @keyword[i]]
	setrow: (i, val) ->
		[@slotmode[i], @errormode[i], @slottime[i], @hanzi[i], @pinyin[i], @keyword[i]] = val
	allcol: ->
		(@row i for i in [0..@Nitems-1])

	updateDueToday: (n=0) ->
		dd = daydiff @now(), @lasttime
		dueToday = []
		for k, v of @dueday
			#@dueday[k] -= dd
			if @dueday[k] - dd < n and @nreviewed < @maxreviews
				@nreviewed++
				dueToday.push [k, @dueday[k]]
				@deltaday[k] = @dueday[k] - dd
				delete @dueday[k]
		dueToday.sort (a, b) -> a[1] < b[1]
		return dueToday

	dueToday: () ->
		dd = daydiff @now(), @lasttime
		return (k for k, v of @dueday when v - dd < 0.05)
	
	dueTomorrow: ->
		dd = daydiff @now(), @lasttime
		return (k for k, v of @dueday when v - dd < 1.05)

	getnextstate: (mode, round, error) ->
		#elapsedTime = @now() - @lasttime

		pushround = () =>
			console.log 'pushing round', [mode, round, error, @errorwords]
			@saveround = [mode, round, error]

		dd = daydiff @now(), @lasttime
		#console.log ['dd', @now(), @lasttime, dd]

		if dd > 1.0
			#@showntoday = 0
			dueToday = @updateDueToday()			
			@reviewcards = @reviewcards.concat (i[0] for i in dueToday)
			console.log 'dueToday', dueToday, 'days elapsed:', dd, @reviewcards

		@lasttime = @now()

		# if @reviewcards.length > 1
		# 	pushround()
		# 	[@error2, @reviewcards] = splitAt @Nitems, @reviewcards
		# 	console.log 'split', [@error2, @reviewcards]
		# 	@errormatch.push [@error2, @loopcount]
		# 	console.log 'gn', @errormatch 
			#return ['show', 1, true, @error2]
		@error2 = (i for [i, lp] in @errorwords when lp<@loopcount)
	
		if error
			console.log 'popping round', @saveround
			[mode, round, error] = @saveround
		if @error2.length > 2
			pushround()

			console.log 'error2', @error2, @errorwords
			@error2 = @error2[0..@Nitems-1]
			@errormatch.push [@error2[..], @loopcount]
			erse = set @error2
			@errorwords = ([a,b] for [a,b] in @errorwords when not erse[a]?)

			#@errcount = @loopcount
			#console.log 'error2', @error2
			return ['show', 1, true, @error2]

		if @errormatch[0]? and @errormatch[0][1] <= @loopcount-1			
			em = @errormatch.shift()[0]
		else
			em = []
		if @reviewcards.length > 1
			[rc, @reviewcards] = splitAt @Nitems-em.length, @reviewcards
		else
			rc = []
		d = rc.concat em
		
		if d.length > 1
			console.log 'recards, errmatch', [rc, em]
			pushround()
			return ['match', 1, true, d]
		if error
			console.log 'Returning to normal:', [mode, round, error]
			#return [mode, round, false]

		if round is 1
			normode = [mode, 2, error]
			#if @round2 is true
			#	console.log 'normode is', normode
		else
			newmode = if mode is 'show' then 'match' else 'show'
			normode = [newmode, 1, error]
		if mode is 'show'
			#console.log 'info', [@wordid, @shownday, @newperday]
			if @shownday is @newperday or @wordid >= @words.length
				return ['congrat', 0, true, []]
			else
				words = @words[@wordid..(@wordid+@Nitems)-1]
				@wordid += @Nitems
				@shownday += @Nitems
				@review[round] = (i for i in words if not @skipped[i]?)
				for w in words
					@lastseen[w] = @now()
		else if mode is 'match'
			words = @review[round]
		return [normode[0], normode[1], normode[2], words]

	minuteFormat: (t) ->
		totseconds = t / 1000
		seconds = parseInt(totseconds % 60)
		minutes = parseInt(totseconds / 60)
		if totseconds / 3600 >= 1.0
			minutes = 59
			seconds = 59
		return "#{zfill minutes, 2}:#{zfill seconds, 2}"

	nextloop: ->		
		[state, round, error] = @curstate		
		if state is 'goal'
			console.log 'no next cuz of goal'
		[nstate, nround, nerror, words] = @getnextstate state, round, error		
		console.log @curstate, nstate, nround, nerror, words

		if not words? or words.length == 0
			if nstate is 'congrat'
				@curstate = [nstate, nround, nerror]
				@switchPage 'goal'
				return
			console.log 'error words is empty'
		else
			if not nerror
				@gameloop state, round, error, words
				@curstate = [nstate, nround, nerror]
			else
				@gameloop nstate, nround, nerror, words
				@curstate = @saveround
			

	dummyitems: (n) ->
		start = @wordid+@newperday
		words = @words[start..start+n-1]
		if words.length < n
			words = words.concat @words[0..n-words.length-1]
		return words

	dotips: (mode, round, error, wordsource) ->
		if mode is 'show' and round is 1
			@tip tip.showround1tip
		else if mode is 'match' and round is 1
			@tip tip.matchtip


	gameloop: (mode='show', round=1, error=false, wordsource, postsave=false) ->
		#@_looplog = @_looplog ? new MyLog []

		@dotips mode, round, error, wordsource
		@actualstate = [mode, round, error]
		errors = if error then 'ERROR' else ''
		$("#mode").text("#{mode.toUpperCase()} #{round} #{errors}");
		swapDat = []
		for i in [0..@Nitems-1]
			@clearRow i
		@Nnewitems = wordsource.length
		if mode is 'match'
			wordsource = wordsource.concat @dummyitems(@Nitems-@Nnewitems)
		prevhanz = []

		for i in [0..wordsource.length-1]
			@hanzi[i] = wordsource[i]
			try
				[@pinyin[i], @keyword[i]] = @hanzi2data[@hanzi[i]]
			catch err
				console.log 'error', i, @hanzi[i], wordsource, @hanzi
				throw err

			@changeSlot i, mode

			swapDat.push i 		if mode is 'match'

		# if mode is 'match'
		# 	dummy = @dummyitems(@Nitems-@Nnewitems)
		# 	console.log 'swapdat1', swapDat, dummy
		# 	if dummy is not []
		# 		swapDat = swapDat.concat [@Nnewitems..@Nitems-1]
		# 	#console.log 'swapdat2', swapDat
		# 	for x, h of dummy
		# 		#console.log x, h
		# 		@hanzi[x+@Nnewitems] = h

		#if all (i is '' for i in @hanzi)
		#	console.log 'h1', wordsource
		#	console.log 'h', @hanzi, @hanzi.length, @loopcount

		for datind, col of ['pinyin', 'keyword']
			for x, z of permute swapDat
				#if Object.size(@dueday) > 0
				#	console.log col, x, swapDat[x], z, swapDat[x], @hanzi, @hanzi[z]				
				@[col][swapDat[x]] = @hanzi2data[@hanzi[z]][datind]

		if mode is 'match' and @Nnewitems < @Nitems
			for i in [@Nnewitems..@Nitems-1]
				@hanzi[i] = 'empty'
				#@errormode[i] = 'none'2

		@updateAllSlots()
		@unselectall()
		if swapDat.length > 0
			#if Object.size (select) isnt 0
			#	console.log 'wtf wtf wtf wtf wtf', @select
			@nextMatchable()

		@savePost()			if postsave
		
		if mode is 'show' and $('#skipbut').length is 0
			$but = $('<a id="skipbut" data-role="button">Continue Skipping Non-selected items"</a>')
			$but.appendTo('#main')
			$but.trigger 'create'
			$but.button()
			$but.click (=> @skipbutton())
		else if mode is 'match' and $('#skipbut').length is 1
			$('#skipbut').remove()
		@loopcount++

		# emptyslots = (i for i in @hanzi when i is "")
		# if emptyslots.length >= 1
		# 	swapDat = []
		# 	newWords = @getWords 5
		# 	beg = @shifthanzi()
		# 	@_looplog.put 'beg', [beg, beg+newWords.length, @hanzi.length]
		# 	for i in [beg..Math.min(beg+newWords.length, @hanzi.length)-1]				
		# 		if @loopcount > 1
		# 			console.log  'hilight'
		# 		[@hanzi[i], state] = newWords[i - beg]
		# 		[@pinyin[i], @keyword[i]] = @hanzi2data[@hanzi[i]]
		# 		@changeSlot i, state
		# 		swapDat.push i  		if state is "match"
		# 		@_looplog.put [@hanzi[i], @pinyin[i], @keyword[i]]
		
		# 	for datind, col of ['pinyin', 'keyword']
		# 		for x, z of permute swapDat
		# 			@[col][swapDat[x]] = @hanzi2data[@hanzi[z]][datind]

		# 	if swapDat.length > 0
		# 		@nextMatchable()
		# 		console.log 'lol'

		# 	@updateAllSlots()

		# 	if @DEBUG['match'] and swapDat.length > 0
		# 		console.log  'swapDat ' + swapDat
		# 		console.log  'newWords ' + newWords

		# for queue in [@showqueue, @errorqueue]
		# 	for task in queue
		# 		if task.t > 0
		# 			task.t--
		# @slottime.forEach (t, i) ->
		# 	if @slotstate is 'match'
		# 		@slottime[i] = Max.min(t+1, 999)
		# @timer = (i for i in @timer when i.t > 0)
		# for task in @timer
		# 	task.t--
		# 	task.action()  if @timer[key] is 0
		#@handleErrors()
		# @newgamehistory
		# 	'emptyslots': emptyslots
		# 	'swapDat': swapDat ? null
		# 	'newWords': newWords ? null
		# 	'beg': beg ? null

	elapsedDays: (h) ->
		return getdefault @deltaday, h, 0

	handleErrors: () ->
		#console.log 'select is', @select
		zis = (@hanzi[i] for i of @errormode when @errormode[i] is 'wrong')
		newzis = (h for h in @hanzi when not @interval[h]? and h isnt '' and h isnt 'empty')
		revzis = (h for h in @hanzi when @interval[h]? and h isnt '' and h isnt 'empty')
		
		@stat.addreviewed @, revzis.length
		@stat.addnov @, newzis.length
		console.log 'new, review, wrong', [newzis, revzis, zis]
		
		@errormode.forEach (e, i) =>
			#console.log e, 
			if e in ['correct', 'wrong']
				zi = @hanzi[i]
				[ef, intv] = getdefault @interval , zi, [2.5, 0.0]
				#changeVal = getdefault @interval, @hanzi[i], 1.0
				if e is 'wrong'
					q = 0
					addOrSet @succfail, zi, 1
				if e is 'correct'
					@succfail[zi] = getdefault @succfail, zi, 0
					timed = @hanzi2clicktime[zi]
					avg = (a, b) -> (a+b)/2.0
					#d = avg(timed.pinyin,timed.keyword) - timed.hanzi
					#q = clamp 6.0-d/1000.0, 3.0, 5.0
					q = @rowq[i]
					intv -= @elapsedDays(@hanzi[i])

				#console.log  [ef, intv]
				@interval[@hanzi[i]] = sm2interval ef, intv, q
				@dueday[@hanzi[i]] = @interval[@hanzi[i]][0]

				#console.log 'int', @interval[@hanzi[i]]
				#console.log @dueday
				#@clearRow 
		
		for i in zis
			@errorwords.push [i, @loopcount]
		@nextloop()

	unselectall: (cols=['pinyin', 'hanzi', 'keyword']) ->
		for i in cols
			delete @select[i]
		for col in cols
			for row in [0..@Nitems-1]
				@hilight col, row, 'off'

	
	skipbutton: ->
		for i in [0..@Nnewitems-1]
			if @slotmode[i] isnt 'done'
				@skipped[@hanzi[i]] = true
		@done5()
		console.log 'skipped', @skipped

	done5: ->
		@ndone = 0
		#rround = if state is 'match' then 2 else 1
		#console.log [state, round, error], rround
		#@review[rround] = (z for i, z of @hanzi when @slotmode[i] is 'done')
		
		if state is 'match'
			@errormode = arrayRepeat "none", @Nitems
			@select = {}
		@nextloop()
		[state, round, error] = @curstate

		# items = []
		# for i of @hanzi
		# 	if @slotmode[i] is "done"
		# 		items.push @hanzi[i]
		# 		#@clearRow i
		# 		@ndone--
		# items.reverse()
		# @showqueue.push
		# 	t: @Done5Time
		# 	items: items

	musteq = (name, a, b) ->
		console.log name + " " + a + "=" + b

	drawTab: (mode='show') ->
		# if not @_lastmode? or mode != @_lastmode
		# 	@_lastmode = mode
		# else
		# 	return

		$('#game').empty()
		if DEBUG is true
			console.log 'fuck'
			return
		letters = 'abcdefghijklmnop'
		#col2block = {'hanzi':'a', 'pinyin':'b', 'keyword':'c'}
		pairs = ([@cols[i], letters[i]] for i in [0..@cols.length-1])
		col2block = hashFromPairs pairs

		#console.log 'col2block is', col2block
		#mode = 'SHOW'
		#if mode is 'SHOW'
		for column in @cols
			$block = $("<div/>", {"id":"#{column}_col", "class":'ui-block-'+col2block[column]})
			$lst = $ '<ul id="'+column+'" data-role="listview" data-divider-theme="b" data-inset="true"></ul>'
			$hed = $ '<li data-role="list-divider" role="heading">'+column.toUpperCase()+'</li>'
			$lst.append($hed)
			for i in [0..@Nitems-1]
				$li = $ '<li/>', {"data-theme":"c", "id":column+'_'+i, "data-mini":"true", "class":"ui-disabled"}
				$but = $ '<a class="item">empty</a>'
				$li.append $but
				$lst.append $li
				$lst.appendTo $block
			$block.appendTo("#game").trigger "create"
		
		#$("ul").listview('refresh')
		@updateButtons()

	enterTextMode: ->
		# I need to get 20$ * 5000 = 100 000$ (->75 000$)
		@matchTimer = 1000 * 30 # 25 seconds, each correct answer +10 seconds to timer

		@timerMode = true
		for col in @datacols
			for i in [0..@Nitems-1]
				id = col+'_'+i
				text = """<div data-role="fieldcontain">
    						<label for="name" class="ui-hidden-accessible">#{col} #{i}</label>
    						<input type="text" name="name" id="#{id}" value="" />
						  </div>"""

				$elt = $('#'+id)
				$elt.html(text).textinput()
				$elt.height($('#hanzi_'+i).height())
				$elt.height($('#hanzi_'+i).height())

		#@lastText = null
		
		$('.myinput').unbind('click').click (e) => 
			[col, row] = $(e.target).attr('id').split('_')
			@select['hanzi'] = parseInt(row)

		$('.myinput').unbind('change').change (e) =>
			if @matchTimer < 0
				return
			[col, row] = $(e.target).attr('id').split('_')
			if @lastText? and e.target.value.length < @lastText.length
				@matchTimer += 500
				@lastText = e.target.value
			
			#@matchFunc(id, col, false, false, true)
		
		$(".bar").animate {width:'100%'}
			duration: @matchTimer
			step: (now,fx) ->
			    pc = parseInt(now)+'%'
			    $(".percent").html(pc)
			    console.log 'now', now
		
		$bar = $('<div class="bar"><div class="parcent"></div></div>')
		$('body').append($bar)

		#enterPress = ->
			# check if correct ---
			#return

	toneScore: (word, wordTemplate) ->
		lst = []
		curWord = ''
		done = false
		w = 0
		t = 0
		wn = (c for c in wordTemplate when c.match('[a-zA-z]')).join('')
		tn = (c for c in word when c.match('[a-zA-z]')).join('')
		if word is wordTemplate
			return 2
		else if wn is tn
			return 1
		else
			return 0

	nextMatchable: ->
		@unselectall ['pinyin', 'keyword']
		start = @select['hanzi'] ? -1

		selected = null
		#searchset = [start+1..@Nitems-1].concat [0..start-1]
		searchset = [start+1..(start+@Nnewitems)]
		searchset = (i%@Nnewitems for i in searchset)
		for i in searchset
			if @slotmode[i] is 'match' and @errormode[i] is 'none'
				@doselect 'hanzi', i
				selected = i
				@setclicktime 'hanzi', @select['hanzi'], @now(), 'match'
				if @timerMode
					@nextFocus(i)
				break

	nextFocus: (n=-1) ->
		if n is -1
			alert 'error'
		for col in @cols
			#if @[col]
			elt = $('##{col}_#{i}')
			if elt.value()
				elt.focus()


	hilight: (col, id, hi=null) ->
		if DEBUG is true
			return
		guielt = @guielt col, id
		if hi is null
			guielt.buttonMarkup({'theme':'e'})
		else
			guielt.buttonMarkup({'theme':'c'})

	guielt: (col, id) ->
		$ "##{col}_#{id}" 

	doselect: (col, id) -> 
		for row in [0..@Nnewitems-1]
			@hilight col, row, 'off'
		# if col is 'hanzi'
		# 	for col in ['keyword', 'pinyin']
		# 		@hilight col, @select['col'], 'off'
		# 	@penalty[@select['hanzi']] = 
		# 		hanzi:	@getclicktime 'hanzi', @select['hanzi']
		# 		pinyin: @getclicktime 'pinyin', @select['pinyin']
		# 		keyword: @getclicktime 'keyword', @select['keyword']
		@select[col] = id
		@hilight col, id
		#@doslot col, id, 'hilight'

	flash: (col, id, start='a', end='c') ->
		act = ->
			$("##{col}_#{id}").buttonMarkup {'theme':start}
		deact = ->
			$("##{col}_#{id}").buttonMarkup {'theme':end}
		for i in [0..4]
			setTimeout act, i*150
			setTimeout deact, i*150+75

	pauselock: (t, func) ->
		@locked = true
		unlockf = =>
			@locked = false
			func()
		setTimeout unlockf, t

	ziData: (zi) ->
		try
			[pinyin, keyword] = @hanzi2data[zi]		  
		catch error
			console.log 'tried getting zi', zi
		{'keyword': keyword, 'pinyin': pinyin}

	markCorrect: (row, shift=false, q=5.0) ->
		zi = @hanzi[row]
		@errormode[row] = 'correct'
		@rowq[row] = q
		@doslot 'hanzi', row, 'match'
		@chainn += 1
		Sound.success.play()
		#@zishift[zi] = true if shift
		@skipcorrect++
		@nextMatchable() unless shift
		@_matcherror zi

	markWrong: (zislot, ctrled=false) ->
		zi = @hanzi[zislot]
		@errormode[zislot] = 'wrong'
		@rowq[zislot] = 0
		@doslot 'hanzi', zislot, 'match'
		#console.log 'zi2 is ', zi
		@nextMatchable() unless ctrled
		if @chainn > 2
			@chains[@chainn] = getdefault( @chains, @chainn, 0)+1
		@chainn = 0
		Sound.failure.play()
		@_matcherror zi

	_matcherror: (zi) ->
		for col, data of @ziData(zi)
			@flash col, @[col].indexOf data
		if (i for i in @errormode when i in ['correct', 'wrong']).length == @Nnewitems
			@unselectall()
			PTIME = 0 # 200
			@pauselock PTIME, =>
				@handleErrors()

	matchFunc: (id, col, shifted=false, ctrled=false, timeMode=false) ->
		#match = col
		#@log match
		if col is 'hanzi'
			if not shifted and not ctrled
				@doselect col, id
			else if shifted
				@markCorrect id, shifted
				@rowq[id] = 5
			else if ctrled
				@markWrong id, ctrled
		else if @select['hanzi']? or timeMode
			#if timeMode
			#	@select['hanzi'] = parseInt(id)
			matched = @[col][parseInt(id)]
			zislot = @select['hanzi']
			zi = @hanzi[zislot]
			#console.log 'zi1 is ', zi			
			if @ziData(zi)[col] is matched
				@doselect col, id
				if @matchdata(zi)
					d = 
						hanzi:	 @getclicktime 'hanzi', @select['hanzi'] ? @getclicktime 'hanzi', @select['hanzi'], 'match'
					for c in @datacols
						d[c] = @getclicktime c, @select[c]
					@hanzi2clicktime[zi] = d
					@markCorrect zislot, shifted
			else
				unless @errormode[zislot] is 'wrong'
					@markWrong zislot					
		
	setclicktime: (col, row, v, match='') ->
		@clicktime["#{col}_#{row}#{match}"] = v
	getclicktime: (col, row, match='') ->
		@clicktime["#{col}_#{row}#{match}"]

	updateButtons: ->
		$("#game .item").unbind('click').click (e) =>
			if @locked
				return
			[col, id] =  $(e.target).parent().parent().parent().attr('id').split('_')
			@saveState()
			@setclicktime col, id, @now()
			console.log [col, id, @slotmode[id]] if @DEBUG['click']
			if @slotmode[id] is 'show'
				@markDone id
				
			else if @slotmode[id] is 'match'
				@matchFunc id, col, e.shiftKey, e.ctrlKey

		$(document).unbind('keypress').keypress (e) =>
			#console.log 'e.charCdoe', e.charCode, e.keyCode		
			if @actualstate[0] is 'show'
				if e.keyCode is 27
					@done5()
			if @actualstate[0] is 'match'					
				if e.keyCode is 27
					for i in [0..@Nnewitems-1]
						if Math.random() < 0.5
							@markCorrect i, false, randItem [2, 3, 4]
						else
							@markWrong i
					return
				q = e.charCode - 48
				if q >= 1 and q <= 4				
					if q is 1
						@markWrong @select['hanzi']
					else
						@markCorrect @select['hanzi'], false, q+1
						@skipcorrect++

	
	action: (elt, evt, func) -> # Allow undo
		decfunc = (e) =>
			@laststate = Object.clone(@)
			func(e)
		$(elt).off evt
		$(elt).on evt, decfunc
		
	gameElt: ->
		return $("#gamepage")

	saveState: (s=localStorage) ->
		
		#if not s.save? or s.save is ""
		# if not s.laststatec? or s.laststatec is "NaN"
		# 	s.laststatec = 0
		# 	s.laststate = []

		savedata = {ob: @clone(), ui: @gameElt().html()}
		s.save = JSON.stringify savedata
		# s.laststatec = (parseInt s.laststatec) + 1
		# @laststate.push savedata

	savePost: ->
		@gameurl = '/'
		$.post @gameurl, 
		 	{data: JSON.stringify({ob: @clone(), ui: @gameElt().html()})},
		 	() -> null,
		 	'json'

	reloadGet: ->
		@gameurl = '/'
		$.getJSON @gameurl, (data)=>
			@reload data

	reload: (state=null) ->
		if not state?
			state = $.parseJSON localStorage.save
		ob = state['ob']
		for key of ob
			#console.log @[key], ob[key], key, '!='
			@[key] = ob[key]
		@_Tips = copyObject(Tips, @_Tips) 
		
		newstat = new Stats(@)
		Object.update newstat, @stat
		@stat = newstat
		#@gameElt().html(state.ui)
		@drawTab()
		@updateButtons()
		console.log 'hanzi is', @hanzi
		nonempty = (lst) ->
			(i for i in lst when i isnt 'empty')

		@gameloop  @actualstate[0], @actualstate[1], @actualstate[2], nonempty(@hanzi[..])
		#@updateAllSlots()
		for col, row of @select
			@hilight col, row
		
	call: (funcname, args, succf=(-> null), failf=(-> null)) ->
		@gameurl = '/'
		[func, rest] = funcname.split('_')
		
		$.ajax
			type: func.toUpperCase()
			#dataType: "json"
			contentType: "application/json"
			url: @gameursl
			data: JSON.stringify {'function':funcname, 'args': args}
			success: succf
			failure: failf
	testremote: () ->
		#pdb.set_trace()
		#self.post_vote(users.get_current_user().nickname(), 'lol', 1)
		#self.post_vote(users.get_current_user().nickname(), 'lal', -1)
		#write(self.get_stories('lol)'))
		#write(self.get_stories('lal'))

		@.call 'post_story', ['力', 'Die maggots']
		@.call 'post_story', ['B', 'Die magghhots']
		@.call 'post_story', ['C', 'Die maggots']
		@.call 'post_story', ['D', 'Die ggots']
		@.call 'post_vote', ['test@example.com', 'B', 1]
		@.call 'post_vote', ['test@example.com', 'B', -1]
		@.call 'get_stories', ['B'], (res, stat, xhr)->
			console.log res, stat, xhr

	undo: ->
		if @laststatec > 1
			@laststatec--
			@reload @laststate[@laststatec]

	clearRow: (i) ->
		@hanzi[i] = ""
		@pinyin[i] = ""
		@keyword[i] = ""
		@slotmode[i] = ""
		@errormode[i] = ""
		@rowq[i] = -1
		@updateSlot i
		
	markDone: (i) ->
		@ndone++
		@changeSlot i, 'done'
		@done5() if @ndone is @Nnewitems
	clickOn: (col, id) ->
		@guielt(col, id).find('a').trigger 'click'
	matchhand: (f=(->randItem ['correct', 'wrong'])) ->	
		for i in [0..@Nnewitems-1]
			@errormode[i] = f()
		@handleErrors()
	cmatch: ->
		@matchhand -> 'correct'
	markAllCorrect: ->
		for i in [0..@Nnewitems-1]
			@markCorrect(i)
		null
	
errlog = (s) ->
	LOG += s + "\n"
Done5Time = 2
@select = {}
@timers = []
LOG = ""
Globals = 
	mygame: null
	tests: []

all = (lst) ->
	for i in lst
		if not i
			return false
	true

any = (lst) ->
	for i in lst
		if i
			return true
	false

eql = (o, cond, val, op=((a, b) -> a is b)) ->
	#f = new Function(o, "return #{cond};")
	#v = f(o)
	window['g'] = o
	evl = JSON.stringify(eval(cond))
	sup = JSON.stringify val
	
	if sup == evl
		Globals.tests.push [cond, evl, sup, 'SUCCESS']
	else
		Globals.tests.push [cond, evl, sup, 'FAILURE']

neql = (o, cond, val) ->
	eql o, cond, val, ((a, b)->a isnt b)

test1 = ->
	words = ['我', '的', '我的', '你', '你的', '我们', '你们', '喜', '喜爱','爱', '喜欢', '欢']
	hanzi2data =
		'我':['wo3', 'I'] 
		'的':['de','\'s']
		'我的':['wo3de','my']
		'你':['ni3','you']
		'你的':['ni3de','your']
		'我们':['wo3men','we']
		'你们':['ni3men','you all']
		'喜':['xi3','to enjoy']
		'喜爱':['xi3ai4','to like']
		'爱':['ai4','love']
		'喜欢':['xi3huan1','to like']
		'欢':['huan1','happy']

	
	words = words.concat [0..27]
	for i in [0..27]
		hanzi2data[i] = ["p#{i}", "k#{i}"]
	Globals.mygame = new Game(words, hanzi2data, Done5Time=1, @cols=['hanzi', 'pinyin', 'keyword'])
	g = Globals.mygame
	
	#alert(filterlist [0..5], [2..3])
	#g.gameloop 'show', 1, false, false
	stime = Date.now()
	testint = (nowt=false) ->
		#g.nowtime = tomorrow(5) if nowt
		console.log 'nowtime is ', stime - g.nowtime
		#DEBUG = true
		g.switchPage 'start'
		$('#reviewbut').trigger 'click'
		g.done5()
		g.done5()
		matchhand = (f=(->randItem ['correct', 'wrong'])) ->			
			for i in [0..g.Nnewitems-1]
				g.errormode[i] = f()			

			g.handleErrors()
		if nowt
			# TO DO FIX THIS
			# MERGE BOTH TOGETHER
			console.log 'fix this'
		matchhand()
		matchhand()
		
		if g.curstate[0] isnt 'congrat'
			console.log 'hanzi is', g.hanzi
			g.done5()
			g.done5()
			matchhand ->'correct'
			matchhand ->'correct'
		
		console.log g.dueday.toSource()
		#console.log (stime - g.lasttime) / 1000.0

	g.test2 = test2 = (n=5) ->
		g.nowtime = tomorrow(n)
		$('#reviewbut').trigger 'click'
		g.markAllCorrect()
		g.done5()
		#g.done5()
		#g.markAllCorrect()
		#g.markAllCorrect()
		#$('#finishbut').trigger 'click'
		#while true
		#	[state, r, e] = g.actualstate
		#	if g.curstate[0] == 'goal'
		#		break
		#	if state == 'show'
		#		console.log 'doing done 5'
		#		g.done5()
		#	else if state == 'match'
		#		console.log 'all correct'
		#		g.markAllCorrect()

	testint()
	$('#finishbut').trigger 'click'
	test2()

	#g.enterTextMode()
	#g.testremote()
	#g.popupStories('我')
	#$('#reviewbut').trigger 'click'
	#g.done5()
	#g.done5()
	# for i in [0..8]
	# 	$('body').trigger
	# 		type: 'keypress'
	# 		charCode: 50

	inner2 = ->
		g.switchPage 'start'
		$('#reviewbut').trigger 'click'
		#g.gameloop 'show', 1, false, false
		Globals.showclick = =>
			for i in [0..9]
				g.clickOn 'hanzi', i
		Globals.showclick()
		Globals.showclick()

		Globals.eachThing = (i) =>
			eql g, "g.select['hanzi']", i
			try
				[pinyin,keyword] = g.hanzi2data[g.hanzi[i]]
			catch err
				console.log g.hanzi[i]

			pinslot = g.pinyin.indexOf(pinyin)
			rongslot = (pinslot-5+1)%5+5
			useslot = if Math.random() < 0.5 then 'correct' else 'wrong'
			d = 'correct': pinslot, 'wrong': rongslot
			g.clickOn 'pinyin', d[useslot]
			if useslot is 'wrong'
				eql g, "g.errormode[#{i}]", 'wrong'
			else
				kslot = g.keyword.indexOf(keyword)
				g.clickOn 'keyword', kslot
				eql g, "g.errormode[#{i}]", 'correct'

		mything = (i) =>
			g.errormode = randItem ['correct', 'wrong']
		#for match in [0..1]
		oeu.clickit = =>
			for i in [0..g.Nnewitems]
				Globals.eachThing i

		#Globals.clickit()
		#func = -> Globals.clickit()
		#setTimeout func, 5
		#func2 = ->
		#	Globals.showclick()
		#setTimeout func2, 10
		#setTimeout func2, 10

		# for i in [0..9]
		# 	g.clickOn 'hanzi', i
		# alert 'now onto next mode'
		# for i in [0..9]
		# 	g.clickOn 'hanzi', i


	#inner2()

	join = (lst) ->
		s = ''
		for i in lst
			s+=' '+i
		return s

	gg = ->
		g.gamestarttime = Date.now()
		for i in [0..8]
			g.nextloop()
			console.log  i, g.actualstate, join(g.hanzi)

			if g.actualstate[0] is 'match'
				g.errorwords = g.errorwords.concat ([i, g.loopcount] for i in g.hanzi when Math.random() > 0.9)
				console.log 'errorwords', g.errorwords
			else if g.actualstate[0] is 'goal'
				break

			#[state, ro, err] = g.getnextstate state, ro, err
			#console.log '---'
			#if state is 'show' and err
			#	g.error[ro] = words[0..10]
	#gg()


	inner11 = ->
		
		sampqueue = [{'t':0, 'items':[0..10]}]
		items = g.queuepop(5, sampqueue)
		eql items, 'g', ([i, 'match'] for i in [10..6])
		#eql sampqueue, 'g[0].items', [0..5]
		
		g.gameloop()

		g.first4slots = g.slotmode[0..4]
		eql g, 'g.first4slots', ('show' for i in [0..4])

		for i in [0..4]
			g.clickOn 'hanzi', i

		g.first4slots = g.slotmode[0..4]
		eql g, 'g.first4slots', ('' for i in [0..4])

		samp = ['我', '的', '我的', '你', '你的']
		samp.reverse()
		eql g, 'g.showqueue[0].items',  samp
		eql g, 'g.showqueue[0].t', Done5Time
		g.gameloop()
		eql g, 'g.showqueue[0].t', Done5Time-1
		g.gameloop()
		eql g, 'g.showqueue', []
		g.last5 = g.slotmode[5..9]
		eql g, 'g.last5', ('match' for i in [5..9])
		mh = 0
		select = (i) ->			
			eql g, "g.select['hanzi']", i
			try
				[pinyin,keyword] = g.hanzi2data[g.hanzi[i]]
			catch e
				console.log 'trying to get i', i, g.hanzi[i]
			pinslot = g.pinyin.indexOf(pinyin)
			rongslot = (pinslot-5+1)%5+5
			useslot = if Math.random() < 0.5 then 'correct' else 'wrong'
			d = 'correct': pinslot, 'wrong': rongslot
			g.clickOn 'pinyin', d[useslot]
			if useslot is 'wrong'
				eql g, "g.errormode[#{i}]", 'wrong'
			else
				kslot = g.keyword.indexOf(keyword)
				g.clickOn 'keyword', kslot
				eql g, "g.errormode[#{i}]", 'correct'
	
		for i in [5..9]
			select i
	passes = 0
	for [cond, v, sup, result] in Globals.tests
		if result is 'FAILURE'
			console.log "#{cond}=#{v}?=#{sup} #{result}"
		#else
		#	passes += 1

#if DEBUG is false
charts = 
	StudyTime:
		axes:
			xaxis:
				label: 'Day'
			yaxis:
				label: 'Minutes'
	Interval: 
		seriesDefaults:
			renderer:$.jqplot.BarRenderer
			#shadowAngle: 135
			rendererOptions:
				barDirection: 'horizontal'
				rendererOptions: {fillToZero: true}
		pointLabels: {show: true, formatString: '%d'}
		axesDefaults:
			labelRenderer: $.jqplot.CanvasAxisLabelRenderer
		axes:
			xaxis:
				label: 'Interval Day'
			yaxis:
				label: 'Number of Cards'
	TotalDue:
		axes:
			xaxis:
				label: 'Day'
			yaxis:
				label: 'Number of Cards'
	Due:
		axes:
			xaxis:
				label: 'Day'
			yaxis:
				label: 'Number of Cards'
	NewCards:
		axes:
			xaxis:
				label: 'Day'
			yaxis:
				label: 'Number of Cards'
	ReviewCards:
		axes:
			xaxis:
				label: 'Day'
			yaxis:
				label: 'Number of Cards'				
	#Difficulty:''

betw = (start, x, end) ->
	start <= x and x >= end

 chartpoints =
 	StudyTime: (game, stat, start, end) ->
 		([d, v.time] for d, v of stat.days when betw(start, d, end) )
	NewCards: (game, stat, start, end) ->
		([d, v] for d, v of stat.nNew when betw(start, d, end) )
	ReviewCards: (game, stat, start, end) ->
		([d, v] for d, v of stat.nreviewed when betw(start, d, end) )	
	Interval: (game, stat, start, end) ->
		count = {}
		for k, v of game.interval
			if betw(start, d, end)
				addOrSet count, parseInt v[0]
		([d, v.time] for d, v of game.count)
		#stat.nreviewed
		#stats.nnew
	Due: (game, stat, start, end) ->
		count = {}
		for k, v of game.dueday
			if betw(start, d, end)
				addOrSet count, parseInt v[0]
		([d, v.time] for d, v of game.count)
	TotalDue: (game, stat, start, end) ->
		int = chartpoints.Due(game, stat, start, end)
		d = []
		s = 0
		for i in [start..end]
			v = getdefault int, i
			s += v
			d.push [i, s]
		([d, v] for d, v of d)

# chartTitle2zi = 
# 	StudyTime:　'勉強時間'
# 	Interval: '期間'
# 	TotalDue: '期限切れのサム'
# 	Due: '期限切れ'
# 	Difficulty:'難易'
# 	NewCards:'新答え'

tip =
		showround1tip:"""
Here you will be showed a list of words.  Check each list item when you believe 
that you are ready to recall it later.  Also a good idea to remove any items
that will be too difficult or interesting to review so you can focus on learning words that
you want to learn.  When you have checked all of the items you will proceed"""
		matchtip:"""
On this screen we see how well you remembered your items.  Match the corresponding
columns.  Depending on how fast you are determines the review interval.  You can override
the interval by pressing the number keys 1-4."""


class Tips
	constructor: ->
		@_tips = {}
	tip: (msg) ->
		enabled = false
		if not enabled
			return
		if not msg?
			console.log 'msg is '
		stripendlines = (txt) ->
			s = txt.replace(/(\r\n|\n|\r)/gm," ")
			return s.replace(/\s+/g, " ")

		if not @_tips[msg]?
			$('#dialogmsg').text(stripendlines(msg))
			$.mobile.changePage('#popupDialog', 'pop', true, true)
			#.popup('create')
			#$('#popupDialog').popup('open')
			@_tips[msg] = true if $('#checkbox1').is(':checked')


class App
	setupfooter: ->	
		$('div[data-role="page"] div[data-role="footer"]').each ->
			$(@).html $('#startpage footer').html()
			#$(@).append $('#footer')
			console.log $(@).attr('id')
		$('div[data-role="page"]').each ->
			$(@).trigger 'createpage'

	constructor: ->
		@gamepage = null
		@curmode = 'Home'
		words = ['我', '的', '我的', '你', '你的', '我们', '你们', '喜', '喜爱','爱', '喜欢', '欢']
		hanzi2data =
			'我':['wo3', 'I'] 
			'的':['de','\'s']
			'我的':['wo3de','my']
			'你':['ni3','you']
			'你的':['ni3de','your']
			'我们':['wo3men','we']
			'你们':['ni3men','you all']
			'喜':['xi3','to enjoy']
			'喜爱':['xi3ai4','to like']
			'爱':['ai4','love']
			'喜欢':['xi3huan1','to like']
			'欢':['huan1','happy']
		
		words = words.concat [0..27]
		for i in [0..27]
			hanzi2data[i] = ["p#{i}", "k#{i}"]
				
		@game = new Game(words, hanzi2data, Done5Time=1, @cols=['hanzi', 'pinyin', 'keyword'])		
		@game.switchPage 'start'
		#$.mobile.activePage.append $('#footer')
		
		#$('#footer').trigger 'create'
		
		$('#footer a').click (e) =>
			if e.target.classList[0] is 'ui-icon'
				e = $(e.target).parent()
			else
				e = e.target
			@changeNavi(e)
		

		# $('#footer ui-btn').click (e) =>
		# 	console.log 'tap'
			

	changePage: (page) ->
		#$('#'+page).append $('#footer')

		#if page isnt 'startpage'
			#console.log 'ouhantoeh'
			#$('#'+page).find('#foo1').html($('#startpage #footer').html())
		$.mobile.changePage '#'+page

	curPage: ->
		$.mobile.activePage

	changeNavi: (e) ->		
		@navi = $('#navi')
		mode = $(e).text().replace(/\s+/g, '')
		console.log 'mode is ', mode
		#ma = e.attr('id')
		if mode isnt 'Home' and @curmode is 'Home'
			@gamepage = $.mobile.activePage.attr('id')

		if mode is 'Graphs'
			@changePage 'graphpage'
			setupcharts()
		else if mode is 'Browse'
			@changePage 'listpage'
			$('#newbutton').unbind('click').click ->
				$.mobile.changePage '#createlistpage'
		else if mode is 'Home'
			@changePage @gamepage
		else if mode is 'Info'
			alert 'Not implemented'
		@curmode = mode

setupcharts = ->
	if setupcharts.called?
		return
	setupcharts.called = true
	$graphnav = $('#graphnav')
	#$graphnav.html('')
	makechart = (chartid=null)->
		console.log 'make chart call'
		ndays = parseInt $('#days').val()
		chartid = chartid or $('#graphnav .ui-btn-active').text()
		chart = charts[chartid]
		
		$('#chart1').css({'width':$('#footer').width()})
		# chart.seriesDefaults = 
		# 	rendererOptions:
		# 		barDirection: 'horizontal'
		# 	renderer:$.jqplot.BarRenderer			
		chart.axesDefaults = 
			labelRenderer: $.jqplot.CanvasAxisLabelRenderer

		#console.log chart.toSource()
		$('#chart1').empty()

		# points = ([i, Math.random()*20] for i in [0..ndays])
		maxdays = Object.count @game.stat.days
		points = chartponts[chartid](@game, @game.stat, ndays-ncount, maxdays)
		$.jqplot("chart1", [points], chart)
		
	x = 0
	for i, v of charts
		$("#nav#{x}").text i
		x+=1
		#$but = "<li><a id='nav_#{i}' class='graphnavbut' data-transition='fade' data-theme='' data-icon=''>#{i}</a></li>"
		#$graphnav.append $but

	$('#graphpage').trigger 'createpage'
	#$('#nav0').addClass('ui-btn-active')
	#setTimeout (-> makechart('StudyTime'), 30)


	$('#graphnav a').click ->
		makechart()	
	$('#days').change ->
		makechart()
	$('#nav0').trigger 'click'


$(document).on 'init', '[data-role="page"]', ->
 	console.log 'page init', @
 	$(@).find('#foo1').html($('#startpage #footer'))
  	#$('#footer').html


$(document).ready ->
	#$.mobile.fixedToolbars.setTouchToggleEnabled( false )
	#myapp = new App()
	
	test1()
	window['oeu'] = Globals.mygame
	#window.app = myapp
	#oeu.popupStories()

#else
#	test1()
	#while i < @hanzi.length
	#	@mode[@hanzi[i]] = "done"
	#	@ndone++
	#	i++