@echo off
rmdir /Q /S cache
.\artifacts\FXServer.exe +set onesync legacy +set onesync on +set onesync_enableInfinity 1 +set onesync_enableBeyond 1 +set onesync_forceMigration 1 +set onesync_distanceCullVehicles 1 +set onesync_workaround763185 1 +set onesync_radiusFrequency 1 +exec server.cfg