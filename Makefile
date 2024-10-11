# File: "Makefile"

PRJ = hellofyne

APK = $(PRJ).apk
OS_ANDROID = android/arm64
ANDROID_ID = com.example.$(PRJ)
ICON = Icon.png
APP_VERSION = 1.0
APP_BUILD = 1

GIT_MESSAGE = "auto commit"

# go source files, ignore vendor directory
SRC = $(shell find . -type f -name '*.go' -not -path "./vendor/*")

.PHONY: all apk rebuild help prepare clean distclean \
        fmt simplify vet tidy vendor commit

all: $(PRJ)

apk: $(APK)

rebuild: clean all

help:
	@echo "make prepare-sys - install (apt) system dependencies for build"
	@echo "make prepare     - install (go get) Go dependencies for build"
	@echo "make all         - full build (by default)"
	@echo "make run         - run application"
	@echo "make apk         - build apk for Android"
	@echo "make mobile      - build application in a simulated mobile window"
	@echo "make linux       - build package for Linux"
	@echo "make windows     - build package for Windows"
	@echo "make rebuild     - clean and full rebuild"
	@echo "make clean       - clean"
	@echo "make distclean   - full clean (go.mod, go.sum)"
	@echo "make fmt         - format Go sources"
	@echo "make simplify    - simplify Go sources (go fmt -s)"
	@echo "make vet         - report likely mistakes (go vet)"
	@echo "make go.mod      - generate go.mod"
	@echo "make go.sum      - generate go.sum"
	@echo "make tidy        - automatic update go.sum by tidy"
	@echo "make vendor      - create vendor"
	@echo "make commit      - auto commit by git"
	@echo "make help        - this help"

checkroot:
ifneq ($(shell whoami), root)
	@echo "you must be root; cancel" && false
endif

prepare-sys: checkroot
	@echo ">>> install system dependencies to build"
	@#apt install -y golang

prepare:
	@echo ">>> install Go dependencies to build"
	@go install fyne.io/fyne/v2/cmd/fyne@latest

clean:
	rm -f $(PRJ)
	rm -f $(APK)
	rm -f $(PRJ).tar.xz

distclean: clean
	rm -f go.mod
	rm -f go.sum
	@#sudo rm -rf go/pkg
	rm -rf vendor
	go clean -modcache

fmt: go.mod go.sum
	@#echo ">>> format Go sources"
	@go fmt

simplify:
	@echo ">>> simplify Go sources"
	@gofmt -l -w -s $(SRC)

vet:
	@echo ">>> report likely mistakes (go vet)"
	@#go vet
	@go vet $(PKGS)

go.mod:
	@go mod init $(PRJ)
	@#touch go.mod

tidy: go.mod
	@go mod tidy

go.sum: go.mod Makefile tidy
	@touch go.sum

vendor: go.sum
	@go mod vendor

commit: clean
	git add .
	git commit -am $(GIT_MESSAGE)
	git push

run: *.go go.sum go.mod
	@go run $(LDFLAGS) $(PRJ)

$(PRJ): *.go go.sum go.mod
	@#~/go/bin/fyne build
	@go build $(LDFLAGS) -o $(PRJ) $(PRJ)

mobile: *.go go.sum go.mod
	@go build $(LDFLAGS) -tags mobile -o $(PRJ) $(PRJ)

linux: *.go go.sum go.mod
	~/go/bin/fyne package -os linux --icon $(ICON)

windows: *.go go.sum go.mod
	~/go/bin/fyne package -os windows --icon $(ICON)

$(APK): *.go go.sum go.mod
	~/go/bin/fyne package -os $(OS_ANDROID) \
		-appID $(ANDROID_ID) -icon $(ICON) \
		-appVersion $(APP_VERSION) -appBuild $(APP_BUILD)

# EOF: "Makefile"
