select * from tbl_section_master

INSERT INTO tbl_section_master(section_name,display_sequence)
VALUES('4. Context of Our Organization',1),
('5. Leadership',2),
('6. Planning for the Management System',3),
('7. Support',4),
('8. Operation',5),
('9. Performance Evaluation',6),
('10. Improvement',7)

CREATE TABLE tbl_sub_section_master
(
sub_section_id INT IDENTITY(1,1),
sub_section_name VARCHAR(MAX)
)

INSERT INTO tbl_sub_section_master(sub_section_name)
VALUES('4.1  Understanding the organization and its context'),
('4.2 Understanding the needs and expectations of interested parties'),
('4.3 Determining the scope of the Management System'),
('4.4 Management System and its processes'),
('5.1.2 Customer Focus'),
('5.2 Quality and Environmental (Q&E) Policy'),
('5.3 Organizational roles, responsibilities and authorities'),
('7.1.2 People'),
('7.1.3 Infrastructure'),
('7.1.4 Environment for the operation of processes'),
('7.1.5 Monitoring and measuring resources'),
('7.1.6 Organizational Knowledge'),
('7.2 Competence'),
('7.3 Awareness'),
('7.4 Communication'),
('7.5 Documented Information'),
('8.2 Determination of requirements for products and services'),
('8.3 Design and development of products and services'),
('8.3.3 Design and development Inputs'),
('8.3.4 Design and development controls'),
('8.3.5 Design and development outputs'),
('8.3.6 Design and development changes'),
('8.4 Control of externally provided products and services'),
('8.4.2 Type and extent of control'),
('8.4.3 Information for external providers'),
('8.5 Production and Service provision'),
('8.5.1 Control of production and service provision'),
('8.5.2 Identification and traceability'),
('8.5.3 Property belonging to customers or external providers'),
('8.5.4 Preservation'),
('8.5.5 Post-delivery activities'),
('8.5.6 Control of changes'),
('8.6 Release of products and services'),
('8.7 Control of nonconforming outputs'),
('9.1.2 Customer Satisfaction'),
('9.1.3 Analysis and evaluation'),
('9.2 Internal Audits'),
('9.3 Management Review'),
('10.1 Improvement'),
('10.2 Nonconformity and corrective action'),
('10.3 Continual Improvement')


ALTER TABLE tbl_question_master ADD sub_section_id int

select * from tbl_module_master
select * from tbl_audit_type
select * from tbl_question_master where module_id=2 and Audit_type_id=1
update tbl_question_master set section_id=1 ,sub_section_id=1 where id in (1008,1009)
update tbl_question_master set section_id=1 ,sub_section_id=2 where id in (1010,1011)
update tbl_question_master set section_id=1 ,sub_section_id=3 where id in (1012,1013,1014,1015)
update tbl_question_master set section_id=1 ,sub_section_id=4 where id in (1016,1017)
update tbl_question_master set section_id=2  where id in (1018,1019)
update tbl_question_master set section_id=2 ,sub_section_id=5 where id in (1020)
update tbl_question_master set section_id=2 ,sub_section_id=6 where id in (1021,1022,1023)
update tbl_question_master set section_id=2 ,sub_section_id=7 where id in (1024)
update tbl_question_master set section_id=3  where id in (1025,1026,1027,1028,1029)
update tbl_question_master set section_id=4  where id in (1030)
update tbl_question_master set section_id=4 ,sub_section_id=8 where id in (1031)
update tbl_question_master set section_id=4 ,sub_section_id=9 where id in (1032)
update tbl_question_master set section_id=4 ,sub_section_id=10 where id in (1033)
update tbl_question_master set section_id=4 ,sub_section_id=11 where id in (1034,1035,1036,1037,1038,1039,1040)
update tbl_question_master set section_id=4 ,sub_section_id=12 where id in (1041,1042)
update tbl_question_master set section_id=4 ,sub_section_id=13 where id in (1043,1044,1045,1046)
update tbl_question_master set section_id=4 ,sub_section_id=14 where id in (1047)
update tbl_question_master set section_id=4 ,sub_section_id=15 where id in (1048,1049)
update tbl_question_master set section_id=4 ,sub_section_id=16 where id in (1050,1051,1052,1053)
update tbl_question_master set section_id=5  where id in (1054,1055)
update tbl_question_master set section_id=5 ,sub_section_id=17 where id in (1056,1057,1058,1059,1060,1061,1062,1063)
update tbl_question_master set section_id=5 ,sub_section_id=18 where id in (1064,1065)
update tbl_question_master set section_id=5 ,sub_section_id=19 where id in (1066,1067)
update tbl_question_master set section_id=5 ,sub_section_id=20 where id in (1068,1069,1070)
update tbl_question_master set section_id=5 ,sub_section_id=21 where id in (1071,1072)
update tbl_question_master set section_id=5 ,sub_section_id=22 where id in (1073)
update tbl_question_master set section_id=5 ,sub_section_id=23 where id in (1074,1075,1076,1077)
update tbl_question_master set section_id=5 ,sub_section_id=24 where id in (1078,1079,1080,1081,1082)
update tbl_question_master set section_id=5 ,sub_section_id=25 where id in (1083,1084)
--update tbl_question_master set section_id=5 ,sub_section_id=26 where id in (1056
update tbl_question_master set section_id=5 ,sub_section_id=27 where id in (1085,1086,1087,1088)
update tbl_question_master set section_id=5 ,sub_section_id=28 where id in (1089,1090,1091)
update tbl_question_master set section_id=5 ,sub_section_id=29 where id in (1092,1093,1094)
update tbl_question_master set section_id=5 ,sub_section_id=30 where id in (1095,1096)
update tbl_question_master set section_id=5 ,sub_section_id=31 where id in (1097,1098)
update tbl_question_master set section_id=5 ,sub_section_id=32 where id in (1099)
update tbl_question_master set section_id=5 ,sub_section_id=33 where id in (1100,1101,1102)
update tbl_question_master set section_id=5 ,sub_section_id=34 where id in (1103,1104,1105,1106)
update tbl_question_master set section_id=6  where id in (1107,1108,1109)
update tbl_question_master set section_id=6 ,sub_section_id=35 where id in (1110,1111,1112)
update tbl_question_master set section_id=6 ,sub_section_id=36 where id in (1113,1114,1115)
update tbl_question_master set section_id=6 ,sub_section_id=37 where id in (1116,1117,1118,1119,1120,1121)
update tbl_question_master set section_id=6 ,sub_section_id=38 where id in (1122,1123,1124,1125,1126,1127,1128)

update tbl_question_master set section_id=7 ,sub_section_id=39 where id in (1129,1130)
update tbl_question_master set section_id=7 ,sub_section_id=40 where id in (1131,1132,1133,1134,1135)
update tbl_question_master set section_id=7 ,sub_section_id=41 where id in (1136,1137,1138,1139)

GO

ALTER PROCEDURE [dbo].[sp_getQuestionList](
@module_id INT,
@auditType_id INT
)
AS
BEGIN
SELECT question_id, question, sec.section_name, sub.sub_section_name
FROM tbl_question_master que LEFT JOIN tbl_section_master sec ON que.section_id=sec.section_id
LEFT JOIN tbl_sub_section_master sub ON que.sub_section_id=sub.sub_section_id
  WHERE module_id=@module_id AND Audit_type_id=@auditType_id
END

