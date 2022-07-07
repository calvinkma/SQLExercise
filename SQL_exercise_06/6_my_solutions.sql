-- https://en.wikibooks.org/wiki/SQL_Exercises/Scientists
-- 6.1 List all the scientists' names, their projects' names, 
    -- and the hours worked by that scientist on each project, 
    -- in alphabetical order of project name, then scientist name.
SELECT Scientists.Name, Projects.Name, Projects.Hours 
FROM Scientists JOIN AssignedTo ON Scientists.SSN==AssignedTo.Scientist JOIN Projects ON AssignedTo.Project==Projects.Code
ORDER BY Projects.Name ASC, Scientists.Name ASC;

-- 6.2 Select the project names which are not assigned yet
SELECT Projects.Name FROM Projects LEFT JOIN AssignedTo ON Projects.Code==AssignedTo.Project WHERE AssignedTo.Scientist IS NULL;
