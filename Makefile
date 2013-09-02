PATH := ./node_modules/.bin:${PATH}

.PHONY : init clean build dist publish

init:
	npm install

clean:
	rm -rf lib/

build:
	coffee -o lib/ -c src/ && mkdir -p lib/canvg && cp -r src/canvg/*.js lib/canvg


dist: clean init build

publish: dist
	npm publish