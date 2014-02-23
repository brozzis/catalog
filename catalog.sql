
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE "exifRaw" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
	"ApertureValue"  varchar(30),
	"AutoExposureBracketing"  varchar(30),
	"AutoISO"  varchar(30),
	"BaseISO"  varchar(30),
	"CameraType"  varchar(30),
	"CanonExposureMode"  varchar(30),
	"CanonFlashMode"  varchar(30),
	"CanonImageType"  varchar(30),
	"CanonModelID"  varchar(30),
	"ContinuousDrive"  varchar(30),
	"CreateDate"  varchar(30),
	"ExposureCompensation"  varchar(30),
	"ExposureLevelIncrements"  varchar(30),
	"ExposureProgram"  varchar(30),
	"ExposureTime"  varchar(30),
	"FNumber"  varchar(30),
	"Flash"  varchar(30),
	"FocalLength"  varchar(30),
	"FocusMode"  varchar(30),
	"ISO"  varchar(30),
	"ImageSize"  varchar(30),
	"Lens"  varchar(30),
	"LensID"  varchar(30),
	"LensType"  varchar(30),
	"MIMEType"  varchar(30),
	"Make"  varchar(30),
	"MaxAperture"  varchar(30),
	"MaxFocalLength"  varchar(30),
	"MeasuredEV"  varchar(30),
	"MeteringMode"  varchar(30),
	"MinAperture"  varchar(30),
	"MinFocalLength"  varchar(30),
	"ModifyDate"  varchar(30),
	"SerialNumber"  varchar(30),
	"ShootingMode"  varchar(30),
	"ShutterCount"  varchar(30),
	"ShutterSpeed"  varchar(30),
	"ShutterSpeedValue"  varchar(30),
	"TargetAperture"  varchar(30),
	"TargetExposureTime"  varchar(30)
 );
CREATE TABLE "catalog" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "d" varchar(255) DEFAULT NULL,
  "f" varchar(255) DEFAULT NULL,
  "size" decimal(10,0) DEFAULT NULL,
  "f_date" int(11) DEFAULT NULL,
  "created_at" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE control ( "id" INTEGER PRIMARY KEY AUTOINCREMENT, "label" varchar(32), "basedir" varchar(50), "note" varchar(250), dts timestamp, dte timestamp);
CREATE TABLE thumbs (
	"id" INTEGER PRIMARY KEY AUTOINCREMENT, 
	idi varchar(32), 
	thumb text
);
CREATE TABLE imageTags (
	id 	INTEGER,
	idi    varchar(32) primary key,
	ApertureValue varchar(20),
	CanonFlashMode varchar(20),
	CreateDate datetime, -- 
	ExposureCompensation varchar(20),
	ExposureTime varchar(20),
	FNumber varchar(20),
	Flash varchar(20),
	FocalLength varchar(20),
	FocusMode varchar(20),
	ISO varchar(20),
	ImageSize varchar(20),
	MeasuredEV varchar(20),
	ShootingMode varchar(20),
	ShutterSpeed varchar(20)
);
CREATE TABLE lensTags (
	idl    varchar(32) primary key,
	Lens varchar(20),
	LensID varchar(35),
	LensType varchar(35),
	MaxAperture varchar(10),
	MaxFocalLength varchar(10),
	MinAperture varchar(10),
	MinFocalLength varchar(10)
);
INSERT INTO "lensTags" VALUES('db9169242eea3fe200f4cd02cf16e1c6','70.0 - 200.0 mm','Unknown 70-200mm','Unknown (-1)',NULL,'200 mm',NULL,'70 mm');
INSERT INTO "lensTags" VALUES('9c49b94d3a4d243593dbbac608235b64',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "lensTags" VALUES('25515dc0476d4ed69cae6b4c14c37e22','28.0 - 105.0 mm','Unknown 28-105mm','Unknown (-1)','4','105 mm','22','28 mm');
INSERT INTO "lensTags" VALUES('868218393bc6b45434a9b2c7493fe52e','28.0 - 105.0 mm','Unknown 28-105mm','Unknown (-1)','4','105 mm','27','28 mm');
INSERT INTO "lensTags" VALUES('06ffad458f5b871e7e54d45a915c0da2','50.0 mm','Canon EF 50mm f/1.8','Canon EF 50mm f/1.8','1.8','50 mm','23','50 mm');
INSERT INTO "lensTags" VALUES('9b45abaa00e8d73b4ff491fcf625ebc4','17.0 - 40.0 mm','Unknown 17-40mm','Unknown (-1)',NULL,'40 mm',NULL,'17 mm');
INSERT INTO "lensTags" VALUES('eb88e2a597138797504053cb8920f035','17.0 - 40.0 mm','Unknown 17-40mm','Unknown (-1)','4','40 mm','22','17 mm');
INSERT INTO "lensTags" VALUES('47ba72cca56057c827fbd619bc2e0da1','70.0 - 200.0 mm','Unknown 70-200mm','Unknown (-1)','2.8','200 mm','32','70 mm');
INSERT INTO "lensTags" VALUES('d2e38f826b838c3f0e3ff01055bec263','24.0 - 70.0 mm','Canon EF 24-70mm f/2.8L','Canon EF 24-70mm f/2.8L','2.8','70 mm','23','24 mm');
INSERT INTO "lensTags" VALUES('f2c7552a2a1ab38896c6cff0e82cd22d','140.0 - 400.0 mm','Canon EF 70-200mm f/2.8 L + 2x','Canon EF 70-200mm f/2.8 L + 2x','5.7','400 mm','64','140 mm');
INSERT INTO "lensTags" VALUES('80b268348d6b0d0b290ed2fb3825a0cd','24.0 - 70.0 mm','Unknown 24-70mm','Unknown (-1)','2.8','70 mm','22','24 mm');
INSERT INTO "lensTags" VALUES('edbef3e01236134d2c9c58d5763a83df','24.0 - 70.0 mm','Unknown 24-70mm','Unknown (-1)',NULL,'70 mm',NULL,'24 mm');
INSERT INTO "lensTags" VALUES('0c3c040f8d123c854cc901a3fce4116b','17.0 - 40.0 mm','Canon EF 17-40mm f/4L','Canon EF 17-40mm f/4L','4','40 mm','23','17 mm');
INSERT INTO "lensTags" VALUES('60a0589338add527438615b9de4088a2','28.0 - 105.0 mm','Unknown 28-105mm','Unknown (-1)',NULL,'105 mm',NULL,'28 mm');
INSERT INTO "lensTags" VALUES('a5389679a619c8ff18ca81b72f6d7286','28.0 - 105.0 mm','Unknown 28-105mm','Unknown (-1)','3.6','105 mm','22','28 mm');
INSERT INTO "lensTags" VALUES('e3b07e16f3e2e57962153ac14bd1f15f','0.0 mm',NULL,NULL,NULL,'0 mm',NULL,'0 mm');
INSERT INTO "lensTags" VALUES('d22f2c1109509358d6197f09fd23bbe0','70.0 - 200.0 mm','Canon EF 70-200mm f/2.8 L','Canon EF 70-200mm f/2.8 L','2.8','200 mm','32','70 mm');
CREATE TABLE cameraTags (
	idc    varchar(32) primary key,
	CameraType varchar(20),
	CanonImageType varchar(25),
	CanonModelID varchar(20),
	Make varchar(20),
	SerialNumber varchar(20)
);
INSERT INTO "cameraTags" VALUES('40634ffa0366f18e5f4bd0b85e33c7da','EOS Mid-range','Canon EOS 20D','EOS 20D','Canon','0430109172');
INSERT INTO "cameraTags" VALUES('d77c7b5170e1933fc856d49a4ccbed9e',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "cameraTags" VALUES('c7e1fd02e6972886d62ecb537c88d7e7','EOS High-end','Canon EOS-1Ds Mark II','EOS-1Ds Mark II','Canon','314996');
CREATE TABLE settingsTags (
	ids    varchar(32) primary key,
	AutoExposureBracketing varchar(20),
	CanonFlashMode varchar(20),
	ContinuousDrive varchar(20),
	ExposureLevelIncrements varchar(30),
	Flash varchar(20),
	FocusMode varchar(20),
	ISO varchar(20),
	MeteringMode varchar(20),
	ShootingMode varchar(20)
);
CREATE TABLE collider (
	idi varchar(32) primary key,
	idl varchar(32),
	idc varchar(32),
	ids varchar(32),
	ShutterCount int
	);
COMMIT;
