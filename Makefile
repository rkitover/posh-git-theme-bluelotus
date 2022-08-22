touch=echo >
rm=python -c "from sys import argv; import os; os.remove(argv[1])"
rmtree=python -c "from sys import argv; import shutil; shutil.rmtree(argv[1])"

all: .doctoc-stamp .link-check-stamp

.doctoc-stamp: README.md
	@doctoc --notitle --github README.md
	@$(touch) .doctoc-stamp

.link-check-stamp: README.md
	@markdown-link-check -q README.md --config markdown-link-check-config.json
	@$(touch) .link-check-stamp

clean:
	@$(rm) .doctoc-stamp
	@$(rm) .link-check-stamp
	@$(rmtree) posh-git-theme-bluelotus

publish:
	pwsh publish.ps1 -apikeyfile ~/Documents/powershell-gallery-api-key.txt -cert ~/.codesign/windows_comodo.pkcs12
