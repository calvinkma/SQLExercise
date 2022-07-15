-- 10.1 Join table PEOPLE and ADDRESS, but keep only one address information for each person (we don't mind which record we take for each person). 
    -- i.e., the joined table should have the same number of rows as table PEOPLE

SELECT * FROM PEOPLE LEFT JOIN (
	SELECT id AS t_id, max(address) AS t_addr FROM ADDRESS GROUP BY id
) ON PEOPLE.id==t_id;

-- 10.2 Join table PEOPLE and ADDRESS, but ONLY keep the LATEST address information for each person. 
    -- i.e., the joined table should have the same number of rows as table PEOPLE
SELECT * FROM PEOPLE LEFT JOIN (
	SELECT id AS t_id, address, max(updatedate) FROM ADDRESS GROUP BY id
) ON PEOPLE.id==t_id;