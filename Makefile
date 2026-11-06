APP_NAME := Quick Eject.app
APP_DIR := $(APP_NAME)/Contents

.PHONY: build clean

build:
	mkdir -p "$(APP_DIR)/MacOS"
	cp Info.plist "$(APP_DIR)/Info.plist"
	swiftc -O -framework AppKit QuickEject.swift -o "$(APP_DIR)/MacOS/QuickEject"

clean:
	rm -rf "$(APP_NAME)"
