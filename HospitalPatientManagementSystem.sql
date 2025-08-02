CREATE DATABASE HospitalDB;

USE HospitalDB;

-- Creating Wards table
CREATE TABLE Wards (
    ward_id INT PRIMARY KEY,                  -- Unique identifier for each ward
    ward_name VARCHAR(100)                    -- Name of the ward
);

-- Inserting wards
INSERT INTO Wards VALUES (1, 'ICU'), (2, 'General'), (3, 'Maternity');

select * from Wards;

-- Creating Patients table with foreign key reference to Wards
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,               -- Unique patient ID
    name VARCHAR(100),                        -- Name of the patient
    phone VARCHAR(15),                        -- Raw phone number (will be formatted later)
    ward_id INT,                              -- FK to Wards table
    FOREIGN KEY (ward_id) REFERENCES Wards(ward_id)
);

-- Inserting patients
INSERT INTO Patients VALUES
(101, 'Priya', '9876543210', 1),
(102, 'Nikita', '8765432109', 2),
(103, 'Soni', '9988776655', 3);

select * from Patients;

-- Creating Treatments table with CHECK and FK constraints
CREATE TABLE Treatments (
    treatment_id INT PRIMARY KEY,             -- Unique treatment ID
    patient_id INT,                           -- FK to Patients table
    cost DECIMAL(10,2) CHECK (cost > 0),      -- Treatment cost (must be positive)
    department_id INT,                        -- Department responsible for the treatment
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- Inserting treatments
INSERT INTO Treatments VALUES
(1, 101, 5000.00, 10),
(2, 101, 2000.00, 10),
(3, 102, 3000.00, 20);

select * from Treatments;

-- Creating Doctors table with department reference
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,                -- Unique doctor ID
    name VARCHAR(100),                        -- Name of the doctor
    department_id INT                         -- FK match with department_id in Treatments
);

-- Inserting doctors (Dr. Payal has no patients assigned)
INSERT INTO Doctors VALUES
(1, 'Dr. Aditya', 10),
(2, 'Dr. Raj', 20),
(3, 'Dr. Payal', 30);

select * from Doctors;

-- Function to format phone number to +1-XXX-XXX-XXXX
CREATE FUNCTION FormatPhone (@phone VARCHAR(15))
RETURNS VARCHAR(20)
AS
BEGIN
    RETURN '+91-' + SUBSTRING(@phone, 1, 3) + '-' + 
                 SUBSTRING(@phone, 4, 3) + '-' + 
                 SUBSTRING(@phone, 7, 4)
END;

-- Calculate average treatment cost grouped by department
SELECT department_id, AVG(cost) AS AverageCost
FROM Treatments
GROUP BY department_id;

-- Show all patients who have active treatments
SELECT p.patient_id, p.name, t.treatment_id, t.cost
FROM Patients p
INNER JOIN Treatments t ON p.patient_id = t.patient_id;

-- Show all doctors, even those with no patients
SELECT d.doctor_id, d.name, t.treatment_id
FROM Doctors d
LEFT JOIN Treatments t ON d.department_id = t.department_id;

-- Identify patients with more than one treatment
SELECT DISTINCT a.patient_id, p.name
FROM Treatments a
JOIN Treatments b ON a.patient_id = b.patient_id AND a.treatment_id <> b.treatment_id
JOIN Patients p ON a.patient_id = p.patient_id;

-- Create procedure to get treatments in a date range
-- (Assumes a column 't_date' exists in Treatments)
ALTER TABLE Treatments ADD t_date DATE;  -- Add treatment date if not present

-- Insert sample dates
UPDATE Treatments SET t_date = '2025-07-01' WHERE treatment_id = 1;
UPDATE Treatments SET t_date = '2025-07-15' WHERE treatment_id = 2;
UPDATE Treatments SET t_date = '2025-08-01' WHERE treatment_id = 3;

-- Stored procedure for generating report between two dates
CREATE PROCEDURE GetMonthlyReport @StartDate DATE, @EndDate DATE
AS
BEGIN
    SELECT p.name AS PatientName, t.cost, t.department_id, t.t_date
    FROM Treatments t
    JOIN Patients p ON p.patient_id = t.patient_id
    WHERE t.t_date BETWEEN @StartDate AND @EndDate;
END;

-- Safely transfer a patient to another ward
BEGIN TRY
    BEGIN TRANSACTION

    -- Update patient's ward (e.g., transfer Priya to ward 2)
    UPDATE Patients
    SET ward_id = 2
    WHERE patient_id = 101;

    -- Simulate error (uncomment to test rollback)
    -- UPDATE Patients SET ward_id = 999 WHERE patient_id = 102;

    COMMIT;
    PRINT 'Patient transferred successfully';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Error occurred during transfer: ' + ERROR_MESSAGE();
END CATCH;

-- Create log table for auditing
CREATE TABLE Logs (
    log_id INT IDENTITY PRIMARY KEY,      -- Auto-incremented ID
    action_type VARCHAR(50),              -- Insert, Update, Delete etc.
    action_time DATETIME DEFAULT GETDATE(), -- Timestamp
    description VARCHAR(255)              -- Details of the operation
);

select * from Logs;
