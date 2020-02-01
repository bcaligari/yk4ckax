PANDOC=pandoc

pdf: yaml.pdf kubectl.pdf

html: yaml.html kubectl.html

yaml.pdf: yaml.md
	$(PANDOC) yaml.md --from Markdown --to pdf -t latex -o yaml.pdf

kubectl.pdf: kubectl.md
	$(PANDOC) kubectl.md --from Markdown --to pdf -t latex -o kubectl.pdf

yaml.html: yaml.md
	$(PANDOC) yaml.md --from Markdown --to html -t html5 -o yaml.html

kubectl.html: kubectl.md
	$(PANDOC) kubectl.md --from Markdown --to html -t html5 -o kubectl.html

clean:
	rm -f yaml.pdf yaml.html kubectl.pdf kubectl.html
