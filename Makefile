ASCIIDOCTOR=ruby -rasciidoctor-html5ruby bin/asciidoctor4novels -a stylesheet=css/novel.css -a docinfo1 -a revision=`git rev-parse master`

scss/_main.scss: pasberth.github.io/scss/main.scss
	cp $^ $@

css/novel.css: scss/novel.scss scss/_main.scss
	mkdir -p css
	sass --unix-newlines \
		--scss \
		-I`ruby -rcompass -e 'puts Compass.base_directory'`/frameworks/compass/stylesheets/ \
		scss/novel.scss \
		css/novel.css

gh-pages: \
	$(addsuffix .html, $(subst src, gh-pages, $(basename $(shell find src -name index.adoc)))) \
	gh-pages/.nojekyll

gh-pages/%/index.html: src/%/index.adoc css/novel.css src/%/docinfo.html src/%/docinfo-footer.html
	mkdir -p `dirname $@`
	$(ASCIIDOCTOR) $(patsubst gh-pages/%/index.html, src/%/index.adoc, $@) -o $@

src/%/docinfo.html: pasberth.github.io/docinfo/docinfo.html
	cp $^ $@

src/%/docinfo-footer.html: pasberth.github.io/docinfo/docinfo-footer.html
	cp $^ $@

gh-pages/.nojekyll:
	touch gh-pages/.nojekyll
