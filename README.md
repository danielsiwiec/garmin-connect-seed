# Garmin Connect IQ seed
This is a seed project for writing [Garmin Connect IQ](http://developer.garmin.com/connect-iq/) applications. Instead of using the Eclipse plugin (which works rather poorly...),
you can use any text editor of your choice and **compile**, **run** or **package** your project using *make*.

**NOTICE:** This seed works will all Java versions **below** Java 12. The reason for this is, Java 12 stopped shipping with a JAR neccessary for the Garmin SDK. This applies to the Eclipse plugin, as well and will need to eventually be addressed by Garmin.

## Setup
All you'll need to get started is edit the ```properties.mk``` file. Here's a description of the variables:

- **DEVICE** - device type you want to use for simulation (e.g. fenix3, vivoactive, epix...)
- **SDK_HOME** - home folder of your SDK (e.g. /Users/me/connectiq-sdk-mac-3.0.4)
- **PRIVATE_KEY** - path to your generated RSA private key for signing apps (needed since CIQ 1.3) (e.g. /home/.ssh/key/id_rsa_garmin.der)
- **DEPLOY** - if you want to hot-deploy to your device, that's the mounted path for the APPS folder (e.g. /Volumes/GARMIN/GARMIN/APPS/)

## Targets
- **build** - compiles the app
- **buildall** - compiles the app separately for every device in the SUPPORTED_DEVICES_LIST, packaging appropriate resources. Make sure to have your resource folders named correctly (e.g. /resources-fenix3_hr)
- **run** - compiles and starts the simulator
- **deploy** - if your device is connected via USB, compile and deploy the app to the device
- **package** - create an .iq file for app store submission

## How to use?
To execute the **run** target, run ```make run``` from the home folder of your app
