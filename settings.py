import os

SANDBOX='Development' in os.environ['SERVER_SOFTWARE']

sandboxInfo = (139786509611316, 'https://sandbox.google.com/checkout', 'urUZ-4RVdtlVBW58c7VClQ')
realInfo = (1, 'https://checkout.google.com')

if SANDBOX:
	merchantId, checkUrl, key = sandboxInfo
else:
	merchantId, checkUrl, key = realInfo

