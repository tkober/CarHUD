#include <BLEAttribute.h>
#include <BLECentral.h>
#include <BLECharacteristic.h>
#include <BLECommon.h>
#include <BLEDescriptor.h>
#include <BLEPeripheral.h>
#include <BLEService.h>
#include <BLETypedCharacteristic.h>
#include <BLETypedCharacteristics.h>
#include <BLEUuid.h>
#include <CurieBLE.h>

#include "OBD2_PIDs.h"

BLEPeripheral blePeripheral;       
BLEService heartRateServic = BLEService("180D"); 

BLECharacteristic heartRateChar = BLECharacteristic("2A37", BLENotify, 2);

void setup() {
  // put your setup code here, to run once:
 
}

void loop() {
  // put your main code here, to run repeatedly:
 
}
