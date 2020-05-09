--AUTOR: Eduardo Jose Illiano


-- CREACION Y CARGA DE TABLAS LANDING

--REPOSITORIO DE ARCHVIOS UTILIZADO :  AMAZON S3 
--HERRAMIENTA DE BASE DE DATOS UTLILIZADA:  AMAZON REDSHIFT 


--inputs tables

--cablevision.clientes_telefonia_fija
--cablevision.clientes_cable_internet
--cablevision.clientes_telefonia_movil
--cablevision.cruce_domicilios


---TELEFONIA FIJA ----TELEFONIA FIJA ----TELEFONIA FIJA ----TELEFONIA FIJA ----TELEFONIA FIJA ----TELEFONIA FIJA ----TELEFONIA FIJA ----TELEFONIA FIJA ----TELEFONIA FIJA --


--DROP AND CREATE TABLE TELEFONIA FIJA 


drop table if exists cablevision.clientes_telefonia_fija;
 
create table  cablevision.clientes_telefonia_fija


(

NRO_LINEA_FIJA 	bigint 	,
TIPO_DOC 	varchar(10)	,
NRO_DOC 	bigint	,
CALLE_A 	varchar(500)	,
ALTURA_A	integer	,
LOCALIDAD_A	varchar(100)	,
PROVINCIA_A	varchar(20)	,
COD_CALLE_LOC_A	varchar(100)	
);


--DELETE AND LOAD TABLE TELEFONIA FIJA 

delete 
cablevision.clientes_telefonia_fija;

copy 
cablevision.clientes_telefonia_fija from
's3://itx-repo/landing/test/Telefonia_Fija.csv'
iam_role 'YYYY'
delimiter ';'
acceptinvchars
csv
ignoreheader 1
;





--CABLE -INTERNET----CABLE -INTERNET----CABLE -INTERNET----CABLE -INTERNET----CABLE -INTERNET----CABLE -INTERNET----CABLE -INTERNET----CABLE -INTERNET--


--DROP AND CREATE CABLE-INTERNET 

drop table if exists cablevision.clientes_cable_internet;
 
create table  cablevision.clientes_cable_internet


(
nro_contrato integer ,
tipo_doc varchar(200),
nro_doc	bigint ,
calle_b	 varchar(500),
altura_b	integer,
localidad_b	varchar(100),
provincia_b	varchar(20),
tiene_internet	integer,
tiene_cable	 integer 
);

--DELETE AND LOAD CABLE-INTERNET 




delete 
cablevision.clientes_cable_internet;

copy 
cablevision.clientes_cable_internet from
's3://itx-repo/landing/test/Clientres_Cable_Internet.csv'
iam_role 'YYYY'
delimiter ';'
acceptinvchars
csv
ignoreheader 1
;





---TELEFONIA MOVIL----TELEFONIA MOVIL----TELEFONIA MOVIL----TELEFONIA MOVIL----TELEFONIA MOVIL----TELEFONIA MOVIL----TELEFONIA MOVIL----TELEFONIA MOVIL--




--DROP AND CREATE TABLE  TELEFONIA MOVIL 

drop table if exists cablevision.clientes_telefonia_movil;

create  table 

cablevision.clientes_telefonia_movil
(
nro_linea_movil bigint,
tipo_doc varchar(10),
nro_doc bigint

);

--DELETE AND LOAD TABLE  TELEFONIA MOVIL 

delete 
cablevision.clientes_telefonia_movil;

copy 
cablevision.clientes_telefonia_movil from
's3://itx-ahr-jaac-data-repo/landing/test/Clientes_Telefonia_Movil.csv'
iam_role 'YYYY'
delimiter ';'
acceptinvchars
csv
ignoreheader 1
;

--CRUCE DOMICILIOS----CRUCE DOMICILIOS----CRUCE DOMICILIOS----CRUCE DOMICILIOS----CRUCE DOMICILIOS----CRUCE DOMICILIOS----CRUCE DOMICILIOS----CRUCE DOMICILIOS--




drop table if exists cablevision.cruce_domicilios ;
 
create table  cablevision.cruce_domicilios 

(


CALLE_A	varchar(500),
LOCALIDAD_A	varchar(100),
PROVINCIA_A	varchar(20),
COD_CALLE_LOC_A	varchar(100),
CALLE_B	varchar(500),
LOCALIDAD_B	varchar(100),
PROVINCIA_B	varchar(100)

);



delete 
cablevision.cruce_domicilios;

copy 
cablevision.cruce_domicilios from
's3://itx-repo/landing/test/Cruce_Domiciios.csv'
iam_role 'YYYY'
delimiter ';'
acceptinvchars
csv
ignoreheader 1
;



