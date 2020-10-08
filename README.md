# Truecrypt from sources
Compile TrueCrypt from sources in Docker container

## TODO

- [ ] Use multi-stage build to copy the compiled binary to a lean container
- [ ] Remove wxWidgets external dependency (omit curl call), include tar.gz in this repo
- [ ] Use git patches instead of ugly in-place sed replacements
- [ ] Find required shared libraries to be copied to the lean container
- [ ] Fix possibly wxwidgets related "Error: Invalid characters encountered."

## Fix wxwidgets proposal

```
  export PKG_CONFIG_PATH=/usr/lib/pkgconfig
  export VERBOSE=1
  export WX_BUILD_DIR="$PWD/wxBuildGui"
  export WX_ROOT="$PWD/$_wxname-$_wxversion"
  tar -xvzf "$srcdir/$_wxname-$_wxversion.tar.gz" -C "$PWD"
  make WXSTATIC=1 wxbuild
  make WXSTATIC=1 clean
  make WXSTATIC=1

??? could also use wxwidgets 3.0.2 ???
```

## Shared libraries the built binary depends on

The output of ```readelf -d /tmp/TrueCrypt/Main/truecrypt```

```
Dynamic section at offset 0x210598 contains 28 entries:
  Tag        Type                         Name/Value
 0x0000000000000001 (NEEDED)             Shared library: [libfuse.so.2]
 0x0000000000000001 (NEEDED)             Shared library: [libstdc++.so.6]
 0x0000000000000001 (NEEDED)             Shared library: [libgcc_s.so.1]
 0x0000000000000001 (NEEDED)             Shared library: [libc.musl-x86_64.so.1]
 0x000000000000000c (INIT)               0x20000
 0x000000000000000d (FINI)               0x15e655
 0x0000000000000019 (INIT_ARRAY)         0x208148
 0x000000000000001b (INIT_ARRAYSZ)       440 (bytes)
 0x0000000000000004 (HASH)               0x290
 0x0000000000000005 (STRTAB)             0x27d8
 0x0000000000000006 (SYMTAB)             0xb70
 0x000000000000000a (STRSZ)              8638 (bytes)
 0x000000000000000b (SYMENT)             24 (bytes)
 0x0000000000000015 (DEBUG)              0x0
 0x0000000000000003 (PLTGOT)             0x211798
 0x0000000000000002 (PLTRELSZ)           6168 (bytes)
 0x0000000000000014 (PLTREL)             RELA
 0x0000000000000017 (JMPREL)             0x1dfc8
 0x0000000000000007 (RELA)               0x4c48
 0x0000000000000008 (RELASZ)             103296 (bytes)
 0x0000000000000009 (RELAENT)            24 (bytes)
 0x0000000000000018 (BIND_NOW)           
 0x000000006ffffffb (FLAGS_1)            Flags: NOW PIE
 0x000000006ffffffe (VERNEED)            0x4bf8
 0x000000006fffffff (VERNEEDNUM)         2
 0x000000006ffffff0 (VERSYM)             0x4996
 0x000000006ffffff9 (RELACOUNT)          3875
 0x0000000000000000 (NULL)               0x0
 ```
