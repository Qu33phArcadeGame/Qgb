# Qu33ph for the Game Boy / Game Boy Color — builds qu33ph.gbc with GBDK-2020
# (the GitHub Action downloads GBDK and runs this)
GBDK_HOME ?= gbdk/
LCC := $(GBDK_HOME)bin/lcc
# MBC5 + RAM + battery, 8 KB of save memory, works on the Game Boy and the Game Boy Color,
# code and pictures spread over the banks automatically
LCCFLAGS := -Wl-yt0x1B -Wm-ya1 -Wm-yc -Wm-yn"QU33PH" -autobank -Wb-ext=.rel -Wl-j
CFLAGS := -Isrc
SRC := $(wildcard src/*.c)
OBJ := $(patsubst src/%.c,build/%.o,$(SRC))

qu33ph.gbc: $(OBJ)
	$(LCC) $(LCCFLAGS) -o $@ $(OBJ)
	@ls -la $@

build/%.o: src/%.c src/qu.h
	@mkdir -p build
	$(LCC) $(CFLAGS) $(LCCFLAGS) -c -o $@ $<

assets:
	python3 tools/make_gb_assets.py
	python3 tools/make_music.py

clean:
	rm -rf build qu33ph.gbc qu33ph.map qu33ph.noi qu33ph.sym
.PHONY: clean assets
