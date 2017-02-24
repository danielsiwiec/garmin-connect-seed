include properties.mk

sources = `find source -name '*.mc'`
resources = `find resources -name '*.xml' | tr '\n' ':' | sed 's/.$$//'`
device_resources = `find resources-$(DEVICE) -name '*.xml' | tr '\n' ':' | sed 's/.$$//'`
appName = `grep entry manifest.xml | sed 's/.*entry="\([^"]*\).*/\1/'`
parameters = ``

build:
	$(SDK_HOME)/bin/monkeyc --warn --output bin/$(appName).prg -m manifest.xml \
	-z $(resources):$(device_resources) -u $(SDK_HOME)/bin/devices.xml \
	-y $(PRIVATE_KEY) \
	-p $(SDK_HOME)/bin/projectInfo.xml -d $(DEVICE) $(sources) $(parameters)

buildall:
	@for device in $(SUPPORTED_DEVICES_LIST); do \
		echo "-----"; \
		echo "Building for" $$device; \
		device_resouces=sudo find resources-$$device -name '*.xml' | tr '\n' ':' | sed 's/.$$//' > /dev/null ; \
    $(SDK_HOME)/bin/monkeyc --warn --output bin/$(appName)-$$device.prg -m manifest.xml \
    -z $(resources):$(device_resources) -u $(SDK_HOME)/bin/devices.xml \
    -y $(PRIVATE_KEY) \
    -p $(SDK_HOME)/bin/projectInfo.xml -d $$device $(sources); \
	done

run: build
	@$(SDK_HOME)/bin/connectiq &&\
	sleep 3 &&\
	$(SDK_HOME)/bin/monkeydo bin/$(appName).prg $(DEVICE)

deploy: build
	@cp bin/$(appName).prg $(DEPLOY)

package:
	@$(SDK_HOME)/bin/monkeyc --warn --output bin/$(appName).iq -m manifest.xml \
	-z $(resources):$(device_resources) -u $(SDK_HOME)/bin/devices.xml \
	-y $(PRIVATE_KEY)
	-p $(SDK_HOME)/bin/projectInfo.xml $(sources) -e -r

