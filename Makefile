.PHONY: install uninstall test clean lint format help

# Default target
all: install

# Install gac
install:
	@echo "🚀 Installing GAC..."
	./install.sh

# Uninstall gac
uninstall:
	@echo "🗑️  Uninstalling GAC..."
	./install.sh uninstall

# Run basic tests
test:
	@echo "🧪 Running basic tests..."
	./gac --version
	./gac --help
	@echo "✅ Basic tests passed!"

# Test configuration
test-config:
	@echo "⚙️  Testing configuration..."
	./gac --config

# Check for common issues
lint:
	@echo "🔍 Linting scripts..."
	bash -n gac || (echo "❌ gac script has syntax errors" && exit 1)
	bash -n install.sh || (echo "❌ install.sh has syntax errors" && exit 1)
	@echo "✅ All scripts passed syntax check"

# Format documentation (basic check)
format:
	@echo "📝 Formatting documentation..."
	@for file in README.md USAGE_GUIDE.md QUICKSTART.md; do \
		if [ -f "$$file" ]; then \
			echo "✅ $$file exists and has $$(wc -l < $$file) lines"; \
		fi; \
	done

# Clean temporary files
clean:
	@echo "🧹 Cleaning temporary files..."
	@rm -f /tmp/gac_debug_*.json
	@rm -f test_api.sh test_ai.sh 2>/dev/null || true
	@echo "✅ Cleaned"

# Full development setup
dev-setup:
	@echo "🛠️  Setting up development environment..."
	@which jq > /dev/null || (echo "❌ jq is required" && exit 1)
	@which curl > /dev/null || (echo "❌ curl is required" && exit 1)
	@which git > /dev/null || (echo "❌ git is required" && exit 1)
	@echo "✅ All dependencies available"

# Generate documentation statistics
docs-stats:
	@echo "📊 Documentation statistics:"
	@for file in README.md USAGE_GUIDE.md QUICKSTART.md CONTRIBUTING.md CHANGELOG.md; do \
		if [ -f "$$file" ]; then \
			lines=$$(wc -l < "$$file"); \
			chars=$$(wc -m < "$$file"); \
			echo "  $$file: $${lines} lines, $${chars} bytes"; \
		fi; \
	done

# Show help
help:
	@echo "GAC (Git AI Commit) - Makefile"
	@echo ""
	@echo "Usage:"
	@echo "  make install      - Install GAC to ~/bin"
	@echo "  make uninstall    - Uninstall GAC"
	@echo "  make test         - Run basic functionality tests"
	@echo "  make test-config  - Test configuration loading"
	@echo "  make lint         - Check script syntax"
	@echo "  make format       - Check documentation"
	@echo "  make clean        - Clean temporary files"
	@echo "  make dev-setup    - Verify development dependencies"
	@echo "  make docs-stats   - Show documentation statistics"
	@echo "  make help         - Show this help"
	@echo ""
	@echo "Quick start:"
	@echo "  1. make install"
	@echo "  2. Edit ~/.config/gac.conf"
	@echo "  3. Use 'gac' in any git repository"
