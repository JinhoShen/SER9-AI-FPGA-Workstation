.PHONY: docs clean status

docs:
	npm run docs

clean:
	rm -rf output/svg/* output/png/* output/pdf/*

status:
	git status
