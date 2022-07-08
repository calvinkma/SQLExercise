-- https://en.wikibooks.org/wiki/SQL_Exercises/Planet_Express 
-- 7.1 Who receieved a 1.5kg package?
    -- The result is "Al Gore's Head".
SELECT Name FROM Package LEFT JOIN Client ON Package.Recipient == Client.AccountNumber WHERE Package.Weight==1.5;

-- 7.2 What is the total weight of all the packages that he sent?
SELECT sum(Weight) FROM Package WHERE Sender IN (
	SELECT AccountNumber FROM Client WHERE Name=="Al Gore's Head");
