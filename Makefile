.PHONY: install uninstall test clean

install:
	./install.sh

uninstall:
	./install.sh uninstall

test:
	./gac --version
	./gac --help
	@echo "Basic tests passed."

clean:
	@echo "Nothing to clean."
