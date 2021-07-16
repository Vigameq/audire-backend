
CREATE TABLE tbl_audit_type(ID INT IDENTITY(1,1), Audit_Type VARCHAR(MAX), module_id int, Status int)

INSERT INTO tbl_audit_type(Audit_Type, module_id,Status)
VALUES('ISO 9001-2015 Process Audit',2,1),
('ISO 9001-2015 Supplier Audit',2,1),
('ISO 14000	Audit',1,1),
('IMS Audit OER',1,1),
('OHSAS-18001-2007 Internal Audit',1,1)


ALTER TABLE tbl_question_master ADD Audit_type_id Int

update tbl_question_master SET audit_type_id=4  where module_id=1
