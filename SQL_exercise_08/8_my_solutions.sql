-- 8.1 Obtain the names of all physicians that have performed a medical procedure they have never been certified to perform.
SELECT Physician.Name FROM Physician WHERE Physician.EmployeeID IN (
	SELECT Undergoes.Physician FROM (
		Undergoes LEFT JOIN Trained_In ON Undergoes.Physician==Trained_In.Physician AND Undergoes.Procedures==Trained_In.Treatment
	) 
	WHERE Trained_In.Physician IS NULL
);

-- 8.2 Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on.
SELECT Physician.Name, Procedures.Name, Undergoes.DateUndergoes, Patient.Name FROM (
	Undergoes 
	LEFT JOIN Trained_In ON Undergoes.Physician==Trained_In.Physician AND Undergoes.Procedures==Trained_In.Treatment
	LEFT JOIN Physician ON Physician.EmployeeID==Undergoes.Physician
	LEFT JOIN Procedures ON Procedures.Code==Undergoes.Procedures
	LEFT JOIN Patient ON Undergoes.Patient==Patient.SSN
) 
WHERE Trained_In.Physician IS NULL;

-- 8.3 Obtain the names of all physicians that have performed a medical procedure that they are certified to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires).
SELECT Physician.Name FROM Physician WHERE Physician.EmployeeID IN (
	SELECT Undergoes.Physician FROM (
		Undergoes LEFT JOIN Trained_In ON Undergoes.Physician==Trained_In.Physician AND Undergoes.Procedures==Trained_In.Treatment
	)
	WHERE Trained_In.Physician IS NOT NULL AND DateUndergoes > CertificationExpires
);

-- 8.4 Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on, and date when the certification expired.
SELECT Physician.Name, Procedures.Name, Undergoes.DateUndergoes, Patient.Name, Trained_In.CertificationExpires FROM Physician, Procedures, Undergoes, Patient, Trained_In
WHERE Physician.EmployeeID==Undergoes.Physician AND Patient.SSN==Undergoes.Patient AND Procedures.Code==Undergoes.Procedures
AND Trained_In.Physician==Physician.EmployeeID AND Trained_In.Treatment==Undergoes.Procedures AND Trained_In.CertificationExpires<Undergoes.DateUndergoes;

-- 8.5 Obtain the information for appointments where a patient met with a physician other than his/her primary care physician. Show the following information: Patient name, physician name, nurse name (if any), start and end time of appointment, examination room, and the name of the patient's primary care physician.
SELECT Patient.Name PatientName, Ph.Name PhysicianName, Nurse.Name NurseName, Appointment.Start, Appointment.End, Appointment.ExaminationRoom, Pcp.Name PCPName
FROM Patient, Physician Ph, Nurse, Appointment, Physician Pcp
WHERE Appointment.Patient==Patient.SSN AND Appointment.Physician==Ph.EmployeeID 
AND Patient.PCP!=Appointment.Physician AND Appointment.PrepNurse==Nurse.EmployeeID AND Patient.PCP=Pcp.EmployeeID;

-- 8.6 The Patient field in Undergoes is redundant, since we can obtain it from the Stay table. There are no constraints in force to prevent inconsistencies between these two tables. More specifically, the Undergoes table may include a row where the patient ID does not match the one we would obtain from the Stay table through the Undergoes.Stay foreign key. Select all rows from Undergoes that exhibit this inconsistency.
SELECT U.* FROM Undergoes U, Stay S WHERE U.Stay==S.StayID AND U.Patient!=S.Patient;

-- 8.7 Obtain the names of all the nurses who have ever been on call for room 123.
SELECT Nurse.Name FROM Nurse, On_Call, Room
WHERE Room.RoomNumber==123 AND On_Call.BlockCode==Room.BlockCode AND On_Call.BlockFloor==Room.BlockFloor AND On_Call.Nurse==Nurse.EmployeeID;

-- 8.8 The hospital has several examination rooms where appointments take place. Obtain the number of appointments that have taken place in each examination room.
SELECT ExaminationRoom, count(AppointmentID) FROM Appointment GROUP BY ExaminationRoom;

-- 8.9 Obtain the names of all patients (also include, for each patient, the name of the patient's primary care physician), such that \emph{all} the following are true:
    -- The patient has been prescribed some medication by his/her primary care physician.
    -- The patient has undergone a procedure with a cost larger that $5,000
    -- The patient has had at least two appointment where the nurse who prepped the appointment was a registered nurse.
    -- The patient's primary care physician is not the head of any department.
SELECT Patient.Name, Physician.Name FROM Patient, Physician, Prescribes, Undergoes, Procedures
WHERE Prescribes.Patient==Patient.SSN AND Prescribes.Physician==Patient.PCP
AND Undergoes.Patient==Patient.SSN AND Procedures.Code==Undergoes.Procedures AND Procedures.Cost>5000
AND Patient.SSN IN (
	SELECT A.SSN FROM (
		SELECT Patient.SSN SSN, count(Appointment.AppointmentID) CNT FROM Patient, Appointment, Nurse
		WHERE Appointment.Patient==Patient.SSN AND Appointment.PrepNurse IN (SELECT Nurse.EmployeeID FROM Nurse WHERE Nurse.Registered==1) AND Appointment.PrepNurse==Nurse.EmployeeID
		GROUP BY Patient.SSN) A
	WHERE A.CNT >= 2
)
AND Patient.PCP NOT IN (SELECT Head FROM Department)
AND Patient.PCP==Physician.EmployeeID;
