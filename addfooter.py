# generate the footer fgor ecah of the stupid shits...
VERSION = 0
from BeautifulSoup import BeautifulSoup

def run():
	try:
		soup = BeautifulSoup(file('dummy.html'))

		navbar = ['home', 'browse', 'graphs', 'info']
		dataicon = ['home', 'search', 'grid', 'info']
		part2icon = dict(zip(navbar, dataicon))

		page2part = {
			'start':'home',
			'goal':'home',
			'game':'home',
			'browse':'browse',
			'info':'info',
			'graph':'graphs'
		}

		footer = """
			<div data-id="foo1" id="footer" data-theme="a" data-role="footer" data-position="fixed">
				<div id="navi" data-role="navbar" data-iconpos="top">
					<ul>
						<li>
							<a data-transition="fade" data-theme="" data-icon="home">
								Home
							</a>
						</li>
						<li>
							<a data-transition="fade" data-theme="" data-icon="search">
								Browse
							</a>
						</li>
						<li>
							<a data-transition="fade" data-theme="" data-icon="grid">
								Graphs
							</a>
						</li>
						<li>
							<a data-transition="fade" data-theme="" data-icon="info">
								Info
							</a>
						</li>
					</ul>
				</div>
			</div>	
		"""

		print page2part, part2icon
		
		for page in soup.findAll(attrs={'data-role':'page'}):
			try:
				import re
				foot = BeautifulSoup(footer)
				id = page.attrMap['id']
				part = page2part[re.sub('page', '', id)]
				icon = part2icon[part]
				li = foot.find(attrs={'data-icon':icon})
				print 'wtf', id, part, icon
				li['class'] = 'ui-btn-active' # ui-state-persist'
				
				page.append(foot)
			except KeyError, e:
				print e
		file('output.html', 'w').write(soup.prettify())
	except:		
		#import pdb; pdb.set_trace()
		raise
run()