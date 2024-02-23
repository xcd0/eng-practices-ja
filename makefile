
builddir := eng-practices

all:
	cat makefile

clean:
	rm -rf book

build:
	mdbook build -d "$(builddir)"
	MDBOOK_BOOK__LANGUAGE=ja mdbook build -d "$(builddir)/ja"
	# なぜか1箇所リンクがおかしくなる。
	find . -name *.html | xargs sed -i 's;href="ja/;href=";'

serve:
	mdbook serve -d "$(builddir)"
	MDBOOK_BOOK__LANGUAGE=ja mdbook serve -d "$(builddir)/ja"

install-nkf:
	sudo apt update
	sudo apt install -y nkf

install-mdbook:
	cargo binstall -y mdbook
	cargo binstall -y mdbook-i18n
	cargo binstall -y mdbook-i18n-helpers

create-po-template:
	MDBOOK_OUTPUT='{"xgettext": {"pot-file": "messages.pot"}}' mdbook build -d po
	# po/messages.pot が生成される

gettext-init-ja:
	msginit -i po/messages.pot -l ja -o po/ja.po

gettext-update-ja:
	msgmerge --update po/ja.po po/messages.pot
