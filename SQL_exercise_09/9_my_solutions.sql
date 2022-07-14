-- 9.1 give the total number of recordings in this table
SELECT count(*) FROM Logs;

-- 9.2 the number of packages listed in this table?
SELECT count(DISTINCT package) FROM Logs;

-- 9.3 How many times the package "Rcpp" was downloaded?
SELECT count(*) FROM Logs WHERE package=="Rcpp";

-- 9.4 How many recordings are from China ("CN")?
SELECT count(*) FROM Logs WHERE country=="CN";

-- 9.5 Give the package name and how many times they're downloaded. Order by the 2nd column descently.
SELECT package, count(*) AS C FROM Logs GROUP BY package ORDER BY C DESC;

-- 9.6 Give the package ranking (based on how many times it was downloaded) during 9AM to 11AM
SELECT package, count(*) AS C FROM Logs 
WHERE time BETWEEN "09:00:00" AND "11:00:00"
GROUP BY package ORDER BY C DESC;

-- 9.7 How many recordings are from China ("CN") or Japan("JP") or Singapore ("SG")?
SELECT count(*) FROM Logs WHERE country IN ("CN", "JP", "SG");

-- 9.8 Print the countries whose downloaded are more than the downloads from China ("CN")
SELECT T.country FROM (
	SELECT country, count(package) AS cnt FROM Logs GROUP BY country) AS T
WHERE T.cnt > (
	SELECT count(*) FROM Logs WHERE country=="CN");

-- 9.9 Print the average length of the package name of all the UNIQUE packages
SELECT avg(length(T.Names)) FROM ((SELECT DISTINCT package AS Names FROM Logs) AS T);

-- 9.10 Get the package whose downloading count ranks 2nd (print package name and it's download count).
SELECT package, count(*) as cnt FROM Logs GROUP BY package ORDER BY cnt DESC LIMIT 1 OFFSET 1;

-- 9.11 Print the name of the package whose download count is bigger than 1000.
SELECT name FROM (
	SELECT package AS name, count(*) as cnt FROM Logs GROUP BY package)
WHERE cnt > 1000;

SELECT package FROM Logs GROUP BY package HAVING count(*) > 1000;

-- 9.12 The field "r_os" is the operating system of the users.
    -- 	Here we would like to know what main system we have (ignore version number), the relevant counts, and the proportion (in percentage).
SELECT T.OS, count(*) as cnt, count(*) * 100.0 / (SELECT count(*) FROM Logs) AS percentage
FROM ((SELECT SUBSTR(r_os, 1, 5) AS OS FROM Logs) AS T)
GROUP BY T.OS ORDER BY cnt DESC;
