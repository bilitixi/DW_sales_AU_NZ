DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS orderdetail;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS productline;
DROP TABLE IF EXISTS productorder;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS office;

CREATE TABLE office (
  officeCode varchar(10) NOT NULL,
  city varchar(50) NOT NULL,
  phone varchar(50) NOT NULL,  addressLine1 varchar(50) NOT NULL,
  addressLine2 varchar(50) DEFAULT NULL,
  state varchar(50) DEFAULT NULL,
  country varchar(50) NOT NULL,
  postalCode varchar(15) NOT NULL,
  territory varchar(10) NOT NULL,
  PRIMARY KEY (officeCode)
)


CREATE TABLE employee (
  employeeNumber int NOT NULL,
  lastName varchar(50) NOT NULL,
  firstName varchar(50) NOT NULL,
  extension varchar(10) NOT NULL,
  email varchar(100) NOT NULL,
  officeCode varchar(10) NOT NULL,
  reportsTo int DEFAULT NULL,
  jobTitle varchar(50) NOT NULL,
  PRIMARY KEY (employeeNumber),  
  CONSTRAINT employee_ibfk_1 FOREIGN KEY (reportsTo) REFERENCES employee (employeeNumber),
  CONSTRAINT employee_ibfk_2 FOREIGN KEY (officeCode) REFERENCES office (officeCode)
) 





CREATE TABLE customer (
  customerNumber int NOT NULL,
  customerName varchar(50) NOT NULL,
  contactLastName varchar(50) NOT NULL,
  contactFirstName varchar(50) NOT NULL,
  phone varchar(50) NOT NULL,
  addressLine1 varchar(50) NOT NULL,
  addressLine2 varchar(50) DEFAULT NULL,
  city varchar(50) NOT NULL,
  state varchar(50) DEFAULT NULL,
  postalCode varchar(15) DEFAULT NULL,
  country varchar(50) NOT NULL,
  salesRepEmployeeNumber int DEFAULT NULL,
  creditLimit decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (customerNumber),
  
  CONSTRAINT customer_ibfk_1 FOREIGN KEY (salesRepEmployeeNumber) REFERENCES employee (employeeNumber)
) 




CREATE TABLE productorder (
  orderNumber int NOT NULL,
  orderDate date NOT NULL,
  requiredDate date,
  shippedDate date DEFAULT NULL,
  [status] varchar(15) NOT NULL,
  comments text,
  customerNumber int NOT NULL,
  PRIMARY KEY (orderNumber),  
  CONSTRAINT productorder_ibfk_1 FOREIGN KEY (customerNumber) REFERENCES customer (customerNumber)
)


CREATE TABLE productline (
  productLine varchar(50) NOT NULL,
  textDescription varchar(4000) DEFAULT NULL,
  htmlDescription text,
  pimage image,
  PRIMARY KEY (productLine)
) 


CREATE TABLE product (
  productCode varchar(15) NOT NULL,
  productName varchar(70) NOT NULL,
  productLine varchar(50) NOT NULL,
  productscale varchar(10) NOT NULL,
  productVendor varchar(50) NOT NULL,
  productDescription text NOT NULL,
  quantityInStock smallint NOT NULL,
  buyPrice decimal(10,2) NOT NULL,
  MSRP decimal(10,2) NOT NULL,
  PRIMARY KEY (productCode),  
  CONSTRAINT product_ibfk_1 FOREIGN KEY (productLine) REFERENCES productline (productLine)
)


CREATE TABLE orderdetail (
  orderNumber int NOT NULL,
  productCode varchar(15) NOT NULL,
  quantityOrdered int NOT NULL,
  priceEach decimal(10,2) NOT NULL,
  orderLineNumber smallint NOT NULL,
  PRIMARY KEY (orderNumber,productCode),  
  CONSTRAINT orderdetail_ibfk_1 FOREIGN KEY (orderNumber) REFERENCES productorder (orderNumber),
  CONSTRAINT orderdetail_ibfk_2 FOREIGN KEY (productCode) REFERENCES product (productCode)
) 

CREATE TABLE payment (
  customerNumber int NOT NULL,
  checkNumber varchar(50) NOT NULL,
  paymentDate date NOT NULL,
  amount decimal(10,2) NOT NULL,
  PRIMARY KEY (customerNumber,checkNumber),
  CONSTRAINT payment_ibfk_1 FOREIGN KEY (customerNumber) REFERENCES customer (customerNumber)
) 




--

insert  into office(officeCode,city,phone,addressLine1,addressLine2,state,country,postalCode,territory) values 

('50','Sydney','+61 2 9264 2451','5-11 Wentworth Avenue','Floor #2',NULL,'Australia','NSW 2010','APAC'),
('52','Auckland','+64 27 125 8821','67 Carrington Rd','building 113',NULL,'New Zealand','NZ 1005','NULL'),
('53','Wanaka','+64 21 445 5431', '12A Corrollar Dr','room 154',NULL,'New Zealand','NZ 1200','NULL'),
('54','Melbourne','+61 4 905 1131','154A Springvale Rd','building 900-3',NULL,'australia','Victoria 1099','Victoria');



--Data for the table employee 

insert  into employee(employeeNumber,lastName,firstName,extension,email,officeCode,reportsTo,jobTitle) values 

(5002,'Blakky','Mary','x5800','marryb@classicmodelcars.com','52',NULL,'President'),

(5056,'Henerson','Garry','x9011','garryh@classicmodelcars.com','52',5002,'VP Sales'),

(5076,'Fillini','Carry','x9273','jcfillini@classicmodelcars.com','53',5002,'VP Marketing'),

(5088,'Sundale','William','x4971','wsundale@classicmodelcars.com','53',5002,'Sales Manager (APAC)'),

(5102,'Cruser','Tom','x5908','gtomc@classicmodelcars.com','54',5002,'Sale Manager (EMEA)'),

(5143,'Bonny','Ammy','x9428','bonnya@classicmodelcars.com','54',5002,'Sales Manager (NA)'),

(5165,'Singingy','Jeslie','x3991','singingyj@classicmodelcars.com','54',5002,'Sales Rep'),

(5611,'Fixter','Andy','x101','afixter@classicmodelcars.com','50',5002,'Sales Rep'),

(5612,'Marsh','Peter','x102','pmarsh@classicmodelcars.com','50',5002,'Sales Rep'),

(5619,'King','Tom','x103','tking@classicmodelcars.com','50',5002,'Sales Rep');






--Data for the table customer */

insert  into customer(customerNumber,customerName,contactLastName,contactFirstName,phone,addressLine1,addressLine2,city,state,postalCode,country,salesRepEmployeeNumber,creditLimit) values 


(5114,'Australian Collectors, Co.','Ferguson','Peter','03 9520 4555','636 St Kilda Road','Level 3','Melbourne','Victoria','3004','Australia',5102,'117300.00'),
(5276,'Anna''s Decorations, Ltd','O''Hara','Anna','02 9936 8555','201 Miller Street','Level 15','North Sydney','NSW','2060','Australia',5056,'107800.00'),
(5282,'Souveniers And Things Co.','Huxley','Adrian','+61 2 9495 8555','Monitor Money Building','815 Pacific Hwy','Chatswood','NSW','2067','Australia',5102,'93300.00'),
(5333,'Australian Gift Network, Co','Calaghan','Ben','61-7-3844-6555','31 Duncan St. West End',NULL,'South Brisbane','Queensland','4101','australia',5102,'51600.00'),
(5357,'GiftsForHim.com','MacKinlay','Wales','64-9-3763555','199 Great North Road',NULL,'Auckland',NULL,NULL,'New Zealand',5056,'77700.00'),
(5412,'Extreme Desk Decorations, Ltd','McRoy','Sarah','04 499 9555','101 Lambton Quay','Level 11','Wellington',NULL,NULL,'new zealand',5056,'86800.00'),
(5414,'Best Decor, Ltd','McBerry','Mary','04 410 9115','102 Sunny Rd','Level 3','Wellington',NULL,NULL,'New zealand',5102,'23900.00'),
(5471,'Australian Collectables, Ltd','Clenahan','Sean','61-9-3844-6555','7 Allen Street',NULL,'Glen Waverly','Victoria','3150','Australia',5102,'60300.00'),
(5496,'Kelly''s Gift Shop','Snowden','Tony','+64 9 5555500','Arenales 1938 3''A''',NULL,'Auckland  ',NULL,NULL,'New Zealand',5056,'110000.00');

--

--Data for the table productorder */

insert  into productorder(orderNumber,orderDate,requiredDate,shippedDate,status,comments,customerNumber) values 


(510120,'2013-04-29','2013-05-08','2013-05-01','Shipped',NULL,5114),

(510125,'2013-05-21','2013-05-27','2013-05-24','Shipped',NULL,5114),

(510138,'2013-07-07','2013-06-16','2013-07-13','Shipped',NULL,5496),

(510139,'2013-07-16','2013-07-23','2013-07-21','Shipped',NULL,5282),



(510152,'2013-09-25','2013-10-03','2013-10-01','Shipped',NULL,5333),

(510169,'2013-11-04','2013-11-14','2013-11-09','Shipped',NULL,5276),
(510174,'2013-11-06','2013-11-15','2013-11-10','Shipped',NULL,5333),

(510202,'2013-12-02','2013-12-09','2013-12-06','Shipped',NULL,5357),

(510265,'2014-07-02','2014-07-09','2014-07-07','Shipped',NULL,5471),
(510347,'2014-11-29','2014-12-07','2014-11-30','Shipped','Can we deliver the new Ford Mustang models by end-of-quarter?',5114),

(510370,'2015-01-20','2015-01-01','2015-01-25','Shipped',NULL,5276),
(510391,'2015-03-09','2015-03-20','2015-03-15','Shipped',NULL,5276),

(510399,'2015-04-01','2015-04-12','2015-04-03','Shipped',NULL,5496),

(510410,'2015-04-29',NULL,'2015-04-30','Shipped',NULL,5357),

(510415,'2015-05-09','2015-05-20','2015-05-12','Disputed','Customer claims the scales of the models don''t match what was discussed. I keep all the paperwork though to prove otherwise',5471),



(510418,'2015-05-16','2015-05-24',Null,'Shipped',NULL,5412),

(510420,'2015-05-29','2015-06-07',NULL,'In Process',NULL,5282);





--Data for the table productline */

insert  into productline(productLine,textDescription,htmlDescription, pimage) values 

('Classic Cars','Attention car enthusiasts: Make your wildest car ownership dreams come true. Whether you are looking for classic muscle cars, dream sports cars or movie-inspired miniatures, you will find great choices in this category. These replicas feature superb attention to detail and craftsmanship and offer features such as working steering system, opening forward compartment, opening rear trunk with removable spare wheel, 4-wheel independent spring suspension, and so on. The models range in size from 1:10 to 1:24 scale and include numerous limited edition and several out-of-production vehicles. All models include a certificate of authenticity from their manufacturers and come fully assembled and ready for display in the home or office.',NULL,NULL),

('Motorcycles','Our motorcycles are state of the art replicas of classic as well as contemporary motorcycle legends such as Harley Davidson, Ducati and Vespa. Models contain stunning details such as official logos, rotating wheels, working kickstand, front suspension, gear-shift lever, footbrake lever, and drive chain. Materials used include diecast and plastic. The models range in size from 1:10 to 1:50 scale and include numerous limited edition and several out-of-production vehicles. All models come fully assembled and ready for display in the home or office. Most include a certificate of authenticity.',NULL,NULL),

('Planes','Unique, diecast airplane and helicopter replicas suitable for collections, as well as home, office or classroom decorations. Models contain stunning details such as official logos and insignias, rotating jet engines and propellers, retractable wheels, and so on. Most come fully assembled and with a certificate of authenticity from their manufacturers.',NULL,NULL),

('Ships','The perfect holiday or anniversary gift for executives, clients, friends, and family. These handcrafted model ships are unique, stunning works of art that will be treasured for generations! They come fully assembled and ready for display in the home or office. We guarantee the highest quality, and best value.',NULL,NULL),

('Trains','Model trains are a rewarding hobby for enthusiasts of all ages. Whether you''re looking for collectible wooden trains, electric streetcars or locomotives, you''ll find a number of great choices for any budget within this category. The interactive aspect of trains makes toy trains perfect for young children. The wooden train sets are ideal for children under the age of 5.',NULL,NULL),

('Trucks and Buses','The Truck and Bus models are realistic replicas of buses and specialized trucks produced from the early 1920s to present. The models range in size from 1:12 to 1:50 scale and include numerous limited edition and several out-of-production vehicles. Materials used include tin, diecast and plastic. All models include a certificate of authenticity from their manufacturers and are a perfect ornament for the home and office.',NULL,NULL),

('Vintage Cars','Our Vintage Car models realistically portray automobiles produced from the early 1900s through the 1940s. Materials used include Bakelite, diecast, plastic and wood. Most of the replicas are in the 1:18 and 1:24 scale sizes, which provide the optimum in detail and accuracy. Prices range from $30.00 up to $180.00 for some special limited edition replicas. All models include a certificate of authenticity from their manufacturers and come fully assembled and ready for display in the home or office.',NULL,NULL);




--Data for the table product */

insert  into product(productCode,productName,productLine,productscale,productVendor,productDescription,quantityInStock,buyPrice,MSRP) values 

('S10_1678','1969 Harley Davidson Ultimate Chopper','Motorcycles','1:10','Min Lin Diecast','This replica features working kickstand, front suspension, gear-shift lever, footbrake lever, drive chain, wheels and steering. All parts are particularly delicate due to their precise scale and require special care and attention.',7933,'48.81','95.70'),

('S10_1949','1952 Alpine Renault 1300','Classic Cars','1:10','Classic Metal Creations','Turnable front wheels; steering function; detailed interior; detailed engine; opening hood; opening trunk; opening doors; and detailed chassis.',7305,'98.58','214.30'),

('S10_2016','1996 Moto Guzzi 1100i','Motorcycles','1:10','Highway 66 Mini Classics','Official Moto Guzzi logos and insignias, saddle bags located on side of motorcycle, detailed engine, working steering, working suspension, two leather seats, luggage rack, dual exhaust pipes, small saddle bag located on handle bars, two-tone paint with chrome accents, superior die-cast detail , rotating wheels , working kick stand, diecast metal with plastic parts and baked enamel finish.',6625,'68.99','118.94'),

('S10_4698','2003 Harley-Davidson Eagle Drag Bike','Motorcycles','1:10','Red Start Diecast','Model features, official Harley Davidson logos and insignias, detachable rear wheelie bar, heavy diecast metal with resin parts, authentic multi-color tampo-printed graphics, separate engine drive belts, free-turning front fork, rotating tires and rear racing slick, certificate of authenticity, detailed engine, display stand\r\n, precision diecast replica, baked enamel finish, 1:10 scale model, removable fender, seat and tank cover piece for displaying the superior detail of the v-twin engine',5582,'91.02','193.66'),

('S10_4757','1972 Alfa Romeo GTA','Classic Cars','1:10','Motor City Art Classics','Features include: Turnable front wheels; steering function; detailed interior; detailed engine; opening hood; opening trunk; opening doors; and detailed chassis.',3252,'85.68','136.00'),

('S10_4962','1962 LanciaA Delta 16V','Classic Cars','1:10','Second Gear Diecast','Features include: Turnable front wheels; steering function; detailed interior; detailed engine; opening hood; opening trunk; opening doors; and detailed chassis.',6791,'103.42','147.74'),

('S12_1099','1968 Ford Mustang','Classic Cars','1:12','Autoart Studio Design','Hood, doors and trunk all open to reveal highly detailed interior features. Steering wheel actually turns the front wheels. Color dark green.',68,'95.34','194.57'),

('S12_1108','2001 Ferrari Enzo','Classic Cars','1:12','Second Gear Diecast','Turnable front wheels; steering function; detailed interior; detailed engine; opening hood; opening trunk; opening doors; and detailed chassis.',3619,'95.59','207.80'),

('S12_1666','1958 Setra Bus','Trucks and Buses','1:12','Welly Diecast Productions','Model features 30 windows, skylights & glare resistant glass, working steering system, original logos',1579,'77.90','-136.67'),

('S12_2823','2002 Suzuki XREO','Motorcycles','1:12','Unimax Art Galleries','Official logos and insignias, saddle bags located on side of motorcycle, detailed engine, working steering, working suspension, two leather seats, luggage rack, dual exhaust pipes, small saddle bag located on handle bars, two-tone paint with chrome accents, superior die-cast detail , rotating wheels , working kick stand, diecast metal with plastic parts and baked enamel finish.',9997,'66.27','150.62'),

('S12_3148','1969 Corvair Monza','Classic Cars','1:18','Welly Diecast Productions','1:18 scale die-cast about 10\" long doors open, hood opens, trunk opens and wheels roll',6906,'89.14','151.08'),

('S12_3380','1968 Dodge Charger','Classic Cars','1:12','Welly Diecast Productions','1:12 scale model of a 1968 Dodge Charger. Hood, doors and trunk all open to reveal highly detailed interior features. Steering wheel actually turns the front wheels. Color black',9123,'75.16','117.44'),

('S12_3891','1969 Ford Falcon','Classic Cars','1:12','Second Gear Diecast','Turnable front wheels; steering function; detailed interior; detailed engine; opening hood; opening trunk; opening doors; and detailed chassis.',1049,'83.05','173.02'),

('S12_3990','1970 Plymouth Hemi Cuda','Classic Cars','1:12','Studio M Art Models','Very detailed 1970 Plymouth Cuda model in 1:12 scale. The Cuda is generally accepted as one of the fastest original muscle cars from the 1970s. This model is a reproduction of one of the orginal 652 cars built in 1970. Red color.',5663,'31.92','79.80'),

('S12_4473','1957 Chevy Pickup','Trucks and Buses','1:12','Exoto Designs','1:12 scale die-cast about 20\" long Hood opens, Rubber wheels',6125,'-55.70','118.50'),

('S12_4675','1969 Dodge Charger','Classic Cars','1:12','Welly Diecast Productions','Detailed model of the 1969 Dodge Charger. This model includes finely detailed interior and exterior features. Painted in red and white.',7323,'58.73','115.16'),

('S18_1097','1940 Ford Pickup Truck','Trucks and Buses','1:18','Studio M Art Models','This model features soft rubber tires, working steering, rubber mud guards, authentic Ford logos, detailed undercarriage, opening doors and hood,  removable split rear gate, full size spare mounted in bed, detailed interior with opening glove box',2613,'58.33','116.67'),

('S18_1129','1993 Mazda RX-7','Classic Cars','1:18','Highway 66 Mini Classics','This model features, opening hood, opening doors, detailed engine, rear spoiler, opening trunk, working steering, tinted windows, baked enamel finish. Color red.',3975,'83.51','141.54'),

('S18_1342','1937 Lincoln Berline','Vintage Cars','1:18','Motor City Art Classics','Features opening engine cover, doors, trunk, and fuel filler cap. Color black',8693,'60.62','102.74'),

('S18_1367','1936 Mercedes-Benz 500K Special Roadster','Vintage Cars','1:18','Studio M Art Models','This 1:18 scale replica is constructed of heavy die-cast metal and has all the features of the original: working doors and rumble seat, independent spring suspension, detailed interior, working steering system, and a bifold hood that reveals an engine so accurate that it even includes the wiring. All this is topped off with a baked enamel finish. Color white.',8635,'24.26','53.91'),

('S18_1589','1965 Aston Martin DB5','Classic Cars','1:18','Classic Metal Creations','Die-cast model of the silver 1965 Aston Martin DB5 in silver. This model includes full wire wheels and doors that open with fully detailed passenger compartment. In 1:18 scale, this model measures approximately 10 inches/20 cm long.',9042,'65.96','124.44'),

('S18_1662','1980s Black Hawk Helicopter','Planes','1:18','Red Start Diecast','1:18 scale replica of actual Army''s UH-60L BLACK HAWK Helicopter. 100% hand-assembled. Features rotating rotor blades, propeller blades and rubber wheels.',5330,'77.27','157.69'),

('S18_1749','1917 Grand Touring Sedan','Vintage Cars','1:18','Welly Diecast Productions','This 1:18 scale replica of the 1917 Grand Touring car has all the features you would expect from museum quality reproductions: all four doors and bi-fold hood opening, detailed engine and instrument panel, chrome-look trim, and tufted upholstery, all topped off with a factory baked-enamel finish.',2724,'86.70','170.00'),

('S18_1889','1948 Porsche 356-A Roadster','Classic Cars','1:18','Gearbox Collectibles','This precision die-cast replica features opening doors, superb detail and craftsmanship, working steering system, opening forward compartment, opening rear trunk with removable spare, 4 wheel independent spring suspension as well as factory baked enamel finish.',8826,'53.90','77.00'),

('S18_1984','1995 Honda Civic','Classic Cars','1:18','Min Lin Diecast','This model features, opening hood, opening doors, detailed engine, rear spoiler, opening trunk, working steering, tinted windows, baked enamel finish. Color yellow.',9772,'93.89','142.25'),

('S18_2238','1998 Chrysler Plymouth Prowler','Classic Cars','1:18','Gearbox Collectibles','Turnable front wheels; steering function; detailed interior; detailed engine; opening hood; opening trunk; opening doors; and detailed chassis.',4724,'101.51','163.73'),

('S18_2248','1911 Ford Town Car','Vintage Cars','1:18','Motor City Art Classics','Features opening hood, opening doors, opening trunk, wide white wall tires, front door arm rests, working steering system.',540,'33.30','60.54'),

('S18_2319','1964 Mercedes Tour Bus','Trucks and Buses','1:18','Unimax Art Galleries','Exact replica. 100+ parts. working steering system, original logos',8258,'74.86','122.73'),

('S18_2325','1932 Model A Ford J-Coupe','Vintage Cars','1:18','Autoart Studio Design','This model features grille-mounted chrome horn, lift-up louvered hood, fold-down rumble seat, working steering system, chrome-covered spare, opening doors, detailed and wired engine',9354,'58.48','127.13'),

('S18_2432','1926 Ford Fire Engine','Trucks and Buses','1:18','Carousel DieCast Legends','Gleaming red handsome appearance. Everything is here the fire hoses, ladder, axes, bells, lanterns, ready to fight any inferno.',2018,'24.92','60.77'),

('S18_2581','P-51-D Mustang','Planes','1:72','Gearbox Collectibles','Has retractable wheels and comes with a stand',992,'49.00','84.48'),

('S18_2625','1936 Harley Davidson El Knucklehead','Motorcycles','1:18','Welly Diecast Productions','Intricately detailed with chrome accents and trim, official die-struck logos and baked enamel finish.',4357,'24.23','60.57'),

('S18_2795','1928 Mercedes-Benz SSK','Vintage Cars','1:18','Gearbox Collectibles','This 1:18 replica features grille-mounted chrome horn, lift-up louvered hood, fold-down rumble seat, working steering system, chrome-covered spare, opening doors, detailed and wired engine. Color black.',548,'72.56','168.75'),

('S18_2870','1999 Indy 500 Monte Carlo SS','Classic Cars','1:18','Red Start Diecast','Features include opening and closing doors. Color: Red',8164,'56.76','132.00'),

('S18_2949','1913 Ford Model T Speedster','Vintage Cars','1:18','Carousel DieCast Legends','This 250 part reproduction includes moving handbrakes, clutch, throttle and foot pedals, squeezable horn, detailed wired engine, removable water, gas, and oil cans, pivoting monocle windshield, all topped with a baked enamel red finish. Each replica comes with an Owners Title and Certificate of Authenticity. Color red.',4189,'60.78','101.31'),

('S18_2957','1934 Ford V8 Coupe','Vintage Cars','1:18','Min Lin Diecast','Chrome Trim, Chrome Grille, Opening Hood, Opening Doors, Opening Trunk, Detailed Engine, Working Steering System',5649,'34.35','62.46'),

('S18_3029','1999 Yamaha Speed Boat','Ships','1:18','Min Lin Diecast','Exact replica. Wood and Metal. Many extras including rigging, long boats, pilot house, anchors, etc. Comes with three masts, all square-rigged.',4259,'51.61','86.02'),

('S18_3136','18th Century Vintage Horse Carriage','Vintage Cars','1:18','Red Start Diecast','Hand crafted diecast-like metal horse carriage is re-created in about 1:18 scale of antique horse carriage. This antique style metal Stagecoach is all hand-assembled with many different parts.\r\n\r\nThis collectible metal horse carriage is painted in classic Red, and features turning steering wheel and is entirely hand-finished.',5992,'60.74','104.72'),

('S18_3140','1903 Ford Model A','Vintage Cars','1:18','Unimax Art Galleries','Features opening trunk,  working steering system',3913,'68.30','136.59'),

('S18_3232','1992 Ferrari 360 Spider red','Classic Cars','1:18','Unimax Art Galleries','his replica features opening doors, superb detail and craftsmanship, working steering system, opening forward compartment, opening rear trunk with removable spare, 4 wheel independent spring suspension as well as factory baked enamel finish.',8347,'77.90','169.34'),

('S18_3233','1985 Toyota Supra','Classic Cars','1:18','Highway 66 Mini Classics','This model features soft rubber tires, working steering, rubber mud guards, authentic Ford logos, detailed undercarriage, opening doors and hood, removable split rear gate, full size spare mounted in bed, detailed interior with opening glove box',7733,'57.01','107.57'),

('S18_3259','Collectable Wooden Train','Trains','1:18','Carousel DieCast Legends','Hand crafted wooden toy train set is in about 1:18 scale, 25 inches in total length including 2 additional carts, of actual vintage train. This antique style wooden toy train model set is all hand-assembled with 100% wood.',6450,'67.56','100.84'),

('S18_3278','1969 Dodge Super Bee','Classic Cars','1:18','Min Lin Diecast','This replica features opening doors, superb detail and craftsmanship, working steering system, opening forward compartment, opening rear trunk with removable spare, 4 wheel independent spring suspension as well as factory baked enamel finish.',1917,'49.05','80.41'),

('S18_3320','1917 Maxwell Touring Car','Vintage Cars','1:18','Exoto Designs','Features Gold Trim, Full Size Spare Tire, Chrome Trim, Chrome Grille, Opening Hood, Opening Doors, Opening Trunk, Detailed Engine, Working Steering System',7913,'57.54','99.21'),

('S18_3482','1976 Ford Gran Torino','Classic Cars','1:18','Gearbox Collectibles','Highly detailed 1976 Ford Gran Torino \"Starsky and Hutch\" diecast model. Very well constructed and painted in red and white patterns.',9127,'73.49','146.99'),

('S18_3685','1948 Porsche Type 356 Roadster','Classic Cars','1:18','Gearbox Collectibles','This model features working front and rear suspension on accurately replicated and actuating shock absorbers as well as opening engine cover, rear stabilizer flap,  and 4 opening doors.',8990,'62.16','141.28'),

('S18_3782','1957 Vespa GS150','Motorcycles','1:18','Studio M Art Models','Features rotating wheels , working kick stand. Comes with stand.',7689,'32.95','62.17'),

('S18_3856','1941 Chevrolet Special Deluxe Cabriolet','Vintage Cars','1:18','Exoto Designs','Features opening hood, opening doors, opening trunk, wide white wall tires, front door arm rests, working steering system, leather upholstery. Color black.',2378,'64.58','105.87'),

('S18_4027','1970 Triumph Spitfire','Classic Cars','1:18','Min Lin Diecast','Features include opening and closing doors. Color: White.',5545,'91.92','143.62'),

('S18_4409','1932 Alfa Romeo 8C2300 Spider Sport','Vintage Cars','1:18','Exoto Designs','This 1:18 scale precision die cast replica features the 6 front headlights of the original, plus a detailed version of the 142 horsepower straight 8 engine, dual spares and their famous comprehensive dashboard. Color black.',6553,'43.26','92.03'),

('S18_4522','1904 Buick Runabout','Vintage Cars','1:18','Exoto Designs','Features opening trunk,  working steering system',8290,'52.66','87.77'),

('S18_4600','1940s Ford truck','Trucks and Buses','1:18','Motor City Art Classics','This 1940s Ford Pick-Up truck is re-created in 1:18 scale of original 1940s Ford truck. This antique style metal 1940s Ford Flatbed truck is all hand-assembled. This collectible 1940''s Pick-Up truck is painted in classic dark green color, and features rotating wheels.',3128,'84.76','121.08'),

('S18_4668','1939 Cadillac Limousine','Vintage Cars','1:18','Studio M Art Models','Features completely detailed interior including Velvet flocked drapes,deluxe wood grain floor, and a wood grain casket with seperate chrome handles',6645,'23.14','50.31'),

('S18_4721','1957 Corvette Convertible','Classic Cars','1:18','Classic Metal Creations','1957 die cast Corvette Convertible in Roman Red with white sides and whitewall tires. 1:18 scale quality die-cast with detailed engine and underbvody. Now you can own The Classic Corvette.',1249,'69.93','148.80'),

('S18_4933','1957 Ford Thunderbird','Classic Cars','1:18','Studio M Art Models','This 1:18 scale precision die-cast replica, with its optional porthole hardtop and factory baked-enamel Thunderbird Bronze finish, is a 100% accurate rendition of this American classic.',3209,'34.21','71.27'),

('S24_1046','1970 Chevy Chevelle SS 454','Classic Cars','1:24','Unimax Art Galleries','This model features rotating wheels, working streering system and opening doors. All parts are particularly delicate due to their precise scale and require special care and attention. It should not be picked up by the doors, roof, hood or trunk.',1005,'49.24','73.49'),

('S24_1444','1970 Dodge Coronet','Classic Cars','1:24','Highway 66 Mini Classics','1:24 scale die-cast about 18\" long doors open, hood opens and rubber wheels',4074,'32.37','57.80'),

('S24_1578','1997 BMW R 1100 S','Motorcycles','1:24','Autoart Studio Design','Detailed scale replica with working suspension and constructed from over 70 parts',7003,'60.86','112.70'),

('S24_1628','1966 Shelby Cobra 427 S/C','Classic Cars','1:24','Carousel DieCast Legends','This diecast model of the 1966 Shelby Cobra 427 S/C includes many authentic details and operating parts. The 1:24 scale model of this iconic lighweight sports car from the 1960s comes in silver and it''s own display case.',8197,'29.18','50.31'),

('S24_1785','1928 British Royal Navy Airplane','Planes','1:24','Classic Metal Creations','Official logos and insignias',3627,'66.74','109.42'),

('S24_1937','1939 Chevrolet Deluxe Coupe','Vintage Cars','1:24','Motor City Art Classics','This 1:24 scale die-cast replica of the 1939 Chevrolet Deluxe Coupe has the same classy look as the original. Features opening trunk, hood and doors and a showroom quality baked enamel finish.',7332,'22.57','33.19'),

('S24_2000','1960 BSA Gold Star DBD34','Motorcycles','1:24','Highway 66 Mini Classics','Detailed scale replica with working suspension and constructed from over 70 parts',15,'37.32','76.17'),

('S24_2011','18th century schooner','Ships','1:24','Carousel DieCast Legends','All wood with canvas sails. Many extras including rigging, long boats, pilot house, anchors, etc. Comes with 4 masts, all square-rigged.',1898,'82.34','122.89'),

('S24_2022','1938 Cadillac V-16 Presidential Limousine','Vintage Cars','1:24','Classic Metal Creations','This 1:24 scale precision die cast replica of the 1938 Cadillac V-16 Presidential Limousine has all the details of the original, from the flags on the front to an opening back seat compartment complete with telephone and rifle. Features factory baked-enamel black finish, hood goddess ornament, working jump seats.',2847,'20.61','44.80'),

('S24_2300','1962 Volkswagen Microbus','Trucks and Buses','1:24','Autoart Studio Design','This 1:18 scale die cast replica of the 1962 Microbus is loaded with features: A working steering system, opening front doors and tailgate, and famous two-tone factory baked enamel finish, are all topped of by the sliding, real fabric, sunroof.',2327,'61.34','127.79'),

('S24_2360','1982 Ducati 900 Monster','Motorcycles','1:24','Highway 66 Mini Classics','Features two-tone paint with chrome accents, superior die-cast detail , rotating wheels , working kick stand',6840,'47.10','69.26'),

('S24_2766','1949 Jaguar XK 120','Classic Cars','1:24','Classic Metal Creations','Precision-engineered from original Jaguar specification in perfect scale ratio. Features opening doors, superb detail and craftsmanship, working steering system, opening forward compartment, opening rear trunk with removable spare, 4 wheel independent spring suspension as well as factory baked enamel finish.',2350,'47.25','90.87'),

('S24_2840','1958 Chevy Corvette Limited Edition','Classic Cars','1:24','Carousel DieCast Legends','The operating parts of this 1958 Chevy Corvette Limited Edition are particularly delicate due to their precise scale and require special care and attention. Features rotating wheels, working streering, opening doors and trunk. Color dark green.',2542,'15.91','35.36'),

('S24_2841','1900s Vintage Bi-Plane','Planes','1:24','Autoart Studio Design','Hand crafted diecast-like metal bi-plane is re-created in about 1:24 scale of antique pioneer airplane. All hand-assembled with many different parts. Hand-painted in classic yellow and features correct markings of original airplane.',5942,'34.25','68.51'),

('S24_2887','1952 Citroen-15CV','Classic Cars','1:24','Exoto Designs','Precision crafted hand-assembled 1:18 scale reproduction of the 1952 15CV, with its independent spring suspension, working steering system, opening doors and hood, detailed engine and instrument panel, all topped of with a factory fresh baked enamel finish.',1452,'72.82','117.44'),

('S24_2972','1982 Lamborghini Diablo','Classic Cars','1:24','Second Gear Diecast','This replica features opening doors, superb detail and craftsmanship, working steering system, opening forward compartment, opening rear trunk with removable spare, 4 wheel independent spring suspension as well as factory baked enamel finish.',7723,'16.24','37.76'),

('S24_3151','1912 Ford Model T Delivery Wagon','Vintage Cars','1:24','Min Lin Diecast','This model features chrome trim and grille, opening hood, opening doors, opening trunk, detailed engine, working steering system. Color white.',9173,'46.91','88.51'),

('S24_3191','1969 Chevrolet Camaro Z28','Classic Cars','1:24','Exoto Designs','1969 Z/28 Chevy Camaro 1:24 scale replica. The operating parts of this limited edition 1:24 scale diecast model car 1969 Chevy Camaro Z28- hood, trunk, wheels, streering, suspension and doors- are particularly delicate due to their precise scale and require special care and attention.',4695,'50.51','85.61'),

('S24_3371','1971 Alpine Renault 1600s','Classic Cars','1:24','Welly Diecast Productions','This 1971 Alpine Renault 1600s replica Features opening doors, superb detail and craftsmanship, working steering system, opening forward compartment, opening rear trunk with removable spare, 4 wheel independent spring suspension as well as factory baked enamel finish.',7995,'38.58','61.23'),

('S24_3420','1937 Horch 930V Limousine','Vintage Cars','1:24','Autoart Studio Design','Features opening hood, opening doors, opening trunk, wide white wall tires, front door arm rests, working steering system',2902,'26.30','65.75'),

('S24_3432','2002 Chevy Corvette','Classic Cars','1:24','Gearbox Collectibles','The operating parts of this limited edition Diecast 2002 Chevy Corvette 50th Anniversary Pace car Limited Edition are particularly delicate due to their precise scale and require special care and attention. Features rotating wheels, poseable streering, opening doors and trunk.',9446,'62.11','107.08'),

('S24_3816','1940 Ford Delivery Sedan','Vintage Cars','1:24','Carousel DieCast Legends','Chrome Trim, Chrome Grille, Opening Hood, Opening Doors, Opening Trunk, Detailed Engine, Working Steering System. Color black.',6621,'48.64','83.86'),

('S24_3856','1956 Porsche 356A Coupe','Classic Cars','1:18','Classic Metal Creations','Features include: Turnable front wheels; steering function; detailed interior; detailed engine; opening hood; opening trunk; opening doors; and detailed chassis.',6600,'98.30','140.43'),

('S24_3949','Corsair F4U ( Bird Cage)','Planes','1:24','Second Gear Diecast','Has retractable wheels and comes with a stand. Official logos and insignias.',6812,'29.34','68.24'),

('S24_3969','1936 Mercedes Benz 500k Roadster','Vintage Cars','1:24','Red Start Diecast','This model features grille-mounted chrome horn, lift-up louvered hood, fold-down rumble seat, working steering system and rubber wheels. Color black.',2081,'21.75','41.03'),

('S24_4048','1992 Porsche Cayenne Turbo Silver','Classic Cars','1:24','Exoto Designs','This replica features opening doors, superb detail and craftsmanship, working steering system, opening forward compartment, opening rear trunk with removable spare, 4 wheel independent spring suspension as well as factory baked enamel finish.',6582,'69.78','118.28'),

('S24_4258','1936 Chrysler Airflow','Vintage Cars','1:24','Second Gear Diecast','Features opening trunk,  working steering system. Color dark green.',4710,'57.46','97.39'),

('S24_4278','1900s Vintage Tri-Plane','Planes','1:24','Unimax Art Galleries','Hand crafted diecast-like metal Triplane is Re-created in about 1:24 scale of antique pioneer airplane. This antique style metal triplane is all hand-assembled with many different parts.',2756,'36.23','72.45'),

('S24_4620','1961 Chevrolet Impala','Classic Cars','1:18','Classic Metal Creations','This 1:18 scale precision die-cast reproduction of the 1961 Chevrolet Impala has all the features-doors, hood and trunk that open; detailed 409 cubic-inch engine; chrome dashboard and stick shift, two-tone interior; working steering system; all topped of with a factory baked-enamel finish.',7869,'32.33','80.84'),

('S32_1268','1980’s GM Manhattan Express','Trucks and Buses','1:32','Motor City Art Classics','This 1980’s era new look Manhattan express is still active, running from the Bronx to mid-town Manhattan. Has 35 opeining windows and working lights. Needs a battery.',5099,'53.93','96.31'),

('S32_1374','1997 BMW F650 ST','Motorcycles','1:32','Exoto Designs','Features official die-struck logos and baked enamel finish. Comes with stand.',178,'66.92','99.89'),

('S32_2206','1982 Ducati 996 R','Motorcycles','1:32','Gearbox Collectibles','Features rotating wheels , working kick stand. Comes with stand.',9241,'24.14','40.23'),

('S32_2509','1954 Greyhound Scenicruiser','Trucks and Buses','1:32','Classic Metal Creations','Model features bi-level seating, 50 windows, skylights & glare resistant glass, working steering system, original logos',2874,'25.98','54.11'),

('S32_3207','1950''s Chicago Surface Lines Streetcar','Trains','1:32','Gearbox Collectibles','This streetcar is a joy to see. It has 80 separate windows, electric wire guides, detailed interiors with seats, poles and drivers controls, rolling and turning wheel assemblies, plus authentic factory baked-enamel finishes (Green Hornet for Chicago and Cream and Crimson for Boston).',8601,'26.72','62.14'),

('S32_3522','1996 Peterbilt 379 Stake Bed with Outrigger','Trucks and Buses','1:32','Red Start Diecast','This model features, opening doors, detailed engine, working steering, tinted windows, detailed interior, die-struck logos, removable stakes operating outriggers, detachable second trailer, functioning 360-degree self loader, precision molded resin trailer and trim, baked enamel finish on cab',814,'33.61','64.64'),

('S32_4289','1928 Ford Phaeton Deluxe','Vintage Cars','1:32','Highway 66 Mini Classics','This model features grille-mounted chrome horn, lift-up louvered hood, fold-down rumble seat, working steering system',136,'33.02','68.79'),

('S32_4485','1974 Ducati 350 Mk3 Desmo','Motorcycles','1:32','Second Gear Diecast','This model features two-tone paint with chrome accents, superior die-cast detail , rotating wheels , working kick stand',3341,'56.13','102.05'),

('S50_1341','1930 Buick Marquette Phaeton','Vintage Cars','1:50','Studio M Art Models','Features opening trunk,  working steering system',7062,'27.06','43.64'),

('S50_1392','Diamond T620 Semi-Skirted Tanker','Trucks and Buses','1:50','Highway 66 Mini Classics','This limited edition model is licensed and perfectly scaled for Lionel Trains. The Diamond T620 has been produced in solid precision diecast and painted with a fire baked enamel finish. It comes with a removable tanker and is a perfect model to add authenticity to your static train or car layout or to just have on display.',1016,'68.29','115.75'),

('S50_1514','1962 City of Detroit Streetcar','Trains','1:50','Classic Metal Creations','This streetcar is a joy to see. It has 99 separate windows, electric wire guides, detailed interiors with seats, poles and drivers controls, rolling and turning wheel assemblies, plus authentic factory baked-enamel finishes (Green Hornet for Chicago and Cream and Crimson for Boston).',1645,'37.49','58.58'),

('S50_4713','2002 Yamaha YZR M1','Motorcycles','1:50','Autoart Studio Design','Features rotating wheels , working kick stand. Comes with stand.',600,'34.17','81.36'),

('S700_1138','The Schooner Bluenose','Ships','1:700','Autoart Studio Design','All wood with canvas sails. Measures 31 1/2 inches in Length, 22 inches High and 4 3/4 inches Wide. Many extras.\r\nThe schooner Bluenose was built in Nova Scotia in 1921 to fish the rough waters off the coast of Newfoundland. Because of the Bluenose racing prowess she became the pride of all Canadians. Still featured on stamps and the Canadian dime, the Bluenose was lost off Haiti in 1946.',1897,'34.00','66.67'),

('S700_1691','American Airlines: B767-300','Planes','1:700','Min Lin Diecast','Exact replia with official logos and insignias and retractable wheels',5841,'51.15','91.34'),

('S700_1938','The Mayflower','Ships','1:700','Studio M Art Models','Measures 31 1/2 inches Long x 25 1/2 inches High x 10 5/8 inches Wide\r\nAll wood with canvas sail. Extras include long boats, rigging, ladders, railing, anchors, side cannons, hand painted, etc.',737,'43.30','86.61'),

('S700_2047','HMS Bounty','Ships','1:700','Unimax Art Galleries','Measures 30 inches Long x 27 1/2 inches High x 4 3/4 inches Wide. \r\nMany extras including rigging, long boats, pilot house, anchors, etc. Comes with three masts, all square-rigged.',3501,'39.83','90.52'),

('S700_2466','America West Airlines B757-200','Planes','1:700','Motor City Art Classics','Official logos and insignias. Working steering system. Rotating jet engines',9653,'68.80','99.72'),

('S700_2610','The USS Constitution Ship','Ships','1:700','Red Start Diecast','All wood with canvas sails. Measures 31 1/2\" Length x 22 3/8\" High x 8 1/4\" Width. Extras include 4 boats on deck, sea sprite on bow, anchors, copper railing, pilot houses, etc.',7083,'33.97','72.28'),

('S700_2824','1982 Camaro Z28','Classic Cars','1:18','Carousel DieCast Legends','Features include opening and closing doors. Color: White. \r\nMeasures approximately 9 1/2\" Long.',6934,'46.53','101.15'),

('S700_2834','ATA: B757-300','Planes','1:700','Highway 66 Mini Classics','Exact replia with official logos and insignias and retractable wheels',7106,'59.33','118.65'),

('S700_3167','F/A 18 Hornet 1/72','Planes','1:72','Motor City Art Classics','10\" Wingspan with retractable landing gears.Comes with pilot',551,'54.40','80.00'),

('S700_3505','The Titanic','Ships','1:700','Carousel DieCast Legends','Completed model measures 19 1/2 inches long, 9 inches high, 3inches wide and is in barn red/black. All wood and metal.',1956,'51.09','100.17'),

('S700_3962','The Queen Mary','Ships','1:700','Welly Diecast Productions','Exact replica. Wood and Metal. Many extras including rigging, long boats, pilot house, anchors, etc. Comes with three masts, all square-rigged.',5088,'53.63','99.31'),

('S700_4002','American Airlines: MD-11S','Planes','1:700','Second Gear Diecast','Polished finish. Exact replia with official logos and insignias and retractable wheels',8820,'36.27','74.03'),

('S72_1253','Boeing X-32A JSF','Planes','1:72','Motor City Art Classics','10\" Wingspan with retractable landing gears.Comes with pilot',4857,'32.77','49.66'),

('S72_3212','Pont Yacht','Ships','1:72','Unimax Art Galleries','Measures 38 inches Long x 33 3/4 inches High. Includes a stand.\r\nMany extras including rigging, long boats, pilot house, anchors, etc. Comes with 2 masts, all square-rigged',414,'33.30','54.60');



insert  into orderdetail(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber) values 

(510120,'S10_2016',29,'118.94',3),

(510120,'S10_4698',46,'158.80',2),

(510120,'S18_2581',29,'82.79',8),

(510120,'S18_2625',46,'57.54',4),

(510120,'S24_1578',35,'110.45',1),

(510120,'S24_1785',39,'93.01',10),

(510120,'S24_2000',34,'72.36',5),

(510120,'S24_4278',29,'71.73',9),

(510120,'S32_1374',22,'94.90',6),

(510120,'S32_4289',29,'68.79',11),

(510120,'S50_1341',49,'41.46',12),

(510120,'S700_1691',47,'91.34',13),

(510120,'S700_2466',24,'81.77',15),

(510120,'S700_2834',24,'106.79',7),

(510120,'S700_3167',43,'72.00',14);



insert  into orderdetail(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber) values 
(510125,'S18_1342',32,'89.38',1),

(510125,'S18_2795',34,'138.38',2);

insert  into orderdetail(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber) values 

(510138,'S18_1749',33,'149.60',6),

(510138,'S18_2248',22,'51.46',5),

(510138,'S18_2325',38,'114.42',3),

(510138,'S18_4409',47,'79.15',7),

(510138,'S18_4933',23,'64.86',8),

(510138,'S24_1046',45,'59.53',12),

(510138,'S24_1937',22,'33.19',2),

(510138,'S24_2022',33,'38.53',1),

(510138,'S24_2766',28,'73.60',10),

(510138,'S24_2887',30,'96.30',9),

(510138,'S24_3191',49,'77.05',11),

(510138,'S24_3432',21,'99.58',13),

(510138,'S24_3969',29,'32.82',4);

insert  into orderdetail(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber) values 

(510139,'S18_1342',31,'89.38',7),

(510139,'S18_1367',49,'52.83',6),

(510139,'S18_2795',41,'151.88',8),

(510139,'S18_2949',46,'91.18',1),

(510139,'S18_2957',20,'52.47',3),

(510139,'S18_3136',20,'101.58',2),

(510139,'S18_3320',30,'81.35',5),

(510139,'S24_4258',29,'93.49',4);

insert  into orderdetail(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber) values 

(510152,'S18_4027',35,'117.77',1),

(510152,'S24_1444',25,'49.13',4),

(510152,'S24_4048',23,'112.37',3),

(510152,'S32_3207',33,'57.17',2);


insert  into orderdetail(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber) values 


(510169,'S12_1099',30,'163.44',2),

(510169,'S12_2823',35,'126.52',13),

(510169,'S12_3990',36,'71.82',3),

(510169,'S18_3278',32,'65.13',5),

(510169,'S18_3482',36,'136.70',4),

(510169,'S18_3782',38,'52.84',8),

(510169,'S18_4721',33,'120.53',7),

(510169,'S24_2360',38,'66.49',11),

(510169,'S24_3371',34,'53.27',1),

(510169,'S24_4620',24,'77.61',6),

(510169,'S32_2206',26,'37.01',9),

(510169,'S32_4485',34,'83.68',12),

(510169,'S50_4713',48,'75.66',10);

insert  into orderdetail(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber) values 


(510174,'S10_1949',34,'207.87',4),

(510174,'S12_1666',43,'113.44',1),

(510174,'S18_1097',48,'108.50',3),

(510174,'S18_2949',46,'100.30',5),

(510174,'S18_4668',49,'44.27',2);

insert  into orderdetail(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber) values 


(510202,'S18_3782',30,'55.33',3),

(510202,'S18_4721',43,'124.99',2),

(510202,'S24_2360',50,'56.10',6),

(510202,'S24_4620',50,'75.18',1),

(510202,'S32_2206',27,'33.39',4),

(510202,'S32_4485',31,'81.64',7),

(510202,'S50_4713',40,'79.73',5);


insert  into orderdetail(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber) values 


(510265,'S18_3278',45,'74.78',2),

(510265,'S18_3482',49,'123.47',1);
insert  into orderdetail(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber) values 


(510347,'S10_1949',30,'188.58',1),

(510347,'S10_4962',27,'132.97',2),

(510347,'S12_1666',29,'132.57',3),

(510347,'S18_1097',42,'113.17',5),

(510347,'S18_1367',21,'46.36',7),

(510347,'S18_2432',50,'51.05',8),

(510347,'S18_2795',21,'136.69',6),

(510347,'S18_2949',48,'84.09',9),

(510347,'S18_2957',34,'60.59',10),

(510347,'S18_3136',45,'95.30',11),

(510347,'S18_3320',26,'84.33',12),

(510347,'S18_4600',45,'115.03',4);


insert  into orderdetail(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber) values 


(510370,'S10_4962',35,'128.53',4),

(510370,'S12_1666',49,'128.47',8),

(510370,'S18_1097',27,'100.34',1),

(510370,'S18_2319',22,'101.87',5),

(510370,'S18_2432',22,'60.16',7),

(510370,'S18_3232',27,'167.65',9),

(510370,'S18_4600',29,'105.34',6),

(510370,'S18_4668',20,'41.76',2),

(510370,'S32_3522',25,'63.99',3);

insert  into orderdetail(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber) values 


(510391,'S10_1949',24,'195.01',4),

(510391,'S10_4962',37,'121.15',7),

(510391,'S12_1666',39,'110.70',9),

(510391,'S18_1097',29,'114.34',10),

(510391,'S18_1342',35,'102.74',2),

(510391,'S18_1367',42,'47.44',3),

(510391,'S18_2432',44,'57.73',5),

(510391,'S18_2949',32,'99.28',6),

(510391,'S24_1937',33,'26.55',8),

(510391,'S24_2022',24,'36.29',1);

insert  into orderdetail(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber) values 


(510399,'S10_1678',40,'77.52',8),

(510399,'S10_2016',51,'99.91',7),

(510399,'S10_4698',22,'156.86',6),

(510399,'S12_2823',29,'123.51',5),

(510399,'S18_2625',30,'51.48',4),

(510399,'S24_1578',57,'104.81',3),

(510399,'S24_2000',58,'75.41',2),

(510399,'S32_1374',32,'97.89',1);

insert  into orderdetail(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber) values 


(510410,'S18_1342',65,'99.66',7),

(510410,'S18_1367',44,'51.21',6),

(510410,'S18_2795',56,'145.13',8),

(510410,'S18_2949',47,'93.21',1),

(510410,'S18_2957',53,'49.97',3),

(510410,'S18_3136',34,'84.82',2),

(510410,'S18_3320',44,'81.35',5),

(510410,'S24_2022',31,'42.56',9),

(510410,'S24_4258',50,'95.44',4);
insert  into orderdetail(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber) values 


(510415,'S18_3856',51,'86.81',5),

(510415,'S24_2841',21,'60.97',1),

(510415,'S24_3420',18,'59.83',2),

(510415,'S700_2047',32,'73.32',4),

(510415,'S72_1253',42,'43.20',3);


insert  into orderdetail(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber) values 


(510418,'S18_3278',16,'70.76',2),

(510418,'S18_3482',27,'139.64',1),

(510418,'S18_3782',33,'56.57',5),

(510418,'S18_4721',28,'120.53',4),

(510418,'S24_2360',52,'64.41',8),

(510418,'S24_4620',10,'66.29',3),

(510418,'S32_2206',43,'36.61',6),

(510418,'S32_4485',50,'100.01',9),

(510418,'S50_4713',40,'72.41',7);

insert  into orderdetail(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber) values 

(510420,'S18_1749',37,'153.00',5),

(510420,'S18_2248',36,'52.06',4),

(510420,'S18_2325',45,'116.96',2),

(510420,'S18_4409',66,'73.62',6),

(510420,'S18_4933',36,'68.42',7),

(510420,'S24_1046',60,'60.26',11),

(510420,'S24_1628',37,'48.80',13),

(510420,'S24_1937',45,'32.19',1),

(510420,'S24_2766',39,'76.33',9),

(510420,'S24_2887',55,'115.09',8),

(510420,'S24_3191',35,'77.05',10),

(510420,'S24_3432',26,'104.94',12),

(510420,'S24_3969',15,'35.29',3);



insert  into payment(customerNumber,checkNumber,paymentDate,amount) values 

(5114,'GG31455','2013-05-20','45864.03'),

(5114,'MA765515','2014-12-15','82261.22'),

(5114,'NP603840','2013-05-31','7565.08'),

(5114,'NR27552','2014-03-10','44894.74'),

(5276,'EM979878','2015-02-09','27083.78'),

(5276,'KM841847','2013-11-13','38547.19'),

(5276,'LE432182','2013-09-28','41554.73'),

(5276,'OJ819725','2015-04-30','29848.52'),

(5282,'IA793562','2013-08-03','24013.52'),

(5282,'JT819493','2014-08-02','35806.73'),

(5282,'OD327378','2015-01-03','31835.36'),

(5333,'HL209210','2013-11-15','23936.53'),

(5333,'JK479662','2013-10-17','9821.32'),

(5333,'NF959653','2015-03-01','21432.31'),

(5357,'AG240323','2013-12-16','20220.04'),

(5357,'NB291497','2014-05-15','36442.34'),

(5412,'GH197075','2014-07-25','35034.57'),

(5412,'PJ434867','2014-04-14','31670.37'),

(5471,'AB661578','2014-07-28','9415.13'),

(5471,'CO645196','2013-12-10','35505.63'),

(5496,'EU531600','2015-05-25','30253.75'),

(5496,'MB342426','2013-07-16','32077.44'),

(5496,'MN89921','2014-12-31','52166.00');
