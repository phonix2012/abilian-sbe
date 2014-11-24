.PHONY: test full-test pep8 clean setup default


SRC=abilian/sbe
PKG=$(SRC)

INSTANCE_FOLDER=$(shell 												\
	$(VIRTUAL_ENV)/bin/python											\
	 -c 'from flask import Flask; print Flask("myapp").instance_path')

default: test

#
# testing
#
instance:
ifndef VIRTUAL_ENV
	@echo "********************************************************************"
	@echo "Error: not running in virtualenv."
	@echo "Please activate virtualenv. (\"source /path/to/env_dir/bin/activate\")"
	@echo "********************************************************************"
	@exit 1;
endif
	pip install -r etc/deps.txt
	pip install -e .
	@mkdir -pv "$(INSTANCE_FOLDER)"
	@cp -v "etc/config_dev.py" "$(INSTANCE_FOLDER)/config.py"
	@cp -v "etc/logging-dev.yml" "$(INSTANCE_FOLDER)/logging.yml"
	@sed -i -e 's#INSTANCE_FOLDER#$(INSTANCE_FOLDER)#' "$(INSTANCE_FOLDER)/config.py"
	@echo "********************************************************************************"
	@echo "Setup complete!"
	@echo "config is here: $(INSTANCE_FOLDER)/config.py"
	@echo "You may edit it before first run, in particular SQLALCHEMY_DATABASE_URI"
	@echo "Default database is sqlite file based: $(INSTANCE_FOLDER)/data.db"
	@echo
	@echo "you may now run:"
	@echo "python manage.py initdb"
	@echo "python manage.py run"
	@echo "********************************************************************************"


#
# testing
#
test:
	py.test --tb=short $(SRC) 

test-with-coverage:
	py.test --tb=short --durations 10 --cov $(PKG) --cov-config etc/coverage.rc \
	  --cov-report term-missing $(SRC)

test-long:
	RUN_SLOW_TESTS=True py.test -x $(SRC)

abilian_update:
	pip install --upgrade --no-deps -e "git+https://github.com/abilian/abilian-core.git@master#egg=Abilian-Core"

#
# Everything else
#
run:
	python manage.py runserver

boot:
	./manage.py config init
	./manage.py initdb
	./manage.py createadmin admin@example.com admin

tox:
	tox -e py27

pep8:
	pep8 -r --ignore E111,E225,E501,E121 *.py abilian tests

clean:
	find . -name "*.pyc" | xargs rm -f
	find . -name .DS_Store | xargs rm -f
	find . -name __pycache__ | xargs rm -rf
	rm -rf instance/data instance/cache instance/tmp instance/webassets instance/whoosh
	rm -f migration.log
	rm -rf build dist
	rm -rf data tests/data tests/integration/data
	rm -rf tmp tests/tmp tests/integration/tmp
	rm -rf cache tests/cache tests/integration/cache
	rm -rf *.egg-info *.egg .coverage
	rm -rf whoosh tests/whoosh tests/integration/whoosh
	rm -rf doc/_build
	rm -rf static/gen static/.webassets-cache
	rm -rf htmlcov
	rm -rf junit-py27.xml ghostdriver.log

tidy: clean
	rm -rf .tox

vagrant-test:
	vagrant up
	vagrant ssh -c 'cp -a /vagrant src && cd src && tox'

update-pot:
	python setup.py extract_messages update_catalog compile_catalog
