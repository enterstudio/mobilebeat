CC=/usr/local/arm-apple-darwin/bin/gcc
CXX=/usr/local/arm-apple-darwin/bin/g++
CFLAGS=-fsigned-char
LDFLAGS=-Wl,-syslibroot,/usr/local/arm-apple-darwin/heavenly -lobjc -ObjC -framework CoreFoundation -framework Foundation -framework UIKit -framework LayerKit -framework CoreGraphics -framework GraphicsServices -framework Celestial -framework MusicLibrary

APPNAME=MobileBeat

SOURCES=\
	main.m \
	MBHeartbeat.m \
	MBGridView.m \
	MBApplication.m \
	CTGradient.m
	
LDFLAGS=-Wl,-syslibroot,/usr/local/arm-apple-darwin/heavenly -lobjc -ObjC \
	-framework CoreFoundation \
	-framework Foundation \
	-framework UIKit \
	-framework LayerKit \
	\
	-framework AddressBook \
	-framework AddressBookUI \
	-framework AppSupport \
	-framework AudioToolbox \
	-framework BluetoothManager \
	-framework Calendar \
	-framework Camera \
	-framework Celestial \
	-framework CoreAudio \
	-framework CoreGraphics \
	-framework CoreSurface \
	-framework CoreTelephony \
	-framework CoreVideo \
	-framework DeviceLink \
	-framework GMM \
	-framework GraphicsServices \
	-framework IAP \
	-framework IOKit \
	-framework IOMobileFramebuffer \
	-framework ITSync \
	-framework JavaScriptCore \
	-framework MBX2D \
	-framework MBXConnect \
	-framework MeCCA \
	-framework Message \
	-framework MessageUI \
	-framework MobileBluetooth \
	-framework MobileMusicPlayer \
	-framework MoviePlayerUI \
	-framework MultitouchSupport \
	-framework MusicLibrary \
	-framework OfficeImport \
	-framework OpenGLES \
	-framework PhotoLibrary \
	-framework Preferences \
	-framework Security \
	-framework System \
	-framework SystemConfiguration \
	-framework TelephonyUI \
	-framework URLify \
	-framework WebCore \
	-framework WebKit \

WRAPPER_NAME=$(APPNAME).app
EXECUTABLE_NAME=$(APPNAME)
SOURCES_ABS=$(addprefix $(SRCROOT)/,$(SOURCES))
INFOPLIST_ABS=$(addprefix $(SRCROOT)/,$(INFOPLIST_FILE))
OBJECTS=\
	$(patsubst %.c,%.o,$(filter %.c,$(SOURCES))) \
	$(patsubst %.cc,%.o,$(filter %.cc,$(SOURCES))) \
	$(patsubst %.cpp,%.o,$(filter %.cpp,$(SOURCES))) \
	$(patsubst %.m,%.o,$(filter %.m,$(SOURCES))) \
	$(patsubst %.mm,%.o,$(filter %.mm,$(SOURCES)))
OBJECTS_ABS=$(addprefix $(CONFIGURATION_TEMP_DIR)/,$(OBJECTS))
APP_ABS=$(BUILT_PRODUCTS_DIR)/$(WRAPPER_NAME)
PRODUCT_ABS=$(APP_ABS)/$(EXECUTABLE_NAME)

LD=$(CC)

all:	$(APPNAME)

$(APPNAME):	$(OBJECTS)
	#$(LD) $(LDFLAGS) -o $(PRODUCT_ABS) $(OBJECTS_ABS)
	$(LD) $(LDFLAGS) -o $@ $^

package: $(APPNAME)
	rm -fr $(APPNAME).app
	mkdir -p $(APPNAME).app
	cp $(APPNAME) $(APPNAME).app/$(APPNAME)
	#cp *.png $(APPNAME).app/
	cp Info.plist $(APPNAME).app/Info.plist

send: package
	scp -rp $(APPNAME).app root@10.0.2.7:/Applications
	
%.o:	%.m
		$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

clean:
		rm -f *.o $(APPNAME)
		rm -fr $(APPNAME).app

