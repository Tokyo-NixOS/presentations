slidy-dark:
	pandoc -s -i -t slidy source.markdown -o index.html --css base.css --css dark.css
slidy-light:
	pandoc -s -i -t slidy source.markdown -o index.html --css base.css --css light.css
view: 
	qutebrowser index.html
start-dark:  slidy-dark view
start-light: slidy-light view
