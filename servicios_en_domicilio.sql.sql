
--Autor:Eduardo Jose Illiano 

--PEDIDO BASE POR DOMICIIO 


--1.	CANTIDAD DE LINEAS FIJAS
--2.	CANTIDAD DE LINEAS MOVILES
--3.	CANTIDAD DE PERSONAS TITULARES DE ALGUN SERVICIO (FIJO O MOVIL)
--4.	SI TIENE O NO INTERNET
--5.	SI TIENE O NO CABLE


--TABLE FINAL:cablevision.servicios_en_domicilio

-- cruze domiciios cable-internet

drop table if exists cablevision.cruze_domicilio;

create table  cablevision.cruze_domicilio
as 
select 
a.provincia_a,
a.localidad_a,
a.calle_a,
a.altura_a,
a.cod_calle_loc_a,
a.nro_doc,
a.nro_linea_fija,
b.provincia_b,
b.localidad_b,
b.calle_b
FROM
cablevision.clientes_telefonia_fija  a 
left join 
cablevision.cruce_domicilios b 
on a.cod_calle_loc_a=b.cod_calle_loc_a;

--telefono fijo -cable -internet 

drop table if exists  cablevision.cable_internet ;

create table  cablevision.cable_internet
as 
select 
case when a.provincia_a is not null then a.provincia_a else b.provincia_b end as provincia ,
case when a.localidad_a is not null then a.localidad_a else b.localidad_b end as localidad ,
case when a.calle_a is not null then a.calle_a else b.calle_b end as calle ,
case when a.altura_a is not null then a.altura_a else b.altura_b end as  altura ,
case when a.nro_doc is not null then a.nro_doc else b.nro_doc end as  nro_doc ,
a.nro_linea_fija,
case when b.tiene_internet is null then 0 else b.tiene_internet end as tiene_internet,
case when b.tiene_cable is null then 0 else b.tiene_cable end as tiene_cable 

FROM
cablevision.cruze_domicilio  a 
full outer  join 
cablevision.clientes_cable_internet b 
on 
a.provincia_b=b.provincia_b
and 
a.localidad_b=b.localidad_b
and 
a.calle_b=b.calle_b
and
a.altura_a=b.altura_b;







--Telefonia fija  en  distritos 

drop table if exists cablevision.telefonia_fija_domicilio;

create table cablevision.telefonia_fija_domicilio
as
select 
provincia,
localidad,
calle,
altura,
nro_doc,
nro_linea_fija,
case when nro_linea_fija is not null then '1' else '0' end  as ctd_domicilio_linea_fija,
tiene_internet,
tiene_cable
from cablevision.cable_internet  ;

--Sumarizacion de lineas fijas por distrito 



drop table if exists cablevision.telefonia_fija_domicilio_final;

create table  cablevision.telefonia_fija_domicilio_final
as 
select 
provincia,
localidad,
calle,
altura,
nro_doc,
sum(ctd_domicilio_linea_fija) as ctd_domicilio_linea_fija,
tiene_internet,
tiene_cable
from cablevision.telefonia_fija_domicilio
group by 
provincia,
localidad,
calle,
altura,
nro_doc,
tiene_internet,
tiene_cable ;

--movil

--lineas moviles en  distritos 



drop table if exists cablevision.telefonia_movil_domicilio;

create table  cablevision.telefonia_movil_domicilio
as 
select 
a.provincia,
a.localidad,
a.calle,
a.altura,
a.nro_doc,
sum(ctd_domicilio_linea_fija) as  ctd_domicilio_linea_fija,
a.tiene_internet,
a.tiene_cable,
b.nro_linea_movil,
case when nro_linea_movil is not null then '1'  else  '0' end as  ctd_domicilio_linea_movil 
from  cablevision.telefonia_fija_domicilio_final  a
left join  cablevision.clientes_telefonia_movil b
on a.nro_doc=b.nro_doc
group by 
a.provincia,
a.localidad,
a.calle,
a.altura,
a.nro_doc,
b.nro_linea_movil,
a.tiene_internet,
a.tiene_cable;



--sumarizacion de clientes de linea movil por distrito 

drop table if exists cablevision.telefonia_movil_domicilio_final;

create table  cablevision.telefonia_movil_domicilio_final
as 
select 
provincia,
localidad,
calle,
altura,
nro_doc,
ctd_domicilio_linea_fija,
sum(ctd_domicilio_linea_movil)  as  ctd_domicilio_linea_movil,
tiene_internet,
tiene_cable 
FROM
cablevision.telefonia_movil_domicilio
group by 
provincia,
localidad,
calle,
altura,
nro_doc,
ctd_domicilio_linea_fija,
tiene_internet,
tiene_cable;


--cantidad de personas 



drop table if exists cablevision.personas_con_servicio;

create table  cablevision.personas_con_servicio
as 
select 
provincia,
localidad,
calle,
altura,
nro_doc,
sum(ctd_domicilio_linea_fija) as ctd_domicilio_linea_fija,
sum(ctd_domicilio_linea_movil) as ctd_domicilio_linea_movil ,
tiene_internet,
tiene_cable,
'1'   as ctd_personas_con_servicio
FROM
cablevision.telefonia_movil_domicilio_final
group by 
provincia,
localidad,
calle,
altura,
nro_doc,
tiene_internet,
tiene_cable;



--sumarizacion de personas con servicio 

drop table if exists cablevision.servicios_en_domicilio;


create table  cablevision.servicios_en_domicilio
as 
select 
provincia,
localidad,
calle,
altura,
sum(ctd_domicilio_linea_fija) as ctd_domicilio_linea_fija ,
sum(ctd_domicilio_linea_movil) as ctd_domicilio_linea_movil ,
sum(ctd_personas_con_servicio) as ctd_personas_con_servicio,
tiene_internet,
tiene_cable
FROM
cablevision.personas_con_servicio
group by 
provincia,
localidad,
calle,
altura,
tiene_internet,
tiene_cable
;






--TABLAS PARA TABLERO----TABLAS PARA TABLERO----TABLAS PARA TABLERO----TABLAS PARA TABLERO----TABLAS PARA TABLERO----TABLAS PARA TABLERO--



--1.	CANTIDAD DE DOMICILIOS CON AL MENOS UNA LINEA FIJA
--2.	CANTIDAD DE DOMICILIOS CON AL MENOS UNA LINEA MOVIL
--3.	CANTIDAD DE DOMICILIOS CON INTERNET
--4.	CANTIDAD DE DOMICILIOS CON CABLE
--5.	CANTIDAD DE DOMICILIOS QUE POSEEN LOS 4 PRODUCTOS


drop table if exists  cablevision.cantidad_domiciio_linea_fija;

create table cablevision.cantidad_domiciio_linea_fija
as
select sum(cantidad_domicilio_linea_fija) as  cantidad_domicilio_al_menos_una_linea_fija from(
select provincia ,localidad,calle,altura ,'1' as cantidad_domicilio_linea_fija 
from  cablevision.servicios_en_domicilio
where ctd_domicilio_linea_fija >= 1) a ;

--2

drop table if exists  cablevision.cantidad_domicilio_linea_movil;

create table cablevision.cantidad_domicilio_linea_movil
as
select sum(cantidad_domicilio_linea_movil) as cantidad_domicilio_al_menos_linea_movil from(
select provincia ,localidad,calle,altura ,'1' as cantidad_domicilio_linea_movil 
from  cablevision.servicios_en_domicilio
where ctd_domicilio_linea_movil >= 1) a ;


--3
drop table if exists  cablevision.cantidad_tiene_internet;

create table cablevision.cantidad_tiene_internet
as
select sum(cantidad_tiene_internet) as cantidad_domicilio_internet from(
select provincia ,localidad,calle,altura ,'1' as cantidad_tiene_internet
from cablevision.servicios_en_domicilio
where tiene_internet  >= 1) a ;




--4
drop table if exists  cablevision.cantidad_tiene_cable;

create table cablevision.cantidad_tiene_cable
as
select sum(cantidad_tiene_cable ) cantidad_domicilio_cable from(
select provincia ,localidad,calle,altura ,'1' as cantidad_tiene_cable
from cablevision.servicios_en_domicilio
where tiene_cable  >= 1) a ;


--5
drop table if exists  cablevision.cantidad_todos_servicios;

create table cablevision.cantidad_todos_servicios
as
select sum(cantidad_todos_servicios ) as cantidad_domicilio_todos_servicios from(
select provincia ,localidad,calle,altura ,'1' as cantidad_todos_servicios
from  cablevision.servicios_en_domicilio
where tiene_cable  >=1 and  tiene_internet  >= 1 and   ctd_domicilio_linea_movil >= 1 and 
  ctd_domicilio_linea_fija >= 1) a ;







--


