
drop table if exists imageTags ;
drop table if exists lensTags ;
drop table if exists cameraTags ;
drop table if exists settingsTags ;
drop table if exists collider ;
drop table if exists thumbs;

CREATE TABLE if not exists thumbs (
	"id" INTEGER PRIMARY KEY AUTOINCREMENT, 
	idi varchar(32), 
	thumb text
);

create table if not exists imageTags (
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

create table if not exists lensTags (
	idl    varchar(32) primary key,
	Lens varchar(20),
	LensID varchar(35),
	LensType varchar(35),
	MaxAperture varchar(10),
	MaxFocalLength varchar(10),
	MinAperture varchar(10),
	MinFocalLength varchar(10)
);

create table if not exists cameraTags (
	idc    varchar(32) primary key,
	CameraType varchar(20),
	CanonImageType varchar(25),
	CanonModelID varchar(20),
	Make varchar(20),
	SerialNumber varchar(20)
);

create table if not exists settingsTags (
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

create table if not exists collider (
	idi varchar(32) primary key,
	idl varchar(32),
	idc varchar(32),
	ids varchar(32),
	ShutterCount int
	);
