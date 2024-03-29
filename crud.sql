use master
go
drop database asms
go
create database asms collate Romanian_CI_AI
go

use asms

create table paymentOrders
(
id int identity primary key,
nr int not null,
"date" date not null,
"state" int not null
)

create table areas
(
id int identity primary key,
name nvarchar(20)
);
create table localities
(
id int identity primary key,
name nvarchar(30) not null
);
create table districts
(
id int identity primary key,
name nvarchar(20),
code nvarchar(2),
areaId int references areas(id)
);

create table organizationForms
(
id int identity primary key,
name nvarchar(50),
abbreviation nvarchar(5)
);

create table farmers
(
id int identity primary key,
ftype int not null check(ftype in (1,2))
);

create table farmerVersions
(
id int identity primary key,
farmerId int references farmers(id),
startDate date not null,
endDate date
);

create table landowners
(
id int identity primary key,
farmerVersionId int references farmerVersions(id) not null,
firstName nvarchar(20) not null,
lastName nvarchar(20) not null,
fathersName nvarchar(20) not null,
dateOfBirth Date not null,
fiscalCode nvarchar(13) not null
);

create table organizations
(
id int identity primary key,
farmerVersionId int references farmerVersions(id) not null,
fiscalCode nvarchar(13) not null,
name nvarchar(200) not null,
RegDate Date,
RegNr nvarchar(20),
OrganizationFormId int,
activityType nvarchar(20)
);

create table addresses
(
id int identity primary key,
farmerId int references farmers(id) not null,
districtId int references districts(id),
localityId int references localities(id),
zip nvarchar(5),
street nvarchar(30),
house nvarchar(5),
apartment nvarchar(5),
startDate date not null,
endDate date
);

create table phones
(
id int identity primary key,
farmerId int references farmers(id) not null,
number nvarchar(15) not null,
type tinyint not null,
startDate date not null,
endDate date
);

create table emails
(
id int identity primary key,
farmerId int references farmers(id) not null,
address nvarchar(50) not null,
startDate date not null,
endDate date
);

create table users
(
id int identity primary key,
name nvarchar(20) unique not null,
password char(32) not null
);

create table roles
(
id int primary key,
name nvarchar(20) unique not null
);

create table usersroles
(
userId int foreign key references users(id),
roleId int foreign key references roles(id),
unique(userId, roleId)
);

create table perfecters
(
id int identity primary key,
name nvarchar(50)
);

create table states
(
id int primary key,
name nvarchar(20) not null unique
);

create table measures
(
id int identity primary key,
name nvarchar(30) not null unique,
description nvarchar(200),
nocontest bit not null default(0)
);

create table measuresets
(
id int identity primary key,
name nvarchar(30) not null,
"year" int not null,
stateId int not null default(1) references states(id),
dateActivated date,
dateDeactivated date
);

create table measuresetsmeasures
(
measuresetId int references measuresets(id),
measureId int references measures(id)
);

create table fields
(
id int identity primary key,
name nvarchar(max) not null,
description nvarchar(max)
);

create table fieldsetStates
(
id int primary key,
name nvarchar(16) unique not null
);

create table fieldsets
(
id int identity primary key,
name nvarchar(100) not null,
"year" int not null,
stateId int not null references fieldsetStates(id)
);

create table fieldsetsfields
(
fieldsetId int references fieldsets(id),
fieldId int references fields(id),
unique(fieldsetId, fieldId)
);

create table dossierStates
(
id int primary key,
name nvarchar(20) not null
);

create table fpis
(
id int identity primary key,
measuresetId int references measuresets(id),
measureId int references measures(id),
"month" int not null,
amount money not null,
amountm money not null,
"state" int not null,
unique(measuresetId, measureId, "month")
);


create table dossiers
(
id int identity primary key,
farmerVersionId int references farmerVersions(id),
adminFirstName nvarchar(20),
adminLastName nvarchar(20),
representativeFirstName nvarchar(20),
representativeLastName nvarchar(20),
friendPhone nvarchar(50),
proTraining bit,
speciality nvarchar(max),
diplomaIssuer nvarchar(max),
hasContract bit,
contractNumber nvarchar(max),
contractDate Date,
serviceProvider nvarchar(max),
consultantId int,
amountRequested money not null,
amountPayed money not null,
investmentValue money not null,
value money,
disqualified bit default(0) not null,
createdBy int, --references users(id),
createdDate Date,
measureId int references measures(id) not null,
perfecterId int references perfecters(id) not null,
fieldsetId int references fieldsets(id) not null,
stateId int references dossierStates(id) not null,
measuresetId int references measuresets(id) not null,
fpiId int references fpis(id),
code nvarchar(20),
districtId int references districts(id) not null,
localityId int references localities(id)
);

create table fieldvalues 
(
dossierId int references dossiers(id),
fieldId int references fields(id),
value money,
unique(dossierId, fieldId)
);

create table indicators
(
id int identity primary key,
fieldsetId int references fieldsets(id),
name nvarchar(max) not null,
formula nvarchar(max) not null
);

create table indicatorvalues
(
dossierId int references dossiers(id),
indicatorId int references indicators(id),
value money not null,
unique(dossierId, indicatorId)
);

create table coefficients
(
id int identity primary key,
fieldsetId int references fieldsets(id),
name nvarchar(max) not null,
formula nvarchar(max) not null
);

create table coefficientvalues
(
dossierId int references dossiers(id),
coefficientId int references coefficients(id),
value money not null,
unique(dossierId, coefficientId)
);

create table disqualifiers
(
id int identity primary key,
dossierId int references dossiers(id),
reason nvarchar(max)
);

create table contracts
(
id int identity primary key,
date Date not null,
account char(15) not null,
bankcode varchar(10) not null,	
bankname nvarchar(100) not null,
dossierId int references dossiers(id) unique not null,
supportNr nvarchar(10) not null,
paymentOrderId int references paymentOrders(id)
);

create table agreements
(
id int identity primary key,
date Date not null,
amount money not null,
nr tinyint, 
contractId int references contracts(id) not null,
fpiId int references fpis(id) not null,
paymentOrderId int references paymentOrders(id)
);

/********************************* views ***************************/
go
create view farmerInfos
as
select f.id, fv.id as farmerVersionId, o.name + ' ' + orgf.abbreviation as name, o.fiscalCode, f.FType 
from farmers f 
inner join farmerVersions fv on f.id = fv.farmerid
inner join organizations o on o.farmerVersionId = fv.id
inner join organizationForms orgf on orgf.id = o.OrganizationFormId
where fv.enddate is null
union
select f.id, fv.id as farmerVersionId, l.FirstName +' '+ l.LastName + ' ' + l.FathersName as name, l.fiscalCode, f.FType 
from farmers f
inner join farmerVersions fv on fv.farmerid = f.id
inner join landowners l on l.farmerVersionId = fv.id
where fv.enddate is null;

go
create view farmerVersionInfos
as
select f.id as FarmerId, fv.id, o.name + ' ' + orgf.abbreviation as name, o.fiscalCode, f.FType 
from farmers f 
inner join farmerVersions fv on f.id = fv.farmerid
inner join organizations o on o.farmerVersionId = fv.id
inner join organizationForms orgf on orgf.id = o.OrganizationFormId
union
select f.id as FarmerId, fv.id, l.FirstName +' '+ l.LastName + ' ' + l.FathersName as name, l.fiscalCode, f.FType 
from farmers f
inner join farmerVersions fv on fv.farmerid = f.id
inner join landowners l on l.farmerVersionId = fv.id;



go
create view addressInfos
as
select a.*, d.name as district, l.name as locality, d.code as DistrictCode from addresses a 
inner join districts d on a.districtId = d.id
inner join localities l on a.localityId = l.id;

go
create view organizationInfos
as
select o.*, orgf.abbreviation as OrganizationForm, fv.farmerId, fv.startDate, fv.endDate from organizations o 
inner join organizationForms orgf on o.OrganizationFormId = orgf.id
inner join farmerVersions fv on fv.id = o.farmerVersionId;

go
create view dossierInfos
as
select d.id, d.createdDate, fv.name, fv.fiscalCode, m.name as measure, d.stateId, d.disqualified, d.fpiId
from dossiers d inner join farmerVersionInfos fv on fv.id = d.farmerVersionId
inner join measures m on m.id = d.measureId;

go
create view landOwnerInfos
as
select lo.*, fv.startDate, fv.endDate, fv.farmerId from landowners lo
inner join farmerVersions fv on fv.id = lo.farmerVersionId;

go
create view competitors
as
select d.id, d.code, d.amountPayed, SUM(cv.value) value, fvi.name, d.fpiId, d.stateId, d.disqualified from dossiers d
left outer join coefficientvalues cv on d.id = cv.dossierId
inner join farmerVersionInfos fvi on fvi.id = d.farmerVersionId
group by d.id, fvi.name, d.fpiId, d.stateId, d.amountPayed, d.disqualified, d.code

go
create view FieldValueInfos
as
select f.name, fv.value, fv.dossierId, f.id from fieldvalues fv inner join fields f on fv.fieldId = f.id

go
create view IndicatorValueInfos
as
select i.name, iv.value, iv.dossierId, i.id from indicatorvalues iv inner join indicators i on iv.indicatorId = i.id

go
create view CoefficientValueInfos
as
select c.name, cv.value, cv.dossierId, c.id from coefficientvalues cv inner join coefficients c on cv.coefficientId = c.id
go
create view capos
as
select fvi.name, fvi.fiscalCode, c.id as contractNr, c.date contractDate, null as agreementId, null as agreementNr, null agreementDate, d.amountPayed amount, po.Nr poNr, po.date poDate, po.state  poState, po.id poId
from farmerVersionInfos fvi 
inner join dossiers d on d.farmerVersionId = fvi.id
inner join contracts c on c.dossierId = d.id
left join paymentOrders po on po.id = c.paymentOrderId

union

select fvi.name, fvi.fiscalCode, c.id as contractNr, c.date contractDate, a.id agreementId, a.nr as agreementNr, a.date agreementDate, a.amount, po.Nr poNr, po.date poDate, po.state poState, po.Id poId
from farmerVersionInfos fvi 
inner join dossiers d on d.farmerVersionId = fvi.id
inner join contracts c on c.dossierId = d.id
inner join agreements a on a.contractId = c.id
left join paymentOrders po on po.id = a.paymentOrderId


go
/********************************* data *******************************/
insert roles values(1, 'admin');
insert roles values(2, 'superuser');
insert roles values(3, 'user');

insert users(name, password) values('admin', 'R4WjQy44C9FByPhEOCav8pEFe1r1EEUS');
declare @id int;
set @id = @@identity;
insert usersroles values(@id, 1);
insert usersroles values(@id, 2);

go

insert dossierStates values(1, N'înregistrat');
insert dossierStates values(2, N'are_valori_câmpuri');
insert dossierStates values(3, 'are_indicatori');
insert dossierStates values(4, 'are_coeficienti');
insert dossierStates values(5, N'câștigator');
insert dossierStates values(6, 'autorizat');


insert fieldsetStates values(1, N'înregistrat');
insert fieldsetStates values(2, 'are_campuri');
insert fieldsetStates values(3, 'are_indicatori');
insert fieldsetStates values(4, 'are_coeficienti');
insert fieldsetStates values(5, 'activ');
insert fieldsetStates values(6, 'dezactivat');


insert states values(1, 'înregistrat');
insert states values(2, 'activ');
insert states values(3, 'dezactivat');

insert areas(name) values('Nord');
insert areas(name) values('Centru');
insert areas(name) values('Sud');

insert districts(name, code) values(N'Bălți','BL');
insert districts(name, code) values(N'Briceni','BR');
insert districts(name, code) values(N'Dondușeni','DN');
insert districts(name, code) values(N'Drochia','DR');
insert districts(name, code) values(N'Edineț','ED');
insert districts(name, code) values(N'Fălești','FL');
insert districts(name, code) values(N'Florești','FR');
insert districts(name, code) values(N'Glodeni','GD');
insert districts(name, code) values(N'Ocnița','OC');
insert districts(name, code) values(N'Râșcani','RS');
insert districts(name, code) values(N'Sângerei','SN');
insert districts(name, code) values(N'Soroca','BL');
insert districts(name, code) values(N'Anenii Noi','AN');
insert districts(name, code) values(N'Călărași','CL');
insert districts(name, code) values(N'Criuleni','CR');
insert districts(name, code) values(N'Ialoveni','IL');
insert districts(name, code) values(N'Nisporeni','NS');
insert districts(name, code) values(N'Orhei','OR');
insert districts(name, code) values(N'Rezina','RZ');
insert districts(name, code) values(N'Strășeni','ST');
insert districts(name, code) values(N'Șoldănești','SD');
insert districts(name, code) values(N'Telenești','TL');
insert districts(name, code) values(N'Ungheni','UN');
insert districts(name, code) values(N'Basarabeasca','BS');
insert districts(name, code) values(N'Cahul','CH');
insert districts(name, code) values(N'Cantemir','CT');
insert districts(name, code) values(N'Causeni','CS');
insert districts(name, code) values(N'Cimișlia','CM');
insert districts(name, code) values(N'Leova','LV');
insert districts(name, code) values(N'Ștefan Vodă','SV');
insert districts(name, code) values(N'Taraclia','TR');
insert districts(name, code) values(N'UTA Găgăuzia','GE');
insert districts(name, code) values(N'Mun. Chișinău', 'C');


insert perfecters(name) values('ACSA');
insert perfecters(name) values('AGROINFORM');
insert perfecters(name) values('UNIAGROPROTECT');
insert perfecters(name) values('FNFM');
insert perfecters(name) values('DIRECTIE AGRICOLA RAIONALA');
insert perfecters(name) values('Solicitantul');
insert perfecters(name) values('Altele');


insert organizationForms(name, abbreviation) values(N'Cooperativa de producție', 'CP');
insert organizationForms(name, abbreviation) values(N'Cooperativa de întreprinzător', N'CÎ');
insert organizationForms(name, abbreviation) values(N'Gospodărie țărănească', N'GȚ');
insert organizationForms(name, abbreviation) values(N'Întreprindere individual', N'ÎI');
insert organizationForms(name, abbreviation) values(N'Societate pe acțiuni', 'SA');
insert organizationForms(name, abbreviation) values(N'Societate în comandită', 'SC');
insert organizationForms(name, abbreviation) values(N'Societate în nume colectiv', 'SNC');
insert organizationForms(name, abbreviation) values(N'Societate cu răspundere limitată', 'SRL');

--1
insert fields(name, description) values('Locuri de munca create aditional in urma investitiei', 'Daca se creaza: 0 locuri de munca - se indica valoare "0"; de la 1 pana la 5 locuri de munca - se indica valoarea "0.2"; de la 6 pana la 10 locuri de munca - se indica valoarea "0.3"; peste 10 locuri de munca - se indica valoarea "0.5"');
--2
insert fields(name, description) values('Valoare investitiei (in MDL)', 'Cifra respectiva se selecteaza din punctul 5 al business planului "Finantarea Proiectului Investitional", si reprezinta bugetul investitiei, cu TVA. Suma data se indica in MDL');
--3
insert fields(name, description) values('Venituri din vanzari (sau vanzari nete, in MDL)', 'Suma data o gasim in tabelul "Raportul privind rezultatele financiare" la rubrica "Total pentru I an"');
--4
insert fields(name, description) values('Alte venituri operationale (in MDL)', 'Suma data o gasim in tabelul "Raportul privind rezultatele financiare" la rubrica "Total pentru I an"');
--5
insert fields(name, description) values('Costul vanzarilor (in MDL)', 'Suma data o gasim in tabelul "Raportul privind rezultatele financiare" la rubrica "Total pentru I an"');
--6
insert fields(name, description) values('Cheltuieli comerciale (in MDL)', ' Suma data o gasim in tabelul "Raportul privind rezultatele financiare" la rubrica "Total pentru I an"');
--7
insert fields(name, description) values('Cheltuieli generale si administrative (in MDL)', 'Suma data o gasim in tabelul "Raportul privind rezultatele financiare" la rubrica "Total pentru I an"');
--8
insert fields(name, description) values('Alte cheltuieli operationale (in MDL)', 'Suma data o gasim in tabelul "Raportul privind rezultatele financiare" la rubrica "Total pentru I an"');
--9
insert fields(name, description) values('Total intrari de mijloace banesti in trimestrul I, anul I (in MDL)', 'Suma o gasim in tabelul "Flux de numerar implicat in proiect" la rubrica "Trimestrul I, anul I"');
--10
insert fields(name, description) values('Total intrari de mijloace banesti in trimestrul II, anul I (in MDL)', 'Suma data o gasim in tabelul "Flux de numerar implicat in proiect" la rubrica "Trimestrul II, anul I"');
--11
insert fields(name, description) values('Total intrari de mijloace banesti in trimestrul III, anul I (in MDL)', 'Suma data o gasim in tabelul "Flux de numerar implicat in proiect" la rubrica "Trimestrul III, anul I"');
--12
insert fields(name, description) values('Total intrari de mijloace banesti in trimestrul IV, anul I (in MDL)', 'Suma data o gasim in tabelul "Flux de numerar implicat in proiect" la rubrica "Trimestrul IV, anul I"');
--13
insert fields(name, description) values('Total intrari de mijloace banesti in anul II (in MDL)', 'Suma data o gasim in tabelul "Flux de numerar implicat in proiect" la rubrica "Anul II"');
--14
insert fields(name, description) values('Total intrari de mijloace banesti in anul III (in MDL)', 'Suma data o gasim in tabelul "Flux de numerar implicat in proiect" la rubrica "Anul III"');
--15
insert fields(name, description) values('Fluxul net pentru trimestrul I, anul I (in MDL)', 'Suma data o gasim in tabelul "Flux de numerar implicat in proiect" (Mijloace banesti la sfarsitul perioadei de gestiune)');
--16
insert fields(name, description) values('Fluxul net pentru trimestrul II, anul I (in MDL)', 'Suma data o gasim in tabelul "Flux de numerar implicat in proiect" (Mijloace banesti la sfarsitul perioadei de gestiune)');
--17
insert fields(name, description) values('Fluxul net pentru trimestrul III, anul I (in MDL)', 'Suma data o gasim in tabelul "Flux de numerar implicat in proiect" (Mijloace banesti la sfarsitul perioadei de gestiune)');
--18
insert fields(name, description) values('Fluxul net pentru trimestrul IV, anul I (in MDL)', 'Suma data o gasim in tabelul "Flux de numerar implicat in proiect" (Mijloace banesti la sfarsitul perioadei de gestiune)');
--19
insert fields(name, description) values('Datorii pe termen scurt (in MDL)', 'Suma data o gasim in Bilantul contabil si include: dobanzi, plati leasing, rambursarea datoriilor');
--20
insert fields(name, description) values('Total datorii pe termen lung (in MDL)', 'Suma data o gasim in Bilantul contabil');
--21
insert fields(name, description) values('Total Active (in MDL)', 'Suma data o gasim in Bilantul Contabil');
--22
insert fields(name, description) values('Profitul net pentru anul I (in MDL)', 'Suma data o gasim in Raportul privind rezultatele financiare');
--23
insert fields(name, description) values('Profitul net pentru anul II (in MDL)', 'Suma data o gasim in Raportul privind rezultatele financiare');
--24
insert fields(name, description) values('Profitul net pentru anul III (in MDL)', 'Suma data o gasim in Raportul privind rezultatele financiare');
--25
insert fields(name, description) values('Total active materiale pe termen lung (in MDL)', 'Suma data o gasim in Bilantul contabil');


insert fieldsets(name, stateId, "year") values('setul pe anul 2010', 5, '2010');
insert fieldsetsfields(fieldId, fieldsetId) values(1,1);
insert fieldsetsfields(fieldId, fieldsetId) values(2,1);
insert fieldsetsfields(fieldId, fieldsetId) values(3,1);


insert indicators(name,formula, fieldsetId) values('ind1','c1+c2', 1); 
insert indicators(name,formula, fieldsetId) values('ind2','c2+c3', 1);
insert indicators(name,formula, fieldsetId) values('ind3','c3', 1);

insert coefficients(name,formula,fieldsetId) values('coef1','i1+i2',1);
insert coefficients(name,formula,fieldsetId) values('coef2','i2+i3',1);
insert coefficients(name,formula,fieldsetId) values('coef3','i3',1);


insert measures(name,description) values('Masura 1','Stimularea creditarii producatorilor agricoli de catre bancile comerciale');
insert measures(name,description, nocontest) values('Masura 2','Stimularea mecanismului de asigurare in agricultura',1);
insert measures(name,description) values('Masura 3','Subventionarea investitiilor pentru plantatiile multianuale');
insert measures(name,description) values('Masura 4','Subventionarea investitiilor pentru producerea legumelor pentru teren protejat');
insert measures(name,description) values('Masura 5','Subventionarea investitiilor pentru procurarea tehnicii si utilajului agricol precum si a echipamentului de irigare');
insert measures(name,description) values('Masura 6','Sustinerea promovarii si dezvoltarii agriculturii ecologice');
insert measures(name,description) values('Masura 7','Stimularea investitiilor in utilarea si renovarea tehnologica a fermelor zootehnice');
insert measures(name,description, nocontest) values('Masura 8','Stimularea procurarii animalelor de prasila si mentinerea fondului lor genetic',1);
insert measures(name,description) values('Masura 9','Stimularea investitiilor in dezvoltarea infrastructurii posrecoltare si procesare');
insert measures(name,description) values('Masura 10','Subventionarea producatorilor agricoli pentru compensarea cheltuielilor energetice la irigare');



insert measuresets(name,"year",stateId) values('setul de masuri pe anul 2010', 2010, 2)
insert measuresetsmeasures(measureId, measuresetId) values(1, 1)
insert measuresetsmeasures(measureId, measuresetId) values(2, 1)
insert measuresetsmeasures(measureId, measuresetId) values(3, 1)
insert measuresetsmeasures(measureId, measuresetId) values(4, 1)
insert measuresetsmeasures(measureId, measuresetId) values(5, 1)
insert measuresetsmeasures(measureId, measuresetId) values(6, 1)
insert measuresetsmeasures(measureId, measuresetId) values(7, 1)
insert measuresetsmeasures(measureId, measuresetId) values(8, 1)
insert measuresetsmeasures(measureId, measuresetId) values(9, 1)
insert measuresetsmeasures(measureId, measuresetId) values(10, 1)

--reset
--update dossiers set stateId = 2 ,value = null
--delete from coefficientvalues
--delete from fpis



