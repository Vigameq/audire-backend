
ALTER TABLE tbl_audit_type ADD Color_code VARCHAR(100)

update  tbl_audit_type SET Color_code='#283747' WHERE ID=1
update  tbl_audit_type SET Color_code='#4D5656' WHERE ID=2
update  tbl_audit_type SET Color_code='#8E44AD' WHERE ID=3
update  tbl_audit_type SET Color_code='#6E2C00' WHERE ID=4
update  tbl_audit_type SET Color_code='#B03A2E' WHERE ID=5