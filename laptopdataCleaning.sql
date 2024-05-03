USE datacleaning;

SELECT count(*) FROM laptops;

ALTER TABLE laptops
DROP COLUMN  `Unnamed: 0`;

-- Cheacking Duplicates

SELECT * FROM laptops
WHERE Company IS NULL AND TypeName IS NULL AND Inches IS NULL
AND ScreenResolution IS NULL AND Cpu IS NULL AND Ram IS NULL
AND Memory IS NULL AND Gpu IS NULL AND OpSys IS NULL AND
WEIGHT IS NULL AND Price IS NULL;

ALTER TABLE laptops
MODIFY COLUMN Inches DECIMAL (10,1);

-- Converting Ram column into INT

UPDATE laptops
SET Ram = RELACE(Ram,'GB','');

ALTER TABLE laptops
MODIFY COLUMN Ram INT;

SELECT DISTINCT(Ram) FROM laptops;

SELECT * FROM laptops;

-- Converting  columns into INT/float

SELECT weight FROM laptops;

SELECT weight,REPLACE(weight , 'kg','') from laptops;

UPDATE laptops
SET Weight = REPLACE(weight , 'kg','');

ALTER TABLE laptops
MODIFY COLUMN Weight DECIMAL(10,1);

-- Orgnizing operating system

SELECT DISTINCT(OpSys) FROM laptops;


SELECT OpSys,
	CASE WHEN OpSys LIKE '%windows%' THEN 'Windows'
		WHEN OpSys LIKE '%mac%' THEN 'mac'
		WHEN OpSys= 'Linux' THEN 'Linux'
		WHEN OpSys= 'No OS' THEN 'N/A'
		ELSE 'other'
	END as 'os_brand'
FROM laptops;

UPDATE laptops
SET OpSys = CASE WHEN OpSys LIKE '%windows%' THEN 'Windows'
	WHEN OpSys LIKE '%mac%' THEN 'mac'
    WHEN OpSys= 'Linux' THEN 'Linux'
    WHEN OpSys= 'No OS' THEN 'N/A'
    ELSE 'other'
END;

-- Columns for GPU and popuplate them

ALTER TABLE laptops
ADD COLUMN gpu_brand VARCHAR(255) AFTER Gpu,
ADD COLUMN gpu_name VARCHAR(255) AFTER gpu_brand;

SELECT * FROM laptops;

SELECT substring_INDEX(Gpu, ' ' , 1) FROM laptops;

UPDATE laptops
SET gpu_brand = substring_INDEX(Gpu, ' ' , 1);

SELECT REPLACE(GPU , gpu_brand , '') FROM laptops;

UPDATE laptops
SET gpu_name = REPLACE(GPU , gpu_brand , '');

-- Columns for CPU and popuplate them

ALTER TABLE laptops
ADD COLUMN cpu_brand VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_name VARCHAR(255) AFTER cpu_brand,
ADD COLUMN cpu_speed decimal(10,1) AFTER cpu_name;

SELECT SUBSTRING_INDEX(Cpu, ' ' , 1) FROM laptops;

UPDATE laptops
SET cpu_brand = substring_INDEX(Cpu, ' ' , 1);

SELECT CAST(REPLACE(substring_INDEX(Cpu, ' ' , -1),'GHz','') AS DECIMAL(10,2)) FROM laptops;

UPDATE laptops
SET cpu_speed = CAST(REPLACE(substring_INDEX(Cpu, ' ' , -1),'GHz','') AS DECIMAL(10,2));

SELECT * FROM laptops;

SELECT cpu, REPLACE(REPLACE(cpu, cpu_brand , ''),substring_index(cpu,' ',-1),'') FROM laptops;

UPDATE laptops
SET cpu_name = REPLACE(REPLACE(cpu, cpu_brand , ''),substring_index(cpu,' ',-1),'');

SELECT cpu_name, substring_index(TRIM(cpu_name),' ',2) from laptops;

UPDATE laptops
SET cpu_name = substring_index(TRIM(cpu_name),' ',2);

SELECT * FROM laptops;


-- columns for screen resolution
SELECT ScreenResolution, substring_index(substring_index(ScreenResolution, ' ',-1),'x',1),
substring_index(substring_index(ScreenResolution, ' ',-1),'x',-1) FROM laptops;

ALTER TABLE laptops
ADD COLUMN screen_width VARCHAR(255) AFTER ScreenResolution,
ADD COLUMN screen_height VARCHAR(255) AFTER screen_width;

ALTER TABLE laptops
MODIFY COLUMN screen_width INT;

ALTER TABLE laptops
MODIFY COLUMN screen_height INT;

UPDATE laptops
SET screen_width = substring_index(substring_index(ScreenResolution, ' ',-1),'x',1);

UPDATE laptops
SET screen_height = substring_index(substring_index(ScreenResolution, ' ',-1),'x',-1);

ALTER TABLE laptops
ADD COLUMN touchscreen INT AFTER screen_height;

SELECT ScreenResolution,
	CASE WHEN ScreenResolution LIKE '%touch%' then 1
	ELSE 0
	END
FROM laptops;

UPDATE laptops
SET touchscreen = CASE WHEN ScreenResolution LIKE '%touch%' then 1
						ELSE 0
						END;
                        
SELECT * FROM laptops;

SELECT * FROM laptops
WHERE ScreenResolution like '%IPS%';



-- Memory Columns
SELECT distinct (Memory) from laptops;

SELECT Memory, substring_index(Memory,' ', 1) FROM laptops;

ALTER TABLE laptops
ADD COLUMN memory_type VARCHAR(255) after Memory,
ADD COLUMN primary_storage INT AFTER memory_type,
ADD COLUMN secondary_storage INT AFTER Primary_storage;


SELECT Memory,
CASE 
	WHEN Memory like '%SSD%' Then 'SSD'
	WHEN Memory like '%HDD%' Then 'HDD'
    WHEN Memory like '%SSD%' AND Memory like  '%HDD%' Then 'Hybrid'
	WHEN Memory like '%Flash Storage%' Then 'Flash Storage'
	WHEN Memory like '%Hybrid%' Then 'Hybrid'
	WHEN Memory like '%Flash Storage%' AND Memory like 'Hybrid' Then 'Hybrid'
    ELSE NULL
END AS 'Memory_type'
FROM laptops;


UPDATE laptops
SET Memory_type = CASE 
	WHEN Memory like '%SSD%' Then 'SSD'
	WHEN Memory like '%HDD%' Then 'HDD'
    WHEN Memory like '%SSD%' AND Memory like  '%HDD%' Then 'Hybrid'
	WHEN Memory like '%Flash Storage%' Then 'Flash Storage'
	WHEN Memory like '%Hybrid%' Then 'Hybrid'
	WHEN Memory like '%Flash Storage%' AND Memory like 'Hybrid' Then 'Hybrid'
    ELSE NULL
END;
SELECT * FROM laptops;

SELECT Memory ,REGEXP_substr(substring_index(Memory , '+' , 1),'[0-9]+'),
case
WHEN MEmory Like '%+%' then REGEXP_substr(substring_index(Memory , '+' , -1) , '[0-9]+')
ELSE 0
END
FROM laptops;  

UPDATE laptops
SET primary_storage = REGEXP_substr(substring_index(Memory , '+' , 1),'[0-9]+'),
secondary_storage= case
WHEN MEmory Like '%+%' then REGEXP_substr(substring_index(Memory , '+' , -1) , '[0-9]+')
ELSE 0
END;

SELECT primary_storage,
CASE WHEN primary_storage <=2 THEN primary_storage *1024
ELSE primary_storage
END
FROM laptops;

SELECT secondary_storage,
CASE WHEN secondary_storage <= 2 THEN secondary_storage *1024
ELSE secondary_storage
END
FROM laptops;

UPDATE laptops
SET primary_storage = CASE WHEN primary_storage <=2 THEN primary_storage *1024
ELSE primary_storage
END,
secondary_storage = CASE WHEN secondary_storage <= 2 THEN secondary_storage *1024
ELSE secondary_storage
END;

SELECT * FROM laptops;

-- Dropping all the unnecessary columns after DAta cleaning

ALTER TABLE laptops
DROP column ScreenResolution,
DROP column Cpu,
DROP column Memory,
DROP column Gpu;

-- Final Table

SELECT * FROM laptops;