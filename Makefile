TARGET := iphone:clang:latest:15.0
ARCHS := arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SpotweakInteractive
SpotweakInteractive_FILES = Tweak.x
SpotweakInteractive_CFLAGS = -fobjc-arc
SpotweakInteractive_FRAMEWORKS = UIKit AVFoundation MediaPlayer

include $(THEOS)/makefiles/tweak.mk
