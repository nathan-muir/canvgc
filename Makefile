PATH := ./node_modules/.bin:${PATH}

.PHONY : init clean build dist test publish

init:
	npm install

clean:
	rm -rf lib/

build:
	coffee -o lib/ -c src/ && mkdir -p lib/canvg && cp -r src/canvg/*.js lib/canvg

test:
	mocha test/*.coffee -r coffee-script --reporter spec

dist: clean init build

publish: dist
	npm publish