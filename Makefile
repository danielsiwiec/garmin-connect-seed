include properties.mk

sources = `find source -name '*.mc'`
resources = `find resources* -name '*.xml' | tr '\n' ':' | sed 's/.$$//'`
appName = `grep entry manifest.xml | sed 's/.*entry="\([^"]*\).*/\1/'`

build:
	$(SDK_HOME)/bin/monkeyc --warn --output bin/$(appName).prg -m manifest.xml \
	-z $(resources) \
	-y $(PRIVATE_KEY) \
	-d $(DEVICE) $(sources)

buildall:
	@for device in $(SUPPORTED_DEVICES_LIST); do \
		echo "-----"; \
		echo "Building for" $$device; \
    $(SDK_HOME)/bin/monkeyc --warn --output bin/$(appName)-$$device.prg -m manifest.xml \
    -z $(resources) \
    -y $(PRIVATE_KEY) \
    -d $$device $(sources); \
	done

run: build
	@$(SDK_HOME)/bin/connectiq &&\
	sleep 3 &&\
	$(SDK_HOME)/bin/monkeydo bin/$(appName).prg $(DEVICE)

deploy: build
	@cp bin/$(appName).prg $(DEPLOY)

package:
	@$(SDK_HOME)/bin/monkeyc --warn -e --output bin/$(appName).iq -m manifest.xml \
	-z $(resources) \
	-y $(PRIVATE_KEY) \
	$(sources) -r
