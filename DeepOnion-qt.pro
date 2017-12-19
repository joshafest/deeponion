# New version, additions & code updates by Mammix2

TEMPLATE = app
TARGET = DeepOnion-qt
VERSION = 1.0.0.0
INCLUDEPATH += src src/json \
    src/qt \
    src/qt/plugins/mrichtexteditor \
    src/xxhash \
    src/tor \
    src/lz4
QT += core gui network
DEFINES += QT_GUI BOOST_THREAD_USE_LIB BOOST_SPIRIT_THREADSAFE MINIUPNP_STATICLIB
CONFIG += no_include_pwd
CONFIG += thread static
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
lessThan(QT_MAJOR_VERSION, 5): CONFIG += static
QMAKE_CXXFLAGS = -fpermissive

greaterThan(QT_MAJOR_VERSION, 4) {
    QT += widgets
    DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0
}

win32 {
    LIBS += -lshlwapi
    LIBS += $$join(BOOST_LIB_PATH,,-L,) $$join(BDB_LIB_PATH,,-L,) $$join(OPENSSL_LIB_PATH,,-L,) $$join(QRENCODE_LIB_PATH,,-L,)
    LIBS += -lssl -lcrypto -ldb_cxx$$BDB_LIB_SUFFIX -lcrypt32
    LIBS += -lws2_32 -lole32 -loleaut32 -luuid -lgdi32
    LIBS += -lboost_system-mgw49-mt-s-1_57 -lboost_filesystem-mgw49-mt-s-1_57 -lboost_program_options-mgw49-mt-s-1_57 -lboost_thread-mgw49-mt-s-1_57
    LIBS += -L"E:/MinGW/msys/1.0/local/lib"
    LIBS += -L"E:/libcommuni-3.2.0/lib"

    INCLUDEPATH += "E:/MinGW/msys/1.0/local/include"

BOOST_LIB_SUFFIX=-mgw49-mt-s-1_57
BOOST_INCLUDE_PATH=E:/boost_1_57_0
BOOST_LIB_PATH=E:/boost_1_57_0/stage/lib
BDB_INCLUDE_PATH=E:/db-4.8.30.NC/build_unix
BDB_LIB_PATH=E:/db-4.8.30.NC/build_unix
OPENSSL_INCLUDE_PATH=E:/openssl-1.0.1l/include
OPENSSL_LIB_PATH=E:/openssl-1.0.1l
MINIUPNPC_INCLUDE_PATH=E:/
MINIUPNPC_LIB_PATH=E:/miniupnpc
LIBPNG_INCLUDE_PATH=E:/libpng-1.6.16
LIBPNG_LIB_PATH=E:/libpng-1.6.16/.libs
QRENCODE_INCLUDE_PATH=E:/qrencode-3.4.4
QRENCODE_LIB_PATH=E:/qrencode-3.4.4/.libs
LIBEVENT_INCLUDE_PATH=E:/libevent-2.0.22/include
LIBEVENT_LIB_PATH=E:/libevent-2.0.22/.libs
}

# for boost 1.37, add -mt to the boost libraries
# use: qmake BOOST_LIB_SUFFIX=-mt
# for boost thread win32 with _win32 sufix
# use: BOOST_THREAD_LIB_SUFFIX=_win32-...
# or when linking against a specific BerkelyDB version: BDB_LIB_SUFFIX=-4.8

# Dependency library locations can be customized with:
#    BOOST_INCLUDE_PATH, BOOST_LIB_PATH, BDB_INCLUDE_PATH,
#    BDB_LIB_PATH, OPENSSL_INCLUDE_PATH and OPENSSL_LIB_PATH respectively

OBJECTS_DIR = build
MOC_DIR = build
UI_DIR = build

# use: qmake "RELEASE=1"
contains(RELEASE, 1) {
    macx:QMAKE_CXXFLAGS += -mmacosx-version-min=10.7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.7.sdk
    macx:QMAKE_CFLAGS += -mmacosx-version-min=10.7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.7.sdk
    macx:QMAKE_LFLAGS += -mmacosx-version-min=10.7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.7.sdk
    macx:QMAKE_OBJECTIVE_CFLAGS += -mmacosx-version-min=10.7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.7.sdk

    !windows:!macx {
        # Linux: static link
        # LIBS += -Wl,-Bstatic
    }
}

!win32 {
# for extra security against potential buffer overflows: enable GCCs Stack Smashing Protection
QMAKE_CXXFLAGS *= -fstack-protector-all --param ssp-buffer-size=1
QMAKE_LFLAGS *= -fstack-protector-all --param ssp-buffer-size=1
# We need to exclude this for Windows cross compile with MinGW 4.2.x, as it will result in a non-working executable!
# This can be enabled for Windows, when we switch to MinGW >= 4.4.x.
}
# for extra security on Windows: enable ASLR and DEP via GCC linker flags
win32:QMAKE_LFLAGS *= -Wl,--dynamicbase -Wl,--nxcompat,--large-address-aware -static
win32:QMAKE_LFLAGS += -static-libgcc -static-libstdc++
lessThan(QT_MAJOR_VERSION, 5): win32: QMAKE_LFLAGS *= -static

USE_QRCODE=1
# use: qmake "USE_QRCODE=1"
# libqrencode (http://fukuchi.org/works/qrencode/index.en.html) must be installed for support
contains(USE_QRCODE, 1) {
    message(Building with QRCode support)
    DEFINES += USE_QRCODE
    macx:LIBS += -lqrencode
    win32:INCLUDEPATH +=$$QRENCODE_INCLUDE_PATH
    win32:LIBS += $$join(QRENCODE_LIB_PATH,,-L) -lqrencode
    !win32:!macx:LIBS += -lqrencode
}

# use: qmake "USE_UPNP=1" ( enabled by default; default)
#  or: qmake "USE_UPNP=0" (disabled by default)
#  or: qmake "USE_UPNP=-" (not supported)
# miniupnpc (http://miniupnp.free.fr/files/) must be installed for support
USE_UPNP=1
contains(USE_UPNP, -) {
    message(Building without UPNP support)
} else {
    message(Building with UPNP support)
    count(USE_UPNP, 0) {
        USE_UPNP=1
    }
    DEFINES += USE_UPNP=$$USE_UPNP STATICLIB
    INCLUDEPATH += $$MINIUPNPC_INCLUDE_PATH
    LIBS += $$join(MINIUPNPC_LIB_PATH,,-L,) -lminiupnpc
    win32:LIBS += -liphlpapi
}

# use: qmake "USE_DBUS=1"
contains(USE_DBUS, 1) {
    message(Building with DBUS (Freedesktop notifications) support)
    DEFINES += USE_DBUS
    QT += dbus
}

# use: qmake "USE_IPV6=1" ( enabled by default; default)
#  or: qmake "USE_IPV6=0" (disabled by default)
#  or: qmake "USE_IPV6=-" (not supported)
contains(USE_IPV6, -) {
    message(Building without IPv6 support)
} else {
    message(Building with IPv6 support)
    count(USE_IPV6, 0) {
        USE_IPV6=1
    }
    DEFINES += USE_IPV6=$$USE_IPV6
}

contains(BITCOIN_NEED_QT_PLUGINS, 1) {
    DEFINES += BITCOIN_NEED_QT_PLUGINS
    QTPLUGIN += qcncodecs qjpcodecs qtwcodecs qkrcodecs qtaccessiblewidgets
}

INCLUDEPATH += src/leveldb/include src/leveldb/helpers
LIBS += $$PWD/src/leveldb/libleveldb.a $$PWD/src/leveldb/libmemenv.a

##hashing sources
SOURCES += \
    src/aes_helper.c \
    src/blake.c \
    src/bmw.c \
    src/cubehash.c \
    src/echo.c \
    src/groestl.c \
    src/jh.c \
    src/keccak.c \
    src/luffa.c \
    src/shavite.c \
    src/simd.c \
    src/skein.c \
    src/fugue.c \
    src/hamsi.c \ 
    src/tor/addressmap.c \
    src/tor/bridges.c \
    src/tor/channel.c \
    src/tor/channelpadding.c \
    src/tor/channeltls.c \
    src/tor/circpathbias.c \
    src/tor/circuitbuild.c \
    src/tor/circuitlist.c \
    src/tor/circuitmux.c \
    src/tor/circuitmux_ewma.c \
    src/tor/circuitstats.c \
    src/tor/circuituse.c \
    src/tor/command.c \
    src/tor/config.c \
    src/tor/confparse.c \
    src/tor/connection.c \
    src/tor/connection_edge.c \
    src/tor/connection_or.c \
    src/tor/conscache.c \
    src/tor/consdiff.c \
    src/tor/consdiffmgr.c \
    src/tor/control.c \
    src/tor/cpuworker.c \
    src/tor/dircollate.c \
    src/tor/directory.c \
    src/tor/dirserv.c \
    src/tor/dirvote.c \
    src/tor/dns.c \
    src/tor/dnsserv.c \
    src/tor/entrynodes.c \
    src/tor/ext_orport.c \
    src/tor/fp_pair.c \
    src/tor/geoip.c \
    src/tor/hibernate.c \
    src/tor/hs_cache.c \
    src/tor/hs_cell.c \
    src/tor/hs_circuit.c \
    src/tor/hs_circuitmap.c \
    src/tor/hs_client.c \
    src/tor/hs_common.c \
    src/tor/hs_config.c \
    src/tor/hs_descriptor.c \
    src/tor/hs_ident.c \
    src/tor/hs_intropoint.c \
    src/tor/hs_ntor.c \
    src/tor/hs_service.c \
    src/tor/keypin.c \
    src/tor/main.c \
    src/tor/microdesc.c \
    src/tor/networkstatus.c \
    src/tor/nodelist.c \
    src/tor/ntmain.c \
    src/tor/onion.c \
    src/tor/onion_fast.c \
    src/tor/onion_ntor.c \
    src/tor/onion_tap.c \
    src/tor/parsecommon.c \
    src/tor/periodic.c \
    src/tor/policies.c \
    src/tor/proto_cell.c \
    src/tor/proto_control0.c \
    src/tor/proto_ext_or.c \
    src/tor/proto_http.c \
    src/tor/proto_socks.c \
    src/tor/protover.c \
    src/tor/reasons.c \
    src/tor/relay.c \
    src/tor/rendcache.c \
    src/tor/rendclient.c \
    src/tor/rendcommon.c \
    src/tor/rendmid.c \
    src/tor/rendservice.c \
    src/tor/rephist.c \
    src/tor/replaycache.c \
    src/tor/router.c \
    src/tor/routerkeys.c \
    src/tor/routerlist.c \
    src/tor/routerparse.c \
    src/tor/routerset.c \
    src/tor/scheduler.c \
    src/tor/scheduler_kist.c \
    src/tor/scheduler_vanilla.c \
    src/tor/shared_random.c \
    src/tor/shared_random_state.c \
    src/tor/statefile.c \
    src/tor/status.c \
    src/tor/torcert.c \
    src/tor/transports.c \
    src/tor/common/address.c \
    src/tor/common/aes.c \
    src/tor/common/backtrace.c \
    src/tor/common/buffers.c \
    src/tor/common/buffers_tls.c \
    src/tor/common/compat.c \
    src/tor/common/compat_libevent.c \
    src/tor/common/compat_pthreads.c \
    src/tor/common/compat_rust.c \
    src/tor/common/compat_threads.c \
    src/tor/common/compat_time.c \
    src/tor/common/compat_winthreads.c \
    src/tor/common/compress.c \
    src/tor/common/compress_lzma.c \
    src/tor/common/compress_none.c \
    src/tor/common/compress_zlib.c \
    src/tor/common/compress_zstd.c \
    src/tor/common/confline.c \
    src/tor/common/container.c \
    src/tor/common/crypto.c \
    src/tor/common/crypto_curve25519.c \
    src/tor/common/crypto_ed25519.c \
    src/tor/common/crypto_format.c \
    src/tor/common/crypto_pwbox.c \
    src/tor/common/crypto_s2k.c \
    src/tor/common/di_ops.c \
    src/tor/common/log.c \
    src/tor/common/memarea.c \
    src/tor/common/procmon.c \
    src/tor/common/pubsub.c \
    src/tor/common/sandbox.c \
    src/tor/common/storagedir.c \
    src/tor/common/timers.c \
    src/tor/common/tortls.c \
    src/tor/common/util.c \
    src/tor/common/util_bug.c \
    src/tor/common/util_format.c \
    src/tor/common/util_process.c \
    src/tor/common/workqueue.c \
    src/tor/common/address.c \
    src/tor/common/aes.c \
    src/tor/common/backtrace.c \
    src/tor/common/buffers.c \
    src/tor/common/buffers_tls.c \
    src/tor/common/compat.c \
    src/tor/common/compat_libevent.c \
    src/tor/common/compat_pthreads.c \
    src/tor/common/compat_rust.c \
    src/tor/common/compat_threads.c \
    src/tor/common/compat_time.c \
    src/tor/common/compat_winthreads.c \
    src/tor/common/compress.c \
    src/tor/common/compress_lzma.c \
    src/tor/common/compress_none.c \
    src/tor/common/compress_zlib.c \
    src/tor/common/compress_zstd.c \
    src/tor/common/confline.c \
    src/tor/common/container.c \
    src/tor/common/crypto.c \
    src/tor/common/crypto_curve25519.c \
    src/tor/common/crypto_ed25519.c \
    src/tor/common/crypto_format.c \
    src/tor/common/crypto_pwbox.c \
    src/tor/common/crypto_s2k.c \
    src/tor/common/di_ops.c \
    src/tor/common/log.c \
    src/tor/common/memarea.c \
    src/tor/common/procmon.c \
    src/tor/common/pubsub.c \
    src/tor/common/sandbox.c \
    src/tor/common/storagedir.c \
    src/tor/common/timers.c \
    src/tor/common/tortls.c \
    src/tor/common/util.c \
    src/tor/common/util_bug.c \
    src/tor/common/util_format.c \
    src/tor/common/util_process.c \
    src/tor/common/workqueue.c \
    src/tor/curve25519_donna/curve25519-donna.c \
    src/tor/curve25519_donna/curve25519-donna-c64.c \
    src/tor/ext/csiphash.c \
    src/tor/ext/OpenBSD_malloc_Linux.c \
    src/tor/ext/readpassphrase.c \
    src/tor/ext/strlcat.c \
    src/tor/ext/strlcpy.c \
    src/tor/ext/tinytest.c \
    src/tor/ext/tinytest_demo.c \
    src/tor/ext/csiphash.c \
    src/tor/ext/OpenBSD_malloc_Linux.c \
    src/tor/ext/readpassphrase.c \
    src/tor/ext/strlcat.c \
    src/tor/ext/strlcpy.c \
    src/tor/ext/tinytest.c \
    src/tor/ext/tinytest_demo.c


    
NO_LEVELDB=1
!contains(NO_LEVELDB, 1) {
    !win32 {
        # we use QMAKE_CXXFLAGS_RELEASE even without RELEASE=1 because we use RELEASE to indicate linking preferences not -O preferences
        genleveldb.commands = cd $$PWD/src/leveldb && CC=$$QMAKE_CC CXX=$$QMAKE_CXX $(MAKE) OPT=\"$$QMAKE_CXXFLAGS $$QMAKE_CXXFLAGS_RELEASE\" libleveldb.a libmemenv.a
    } else {
        # make an educated guess about what the ranlib command is called
        isEmpty(QMAKE_RANLIB) {
            QMAKE_RANLIB = $$replace(QMAKE_STRIP, strip, ranlib)
        }
        LIBS += -lshlwapi
        genleveldb.commands = cd $$PWD/src/leveldb && CC=$$QMAKE_CC CXX=$$QMAKE_CXX TARGET_OS=OS_WINDOWS_CROSSCOMPILE $(MAKE) OPT=\"$$QMAKE_CXXFLAGS $$QMAKE_CXXFLAGS_RELEASE\" libleveldb.a libmemenv.a && $$QMAKE_RANLIB $$PWD/src/leveldb/libleveldb.a && $$QMAKE_RANLIB $$PWD/src/leveldb/libmemenv.a
    }
    genleveldb.target = $$PWD/src/leveldb/libleveldb.a
    genleveldb.depends = FORCE
    PRE_TARGETDEPS += $$PWD/src/leveldb/libleveldb.a
    QMAKE_EXTRA_TARGETS += genleveldb
    # Gross ugly hack that depends on qmake internals, unfortunately there is no other way to do it.
    QMAKE_CLEAN += $$PWD/src/leveldb/libleveldb.a; cd $$PWD/src/leveldb ; $(MAKE) clean
}
# regenerate src/build.h
!windows|contains(USE_BUILD_INFO, 1) {
    genbuild.depends = FORCE
    genbuild.commands = cd $$PWD; /bin/sh share/genbuild.sh $$OUT_PWD/build/build.h
    genbuild.target = $$OUT_PWD/build/build.h
    PRE_TARGETDEPS += $$OUT_PWD/build/build.h
    QMAKE_EXTRA_TARGETS += genbuild
    DEFINES += HAVE_BUILD_INFO
}

contains(USE_O3, 1) {
    message(Building O3 optimization flag)
    QMAKE_CXXFLAGS_RELEASE -= -O2
    QMAKE_CFLAGS_RELEASE -= -O2
    QMAKE_CXXFLAGS += -O3
    QMAKE_CFLAGS += -O3
}

*-g++-32 {
    message("32 platform, adding -msse2 flag")

    QMAKE_CXXFLAGS += -msse2
    QMAKE_CFLAGS += -msse2
}

greaterThan(QT_MAJOR_VERSION, 4) {
    win32:QMAKE_CXXFLAGS_WARN_ON = -fdiagnostics-show-option -Wall -Wextra -Wno-ignored-qualifiers -Wformat -Wformat-security -Wno-unused-parameter -Wstack-protector
    macx:QMAKE_CXXFLAGS_WARN_ON = -fdiagnostics-show-option -Wall -Wextra -Wformat -Wformat-security -Wno-unused-parameter -Wstack-protector
}
lessThan(QT_MAJOR_VERSION, 5) {
    QMAKE_CXXFLAGS_WARN_ON = -fdiagnostics-show-option -Wall -Wextra -Wno-ignored-qualifiers -Wformat -Wformat-security -Wno-unused-parameter -Wstack-protector
}

# Input
DEPENDPATH += src src/json src/qt
HEADERS += src/qt/bitcoingui.h \
    src/qt/transactiontablemodel.h \
    src/qt/addresstablemodel.h \
    src/qt/optionsdialog.h \
    src/qt/coincontroldialog.h \
    src/qt/coincontroltreewidget.h \
    src/qt/sendcoinsdialog.h \
    src/qt/addressbookpage.h \
    src/qt/signverifymessagedialog.h \
    src/qt/aboutdialog.h \
    src/qt/editaddressdialog.h \
    src/qt/bitcoinaddressvalidator.h \
    src/alert.h \
    src/addrman.h \
    src/base58.h \
    src/bignum.h \
    src/checkpoints.h \
    src/compat.h \
    src/coincontrol.h \
    src/smessage.h \
    src/sync.h \
    src/util.h \
    src/uint256.h \
    src/kernel.h \
    src/scrypt.h \
    src/pbkdf2.h \
    src/serialize.h \
    src/strlcpy.h \
    src/main.h \
    src/miner.h \
    src/net.h \
    src/key.h \
    src/db.h \
    src/txdb.h \
    src/walletdb.h \
    src/script.h \
    src/init.h \
    src/mruset.h \
    src/json/json_spirit_writer_template.h \
    src/json/json_spirit_writer.h \
    src/json/json_spirit_value.h \
    src/json/json_spirit_utils.h \
    src/json/json_spirit_stream_reader.h \
    src/json/json_spirit_reader_template.h \
    src/json/json_spirit_reader.h \
    src/json/json_spirit_error_position.h \
    src/json/json_spirit.h \
    src/qt/clientmodel.h \
    src/qt/guiutil.h \
    src/qt/transactionrecord.h \
    src/qt/guiconstants.h \
    src/qt/optionsmodel.h \
    src/qt/monitoreddatamapper.h \
    src/qt/transactiondesc.h \
    src/qt/transactiondescdialog.h \
    src/qt/bitcoinamountfield.h \
    src/wallet.h \
    src/keystore.h \
    src/qt/transactionfilterproxy.h \
    src/qt/transactionview.h \
    src/qt/walletmodel.h \
    src/bitcoinrpc.h \
    src/qt/overviewpage.h \
    src/qt/csvmodelwriter.h \
    src/crypter.h \
    src/qt/sendcoinsentry.h \
    src/qt/qvalidatedlineedit.h \
    src/qt/bitcoinunits.h \
    src/qt/qvaluecombobox.h \
    src/qt/askpassphrasedialog.h \
    src/protocol.h \
    src/qt/notificator.h \
    src/qt/qtipcserver.h \
    src/allocators.h \
    src/ui_interface.h \
    src/qt/rpcconsole.h \
    src/qt/messagepage.h \
    src/qt/messagemodel.h \
    src/qt/sendmessagesdialog.h \
    src/qt/sendmessagesentry.h \
    src/qt/plugins/mrichtexteditor/mrichtextedit.h \
    src/qt/qvalidatedtextedit.h \
    src/version.h \
    src/netbase.h \
    src/clientversion.h \
    src/bloom.h \
    src/checkqueue.h \
    src/hash.h \
    src/hashblock.h \
    src/limitedmap.h \
    src/sph_blake.h \
    src/sph_bmw.h \
    src/sph_cubehash.h \
    src/sph_echo.h \
    src/sph_groestl.h \
    src/sph_jh.h \
    src/sph_keccak.h \
    src/sph_luffa.h \
    src/sph_shavite.h \
    src/sph_simd.h \
    src/sph_skein.h \
    src/sph_fugue.h \
    src/sph_hamsi.h \
    src/sph_types.h \
    src/threadsafety.h \
    src/txdb-leveldb.h \
    src/lz4/lz4.h \
    src/xxhash/xxhash.h \
    src/tor/addressmap.h \
    src/tor/bridges.h \
    src/tor/channel.h \
    src/tor/channelpadding.h \
    src/tor/channeltls.h \
    src/tor/circpathbias.h \
    src/tor/circuitbuild.h \
    src/tor/circuitlist.h \
    src/tor/circuitmux.h \
    src/tor/circuitmux_ewma.h \
    src/tor/circuitstats.h \
    src/tor/circuituse.h \
    src/tor/command.h \
    src/tor/config.h \
    src/tor/confparse.h \
    src/tor/connection.h \
    src/tor/connection_edge.h \
    src/tor/connection_or.h \
    src/tor/conscache.h \
    src/tor/consdiff.h \
    src/tor/consdiffmgr.h \
    src/tor/control.h \
    src/tor/cpuworker.h \
    src/tor/dircollate.h \
    src/tor/directory.h \
    src/tor/dirserv.h \
    src/tor/dirvote.h \
    src/tor/dns.h \
    src/tor/dns_structs.h \
    src/tor/dnsserv.h \
    src/tor/entrynodes.h \
    src/tor/ext_orport.h \
    src/tor/fp_pair.h \
    src/tor/geoip.h \
    src/tor/hibernate.h \
    src/tor/hs_cache.h \
    src/tor/hs_cell.h \
    src/tor/hs_circuit.h \
    src/tor/hs_circuitmap.h \
    src/tor/hs_client.h \
    src/tor/hs_common.h \
    src/tor/hs_config.h \
    src/tor/hs_descriptor.h \
    src/tor/hs_ident.h \
    src/tor/hs_intropoint.h \
    src/tor/hs_ntor.h \
    src/tor/hs_service.h \
    src/tor/keypin.h \
    src/tor/main.h \
    src/tor/microdesc.h \
    src/tor/networkstatus.h \
    src/tor/nodelist.h \
    src/tor/ntmain.h \
    src/tor/onion.h \
    src/tor/onion_fast.h \
    src/tor/onion_ntor.h \
    src/tor/onion_tap.h \
    src/tor/or.h \
    src/tor/parsecommon.h \
    src/tor/periodic.h \
    src/tor/policies.h \
    src/tor/proto_cell.h \
    src/tor/proto_control0.h \
    src/tor/proto_ext_or.h \
    src/tor/proto_http.h \
    src/tor/proto_socks.h \
    src/tor/protover.h \
    src/tor/reasons.h \
    src/tor/relay.h \
    src/tor/rendcache.h \
    src/tor/rendclient.h \
    src/tor/rendcommon.h \
    src/tor/rendmid.h \
    src/tor/rendservice.h \
    src/tor/rephist.h \
    src/tor/replaycache.h \
    src/tor/router.h \
    src/tor/routerkeys.h \
    src/tor/routerlist.h \
    src/tor/routerparse.h \
    src/tor/routerset.h \
    src/tor/scheduler.h \
    src/tor/shared_random.h \
    src/tor/shared_random_state.h \
    src/tor/statefile.h \
    src/tor/status.h \
    src/tor/torcert.h \
    src/tor/transports.h \
    src/tor/common/address.h \
    src/tor/common/aes.h \
    src/tor/common/backtrace.h \
    src/tor/common/buffers.h \
    src/tor/common/buffers_tls.h \
    src/tor/common/compat.h \
    src/tor/common/compat_libevent.h \
    src/tor/common/compat_openssl.h \
    src/tor/common/compat_rust.h \
    src/tor/common/compat_threads.h \
    src/tor/common/compat_time.h \
    src/tor/common/compress.h \
    src/tor/common/compress_lzma.h \
    src/tor/common/compress_none.h \
    src/tor/common/compress_zlib.h \
    src/tor/common/compress_zstd.h \
    src/tor/common/confline.h \
    src/tor/common/container.h \
    src/tor/common/crypto.h \
    src/tor/common/crypto_curve25519.h \
    src/tor/common/crypto_ed25519.h \
    src/tor/common/crypto_format.h \
    src/tor/common/crypto_pwbox.h \
    src/tor/common/crypto_s2k.h \
    src/tor/common/di_ops.h \
    src/tor/common/handles.h \
    src/tor/common/memarea.h \
    src/tor/common/procmon.h \
    src/tor/common/pubsub.h \
    src/tor/common/sandbox.h \
    src/tor/common/storagedir.h \
    src/tor/common/testsupport.h \
    src/tor/common/timers.h \
    src/tor/common/torint.h \
    src/tor/common/torlog.h \
    src/tor/common/tortls.h \
    src/tor/common/util.h \
    src/tor/common/util_bug.h \
    src/tor/common/util_format.h \
    src/tor/common/util_process.h \
    src/tor/common/workqueue.h \
    src/tor/common/address.h \
    src/tor/common/aes.h \
    src/tor/common/backtrace.h \
    src/tor/common/buffers.h \
    src/tor/common/buffers_tls.h \
    src/tor/common/compat.h \
    src/tor/common/compat_libevent.h \
    src/tor/common/compat_openssl.h \
    src/tor/common/compat_rust.h \
    src/tor/common/compat_threads.h \
    src/tor/common/compat_time.h \
    src/tor/common/compress.h \
    src/tor/common/compress_lzma.h \
    src/tor/common/compress_none.h \
    src/tor/common/compress_zlib.h \
    src/tor/common/compress_zstd.h \
    src/tor/common/confline.h \
    src/tor/common/container.h \
    src/tor/common/crypto.h \
    src/tor/common/crypto_curve25519.h \
    src/tor/common/crypto_ed25519.h \
    src/tor/common/crypto_format.h \
    src/tor/common/crypto_pwbox.h \
    src/tor/common/crypto_s2k.h \
    src/tor/common/di_ops.h \
    src/tor/common/handles.h \
    src/tor/common/memarea.h \
    src/tor/common/procmon.h \
    src/tor/common/pubsub.h \
    src/tor/common/sandbox.h \
    src/tor/common/storagedir.h \
    src/tor/common/testsupport.h \
    src/tor/common/timers.h \
    src/tor/common/torint.h \
    src/tor/common/torlog.h \
    src/tor/common/tortls.h \
    src/tor/common/util.h \
    src/tor/common/util_bug.h \
    src/tor/common/util_format.h \
    src/tor/common/util_process.h \
    src/tor/common/workqueue.h \
    src/tor/ext/byteorder.h \
    src/tor/ext/ht.h \
    src/tor/ext/siphash.h \
    src/tor/ext/tinytest.h \
    src/tor/ext/tinytest_macros.h \
    src/tor/ext/tor_queue.h \
    src/tor/ext/tor_readpassphrase.h

SOURCES += src/qt/bitcoin.cpp \
    src/qt/bitcoingui.cpp \
    src/qt/transactiontablemodel.cpp \
    src/qt/addresstablemodel.cpp \
    src/qt/optionsdialog.cpp \
    src/qt/sendcoinsdialog.cpp \
    src/qt/coincontroldialog.cpp \
    src/qt/coincontroltreewidget.cpp \
    src/qt/addressbookpage.cpp \
    src/qt/signverifymessagedialog.cpp \
    src/qt/aboutdialog.cpp \
    src/qt/editaddressdialog.cpp \
    src/qt/bitcoinaddressvalidator.cpp \
    src/qt/messagepage.cpp \
    src/qt/messagemodel.cpp \
    src/qt/sendmessagesdialog.cpp \
    src/qt/sendmessagesentry.cpp \
    src/qt/qvalidatedtextedit.cpp \
    src/qt/plugins/mrichtexteditor/mrichtextedit.cpp \
    src/alert.cpp \
    src/version.cpp \
    src/sync.cpp \
    src/util.cpp \
    src/netbase.cpp \
    src/key.cpp \
    src/script.cpp \
    src/main.cpp \
    src/smessage.cpp \
    src/miner.cpp \
    src/init.cpp \
    src/net.cpp \
    src/checkpoints.cpp \
    src/addrman.cpp \
    src/db.cpp \
    src/walletdb.cpp \
    src/qt/clientmodel.cpp \
    src/qt/guiutil.cpp \
    src/qt/transactionrecord.cpp \
    src/qt/optionsmodel.cpp \
    src/qt/monitoreddatamapper.cpp \
    src/qt/transactiondesc.cpp \
    src/qt/transactiondescdialog.cpp \
    src/qt/bitcoinstrings.cpp \
    src/qt/bitcoinamountfield.cpp \
    src/wallet.cpp \
    src/keystore.cpp \
    src/qt/transactionfilterproxy.cpp \
    src/qt/transactionview.cpp \
    src/qt/walletmodel.cpp \
    src/bitcoinrpc.cpp \
    src/rpcdump.cpp \
    src/rpcnet.cpp \
    src/rpcmining.cpp \
    src/rpcwallet.cpp \
    src/rpcblockchain.cpp \
    src/rpcrawtransaction.cpp \
    src/rpcsmessage.cpp \
    src/qt/overviewpage.cpp \
    src/qt/csvmodelwriter.cpp \
    src/crypter.cpp \
    src/qt/sendcoinsentry.cpp \
    src/qt/qvalidatedlineedit.cpp \
    src/qt/bitcoinunits.cpp \
    src/qt/qvaluecombobox.cpp \
    src/qt/askpassphrasedialog.cpp \
    src/protocol.cpp \
    src/qt/notificator.cpp \
    src/qt/qtipcserver.cpp \
    src/qt/rpcconsole.cpp \
    src/noui.cpp \
    src/kernel.cpp \
    src/scrypt-arm.S \
    src/scrypt-x86.S \
    src/scrypt-x86_64.S \
    src/scrypt.cpp \
    src/pbkdf2.cpp \
    src/txdb-leveldb.cpp \
    src/json/json_spirit_reader.cpp \
    src/json/json_spirit_writer.cpp \
    src/bloom.cpp \
    src/hash.cpp

RESOURCES += \
    src/qt/bitcoin.qrc

FORMS += \
    src/qt/forms/coincontroldialog.ui \
    src/qt/forms/sendcoinsdialog.ui \
    src/qt/forms/addressbookpage.ui \
    src/qt/forms/signverifymessagedialog.ui \
    src/qt/forms/aboutdialog.ui \
    src/qt/forms/editaddressdialog.ui \
    src/qt/forms/transactiondescdialog.ui \
    src/qt/forms/overviewpage.ui \
    src/qt/forms/sendcoinsentry.ui \
    src/qt/forms/askpassphrasedialog.ui \
    src/qt/forms/rpcconsole.ui \
    src/qt/forms/optionsdialog.ui \
    src/qt/forms/messagepage.ui \
    src/qt/forms/sendmessagesentry.ui \
    src/qt/forms/sendmessagesdialog.ui \
    src/qt/plugins/mrichtexteditor/mrichtextedit.ui

contains(USE_QRCODE, 1) {
HEADERS += src/qt/qrcodedialog.h
SOURCES += src/qt/qrcodedialog.cpp
FORMS += src/qt/forms/qrcodedialog.ui
}

CODECFORTR = UTF-8

# for lrelease/lupdate
# also add new translations to src/qt/bitcoin.qrc under translations/
TRANSLATIONS = $$files(src/qt/locale/bitcoin_*.ts)

isEmpty(QMAKE_LRELEASE) {
    win32:QMAKE_LRELEASE = $$[QT_INSTALL_BINS]\\lrelease.exe
    else:QMAKE_LRELEASE = $$[QT_INSTALL_BINS]/lrelease
}
isEmpty(QM_DIR):QM_DIR = $$PWD/src/qt/locale
# automatically build translations, so they can be included in resource file
TSQM.name = lrelease ${QMAKE_FILE_IN}
TSQM.input = TRANSLATIONS
TSQM.output = $$QM_DIR/${QMAKE_FILE_BASE}.qm
TSQM.commands = $$QMAKE_LRELEASE ${QMAKE_FILE_IN} -qm ${QMAKE_FILE_OUT}
TSQM.CONFIG = no_link
QMAKE_EXTRA_COMPILERS += TSQM

# "Other files" to show in Qt Creator
OTHER_FILES += \
    doc/*.rst \
    doc/*.txt \
    doc/README README.md \
    res/bitcoin-qt.rc \
    src/makefile.* 

# platform specific defaults, if not overridden on command line
isEmpty(BOOST_LIB_SUFFIX) {
    macx:BOOST_LIB_SUFFIX = -mt
    win32:BOOST_LIB_SUFFIX = -mgw49-mt-s-1_57
}

isEmpty(BOOST_THREAD_LIB_SUFFIX) {
    BOOST_THREAD_LIB_SUFFIX = $$BOOST_LIB_SUFFIX
}

isEmpty(BDB_LIB_PATH) {
#    macx:BDB_LIB_PATH = /usr/local/Cellar/berkeley-db4/4.8.30/lib
}

isEmpty(BDB_LIB_SUFFIX) {
#    macx:BDB_LIB_SUFFIX = -4.8
}

isEmpty(BDB_INCLUDE_PATH) {
#    macx:BDB_INCLUDE_PATH = /usr/local/Cellar/berkeley-db4/4.8.30/include
}

isEmpty(BOOST_LIB_PATH) {
    macx:BOOST_LIB_PATH = /usr/local/lib
}

isEmpty(BOOST_INCLUDE_PATH) {
    macx:BOOST_INCLUDE_PATH = /usr/local/include
}

isEmpty(QRENCODE_LIB_PATH) {
    macx:QRENCODE_LIB_PATH = /usr/local/lib
}

isEmpty(QRENCODE_INCLUDE_PATH) {
    macx:QRENCODE_INCLUDE_PATH = /usr/local/include
}

windows:DEFINES += WIN32
windows:RC_FILE = src/qt/res/bitcoin-qt.rc

windows:!contains(MINGW_THREAD_BUGFIX, 0) {
    # At least qmake's win32-g++-cross profile is missing the -lmingwthrd
    # thread-safety flag. GCC has -mthreads to enable this, but it doesn't
    # work with static linking. -lmingwthrd must come BEFORE -lmingw, so
    # it is prepended to QMAKE_LIBS_QT_ENTRY.
    # It can be turned off with MINGW_THREAD_BUGFIX=0, just in case it causes
    # any problems on some untested qmake profile now or in the future.
    DEFINES += _MT BOOST_THREAD_PROVIDES_GENERIC_SHARED_MUTEX_ON_WIN
    QMAKE_LIBS_QT_ENTRY = -lmingwthrd $$QMAKE_LIBS_QT_ENTRY
}

!windows:!macx {
    DEFINES += LINUX
    LIBS += -lrt
}

macx:HEADERS += src/qt/macdockiconhandler.h src/qt/macnotificationhandler.h
macx:OBJECTIVE_SOURCES += src/qt/macdockiconhandler.mm src/qt/macnotificationhandler.mm
macx:LIBS += -framework Foundation -framework ApplicationServices -framework AppKit -framework CoreServices
macx:DEFINES += MAC_OSX MSG_NOSIGNAL=0
macx:ICON = src/qt/res/icons/DeepOnion.icns
macx:TARGET = "DeepOnion-Qt"
macx:QMAKE_CFLAGS_THREAD += -pthread
macx:QMAKE_LFLAGS_THREAD += -pthread
macx:QMAKE_CXXFLAGS_THREAD += -pthread

# Set libraries and includes at end, to use platform-defined defaults if not overridden
INCLUDEPATH += $$BOOST_INCLUDE_PATH $$BDB_INCLUDE_PATH $$OPENSSL_INCLUDE_PATH $$QRENCODE_INCLUDE_PATH $$LIBEVENT_INCLUDE_PATH
LIBS += $$join(BOOST_LIB_PATH,,-L,) $$join(BDB_LIB_PATH,,-L,) $$join(OPENSSL_LIB_PATH,,-L,) $$join(QRENCODE_LIB_PATH,,-L,) $$join(LIBEVENT_LIB_PATH,,-L,)
LIBS += -lssl -lcrypto -ldb_cxx$$BDB_LIB_SUFFIX
LIBS += -levent -lz

# -lgdi32 has to happen after -lcrypto (see  #681)
windows:LIBS += -lws2_32 -lshlwapi -lmswsock -lole32 -loleaut32 -luuid -lgdi32
LIBS += -lboost_system$$BOOST_LIB_SUFFIX \
    -lboost_filesystem$$BOOST_LIB_SUFFIX \
    -lboost_program_options$$BOOST_LIB_SUFFIX \
    -lboost_thread$$BOOST_THREAD_LIB_SUFFIX \
    -lboost_chrono$$BOOST_LIB_SUFFIX

contains(RELEASE, 1) {
    !windows:!macx {
        # Linux: turn dynamic linking back on for c/c++ runtime libraries
        LIBS += -Wl,-Bdynamic
    }
}

system($$QMAKE_LRELEASE -silent $$_PRO_FILE_)

DISTFILES += \
    src/tor/fallback_dirs.inc \
    src/tor/include.am \
    src/tor/Makefile.nmake \
    src/tor/common/ciphers.inc \
    src/tor/common/include.am \
    src/tor/common/linux_syscalls.inc \
    src/tor/common/Makefile.nmake \
    src/tor/common/ciphers.inc \
    src/tor/common/include.am \
    src/tor/common/linux_syscalls.inc \
    src/tor/common/Makefile.nmake \
    src/tor/curve25519_donna/README \
    src/tor/ext/include.am \
    src/tor/ext/tor_queue.txt \
    src/tor/ext/Makefile.nmake \
    src/tor/ext/README \
    src/tor/ext/include.am \
    src/tor/ext/tor_queue.txt \
    src/tor/ext/Makefile.nmake \
    src/tor/ext/README \
    src/tor/ext/include.am \
    src/tor/ext/tor_queue.txt \
    src/tor/ext/Makefile.nmake \
    src/tor/ext/README \
    src/tor/ext/include.am \
    src/tor/ext/tor_queue.txt \
    src/tor/ext/Makefile.nmake \
    src/tor/ext/README
