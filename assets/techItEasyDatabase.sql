
CREATE TABLE product (
    id serial PRIMARY KEY, 
    name VARCHAR(255),    
    brand VARCHAR(255),  
    price double precision,
    currentStock integer, 
    sold integer         
);


CREATE TABLE TV (
    type VARCHAR(255),
    available double precision,
    refreshRate integer,
    screenType VARCHAR(255)
) INHERITS (product);

CREATE TABLE RemoteController (
    compatibleWith VARCHAR(255), 
    barraryType VARCHAR(255)  
) INHERITS (product);

INSERT INTO TV (name, brand, price, currentStock, sold, type, available, refreshRate, screenType)
         VALUES ('TV Model 1', 'Samsung', 499.99, 10, 2, 'QLED', 42.5, 120, 'QLED'),
                ('TV Model 2', 'LG', 599.99, 8, 3, 'OLED', 55.0, 60, 'OLED'),
				('TV Model 3', 'Philips', 799.99, 12, 4, 'LCD', 65.5, 240, 'LCD');
				
				

INSERT INTO RemoteController (name, brand, price, currentStock, sold, compatibleWith, barraryType)
VALUES ('Remote Model 1', 'Brand X', 29.99, 20, 5, 'TV Model A', 'Type A'),
       ('Remote Model 2', 'Brand Y', 19.99, 15, 3, 'TV Model B', 'Type B'),
       ('Remote Model 3', 'Brand Z', 24.99, 25, 8, 'TV Model C', 'Type C');
	   
	   
	   
UPDATE remotecontroller SET brand='SAMSUNG' WHERE id=4;
UPDATE remotecontroller SET brand='LG' WHERE id=5;
UPDATE remotecontroller SET brand='Philips' WHERE id=6;

-- add new culomn in de table
ALTER TABLE tv
ADD COLUMN remoteControllerId integer;

ALTER TABLE tv
ADD CONSTRAINT id UNIQUE (id);

ALTER TABLE remotecontroller
ADD COLUMN tvId  integer;

ALTER TABLE tv
ADD CONSTRAINT unique_tv_id UNIQUE (id);

ALTER TABLE remotecontroller
ADD CONSTRAINT fk_tv FOREIGN KEY (tvId) REFERENCES TV(id);

ALTER TABLE remotecontroller
ADD CONSTRAINT unique_remotecontroller_id UNIQUE (id);
	
ALTER TABLE tv
ADD CONSTRAINT fk_remotecontroller FOREIGN KEY (remoteControllerId) REFERENCES remotecontroller(id);

UPDATE tv SET remoteControllerId=4 WHERE id=1;
UPDATE tv SET remoteControllerId=5 WHERE id=2;
UPDATE tv SET remoteControllerId=6 WHERE id=3;

UPDATE remotecontroller SET tvId=1 WHERE id=4;
UPDATE remotecontroller SET tvId=2 WHERE id=5;
UPDATE remotecontroller SET tvId=3 WHERE id=6;

ALTER TABLE tv
DROP COLUMN remoteControllerId;

-- hier kan de tv van Samsung niet verwijderen omdat deze tv wordt gebruikt in remoteconroller table als Foreign Key,
-- maar als de id van tv maar niet gekoppeld is dan mag het verwijdered worden.
-- om deze op te lossen moet je eerste de remotecontroller record verwijderen die de id van Samsung gebruikt dan kan je de tv van Samsung verwijderen!.
-- maar stel maar dat de tv table ook kolom heeft van remotecontroller id als Foreign Key ook, dan het is lastig te record te verwijderen als het gekoppeld aan elkaar.
-- want de tv table zal zeggen verwijder de tvID in de remotecontroller table eerste dan kan je de tv record verwijderen.
-- en ook het zelfde van remotecontroller table zal zeggen verwijder maar eerste de remoteID in de tv table dan kan je de remoete record verwijderen.
-- hier hebben we een tussen table nodig en kolomen en andere table's zijn niet meer nodig en de reden ook van tussen table als meer op mmer soort relatie nodig hebben.
DELETE FROM tv WHERE brand = 'Samsung';


CREATE TABLE wallbrackets (
	size text,
	adjustable boolean NOT NULL
)INHERITS (product);

INSERT INTO wallbrackets (name, brand, price, currentStock, sold, size, adjustable)
VALUES ('Wall Bracket Model 1', 'BlueBuilt', 29.99, 50, 10, 'Small', true),
       ('Wall Bracket Model 2', 'Vogel', 39.99, 40, 8, 'Medium', false),
	   ('Wall Bracket Model 3', 'wandmontage', 49.99, 30, 6, 'Large', true);
	   
	   
CREATE TABLE TV_WallBracket(
	tvId integer,
	wallBracketId integer,
	CONSTRAINT  pk_tv_wallbracket PRIMARY KEY (tvId, wallBracketId),
	CONSTRAINT fk_tv FOREIGN KEY (tvId) REFERENCES TV(id),
	CONSTRAINT fk_wallbrackets FOREIGN KEY (wallBracketId) REFERENCES wallbrackets(id)
);

ALTER TABLE wallbrackets
ADD CONSTRAINT unique_wallbrackets_id UNIQUE (id);

INSERT INTO tv_wallbracket (tvId, wallBracketId)
VALUES ((SELECT id FROM tv WHERE brand = 'Samsung'), (SELECT id FROM wallbrackets WHERE size = 'Small')),
       ((SELECT id FROM tv WHERE brand = 'LG'), (SELECT id FROM wallbrackets WHERE size = 'Medium')),
	   ((SELECT id FROM tv WHERE brand = 'Philips'), (SELECT id FROM wallbrackets WHERE size = 'Large'));


