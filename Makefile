include properties.mk

sources = `find source -name '*.mc'`
resources = `find resources -name '*.xml' | tr '\n' ':' | sed 's/.$$//'`
appName = `grep entry manifest.xml | sed 's/.*entry="\([^"]*\).*/\1/'`

build:
	$(SDK_HOME)/bin/monkeyc --warn --output bin/$(appName).prg -m manifest.xml \
	-z $(resources) -u $(SDK_HOME)/bin/devices.xml \
	-p $(SDK_HOME)/bin/projectInfo.xml -d $(DEVICE) $(sources)

run: build
	$(SDK_HOME)/bin/connectIQ &&\
	sleep 3 &&\
	$(SDK_HOME)/bin/monkeydo bin/$(appName).prg $(DEVICE)

deploy: build
	cp bin/$(appName).prg $(DEPLOY)

package:
	$(SDK_HOME)/bin/monkeyc --warn --output bin/$(appName).iq -m manifest.xml \
	-z $(resources) -u $(SDK_HOME)/bin/devices.xml \
	-p $(SDK_HOME)/bin/projectInfo.xml $(sources) -e -r
