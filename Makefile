touch=echo >

all: .doctoc-stamp .link-check-stamp

.doctoc-stamp: README.md
	@doctoc --notitle --github README.md
	@$(touch) .doctoc-stamp

.link-check-stamp: README.md
	@markdown-link-check -q README.md --config markdown-link-check-config.json
	@$(touch) .link-check-stamp
