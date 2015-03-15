## Description ##
MobileBeat takes the multi-touch features of Apple's iPhone and utilizes them to create a mobile music creation environment. MobileBeat uses a similar concept to the monome 40h (http://www.youtube.com/watch?v=cJwxbTKwONc) for creating beats using various samples in real time.

### Planned Features for .1 ###
  * Switching out of sample presets.
  * Dynamic adjustment of BPM.

### Features beyond .1 ###
  * Different "windows"
    * A grid beat view (as seen in the screenshot below).
    * A grid view for playing long samples.
    * A piano keyboard for tapping out melody
  * Recording sessions to a file for later playback.
  * Recording to a ringtone.

## Screenshots ##

![http://mobilebeat.googlecode.com/svn/trunk/screenshots/1.png](http://mobilebeat.googlecode.com/svn/trunk/screenshots/1.png)

## Installation Instructions ##
The project uses glib, libsnd, and libintl. In order for the binary to work, it must find those libraries in /usr/lib/.

Check out the code via Subversion and copy the three libraries (libglib-2.0.0.1200.13.dylib, libsndfile.1.0.17.dylib, and libintl.8.0.1.dylib) in ext/libs in the trunk to /usr/lib on the iPhone.

Next, change the IP in the Makefile to your iPhone's IP and run "make send". This should build all the necessary files, construct a package, and scp the package to your iPhone's Applications directory. Then, just restart Springboard and you should be able to run it.