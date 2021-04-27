.DEFAULT_GOAL := update-test

.PHONY: install
install:
	python -m pip install -U setuptools pip
	pip install -r requirements-dev.txt
	pre-commit install

.PHONY: update
update:
	@echo "-------------------------"
	@echo "- Updating dependencies -"
	@echo "-------------------------"

	pip install pip-tools
	rm requirements.txt
	touch requirements.txt
	pip-compile -Ur requirements.txt --allow-unsafe

	pip install -r requirements.txt

	@echo ""

.PHONY: update-test
update-test: update
	@echo "------------------------------"
	@echo "- Updating test dependencies -"
	@echo "------------------------------"

	pip install pip-tools
	rm requirements-dev.txt
	touch requirements-dev.txt
	pip-compile -Ur requirements-dev.in --allow-unsafe

	pip install -r requirements-dev.txt

	@echo ""

.PHONY: clean
clean:
	@echo "---------------------------"
	@echo "- Cleaning unwanted files -"
	@echo "---------------------------"

	rm -rf `find . -name __pycache__`
	rm -f `find . -type f -name '*.py[co]' `
	rm -f `find . -type f -name '*.rej' `
	rm -f `find . -type f -name '*~' `
	rm -f `find . -type f -name '.*~' `
	rm -rf .cache
	rm -rf .pytest_cache
	rm -rf .mypy_cache
	rm -rf htmlcov
	rm -rf *.egg-info
	rm -f .coverage
	rm -f .coverage.*
	rm -rf build
	rm -rf dist
	rm -f src/*.c pydantic/*.so
	rm -rf site
	rm -rf docs/_build
	rm -rf docs/.changelog.md docs/.version.md docs/.tmp_schema_mappings.html
	rm -rf codecov.sh
	rm -rf coverage.xml

	@echo ""

.PHONY: bump
bump: pull-master bump-version clean

.PHONY: pull-master
pull-master:
	@echo "------------------------"
	@echo "- Updating repository  -"
	@echo "------------------------"

	git checkout master
	git pull

	@echo ""

.PHONY: bump-version
bump-version:
	@echo "---------------------------"
	@echo "- Bumping program version -"
	@echo "---------------------------"

	cz bump --changelog --no-verify
	git push
	git push --tags

	@echo ""

.PHONY: test
test:
	@echo "-----------------"
	@echo "- Running tests -"
	@echo "-----------------"

	molecule test

	@echo ""
