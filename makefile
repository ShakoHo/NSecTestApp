# lazy helper

install: regenerate-test-certs create-acct-js create-acct-js-2 create-web-package 
	rsync -ave ssh testweb/ $(PEOPLE_ACCT)@people.mozilla.org:public_html/nsec

update: create-web-package
	rsync -ave ssh testweb/ $(PEOPLE_ACCT)@people.mozilla.org:public_html/nsec

regenerate-test-certs:
	cd fxos-package-signing-tool; ./create_test_files.sh --regenerate-test-certs

create-acct-js: 
	echo "window.addEventListener(\"load\", function() {" >> ./acct.js
	echo "document.getElementById('iframe1').src=\"http://people.mozilla.org/~$(PEOPLE_ACCT)/nsec/client-cookie-web-3/index.html\";" >> ./acct.js
	echo "});" >> ./acct.js
	cp ./acct.js testweb/client-cookie-web-1/
	cp ./acct.js testapp/client-cookie-app-1/
	cp ./acct.js testapp/client-cookie-app-2/
	mv ./acct.js testweb/client-cookie-web-2/

create-acct-js-2: 
	echo "window.addEventListener(\"load\", function() {" >> ./acct.js
	echo "document.getElementById('iframe1').src=\"http://people.mozilla.org/~$(PEOPLE_ACCT)/nsec/offline-app-web-3/index.html\";" >> ./acct.js
	echo "});" >> ./acct.js
	mv ./acct.js testweb/offline-app-web-2/

create-web-package:
	cd fxos-package-signing-tool; python make_web_package.py ../testweb/client-cookie-web-1/ c1.pak; mv c1.pak ../testweb/client-cookie-web-1
	cd fxos-package-signing-tool; python make_web_package.py ../testweb/client-cookie-web-2/ c2.pak; mv c2.pak ../testweb/client-cookie-web-2
	cd fxos-package-signing-tool; python make_web_package.py ../testweb/indexed-db-web-1/ i1.pak; mv i1.pak ../testweb/indexed-db-web-1
	cd fxos-package-signing-tool; python make_web_package.py ../testweb/indexed-db-web-2/ i2.pak; mv i2.pak ../testweb/indexed-db-web-2
	cd fxos-package-signing-tool; python make_web_package.py ../testweb/offline-app-web-1/ o1.pak; mv o1.pak ../testweb/offline-app-web-1
	cd fxos-package-signing-tool; python make_web_package.py ../testweb/offline-app-web-2/ o2.pak; mv o2.pak ../testweb/offline-app-web-2
	cd fxos-package-signing-tool; python make_web_package.py ../testweb/offline-app-web-3/ o3.pak; cp o3.pak ../testweb/offline-app-web-3; mv o3.pak ../testweb/offline-app-web-3/o4.pak

help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

testweb/client-cookie-web-1: ## include index.html pages implement the client cookie api, and c1.pak pack with this static html
testweb/client-cookie-web-2: ## include index.html pages implement the client cookie api, and c2.pak pack with this static html
testweb/client-cookie-web-3: ## include two static html pages (index.html, index2.html) implement the client cookie api, and two packs (test.pak, test2.pak) with this static html
testweb/indexed-db-web-1: ## include a index.html pages implement the indexed db api, and i1.pak pack with this static html
testweb/indexed-db-web-2: ## include a index.html pages implement the indexed db api, and i2.pak pack with this static html
testweb/local-storage-web-1: ## include a index.html pages implement the local storage api, and web-storage-demo.pak pack with this static html
testweb/local-storage-web-2: ## include a index.html pages implement the local storage api, and web-storage-demo.pak pack with this static html
testweb/offline-app-web-1: ## include a index.html pages implement the offline app api, and o1.pak pack with this static html
testweb/offline-app-web-2: ## include a index.html pages implement the offline app api, and o2.pak pack link to offline-app-web-3/index.html
testweb/offline-app-web-3: ## include a index.html pages implement the offline app api, and two packs(o3.pak and o4.pak) with this static html
testapp/client-cookie-app-1: ## a packaged app implement with a iframe to a share page (client-cookie-web-3/index.html)
testapp/client-cookie-app-2: ## a packaged app implement with a iframe to a share page (client-cookie-web-3/index.html)

