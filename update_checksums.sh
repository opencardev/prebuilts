#!/bin/bash

cd csmt
md5sum $(basename crankshaft) > crankshaft.md5
cd ..

cd gpio2kbd
md5sum $(basename gpio2kbd) > gpio2kbd.md5
cd ..

cd openauto
md5sum $(basename autoapp) > autoapp.md5
md5sum $(basename autoapp_helper) > autoapp_helper.md5
md5sum $(basename btservice) > btservice.md5
md5sum $(basename libaasdk.so) > libaasdk.so.md5
md5sum $(basename libaasdk_proto.so) > libaasdk_proto.so.md5
cd ..

cd udev
md5sum $(basename 51-android.rules) > 51-android.rules.md5
cd ..

cd usbreset
md5sum $(basename usbreset) > usbreset.md5
cd ..

cd cam_overlay
md5sum $(basename cam_overlay.bin) > cam_overlay.bin.md5
cd ..
