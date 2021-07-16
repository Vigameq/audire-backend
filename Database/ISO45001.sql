select * into tempISO45001 from tbl_question_master where Audit_type_id=7
DELETE FROM tbl_question_master where Audit_type_id=7

select * from tbl_Module_master

select * from tbl_audit_type where module_id=2

select * from tbl_question_master where Audit_type_id=2

INSERT INTO tbl_question_master(module_id,Audit_type_id ,question_id,section_name, sub_section_name,clause, question,help_text )
VALUES
(1,7,1, '4 Context of the organization', '4.1 Understanding the organization and its context', '4.1', 'Are external and internal issues  relevant for OH&S management system determined? ', 'Organization Business Manual
Code of conduct
process landscape'),
(1,7,2, '4 Context of the organization', '4.1 Understanding the organization and its context', '4.1', 'Can the intended results of its OH & S be achieved through its management system?', 'Organization Business Manual
Code of conduct
process landscape'),
(1,7,3, '4 Context of the organization', '4.1 Understanding the organization and its context', '4.2', 'Are the relevant needs and expectations of the interested parties and workers determined considering the necessary legal and regulatory requirements?', ''),
(1,7,4, '4 Context of the organization', '4.1 Understanding the organization and its context', '4.2', 'Is a consultation process established with employee representatives to identify the OH&S relevant needs and expectations of the workers and the other interested parties ?', ''),
(1,7,5, '4 Context of the organization', '4.1 Understanding the organization and its context', '4.2', 'Have the OH&S binding obligations been transferred into the organization? How is compliance monitored?', ''),
(1,7,6, '4 Context of the organization', '4.1 Understanding the organization and its context', '4.3', 'Are the scope/boundaries of the OH&S MS defined (considering context, legal entities and business units on site, interested parties, planned or performed work-related activities)? And does it include the activities, products and services within the organizations control or influence?', 'Organisational Manual
Business Manual (global, local, BU)
Code of conduct
process landscape
List of OH&S procedures and instructions
Business Strategy'),
(1,7,7, '4 Context of the organization', '4.1 Understanding the organization and its context', '4.4', 'Are OH&S-MS and processes introduced, are they maintained and subject to a continuous improvement (including OH&S performance)? Are the necessary processes, their interactions and standard requirements taken into account? Is it documented?', 'Organsational Manual
Business Manual
Code of conduct
process landscape'),
(1,7,8, '5 Leadership', '', '5.1', 'Does the Top Management demonstrate leadership and commitment with respect to the OH&S management system?
', 'Description of the OH&S MS organization
OH&S Policy
Charts
Job descriptions
OH&S task matrix
Nomination letters
Mandated OH&S-MS and/or legally required functions'),
(1,7,9, '5 Leadership', '', '5.1', 'Does the Top Management take overall responsibility and accountability for the prevention of work-related injury and ill health, as well as the provision of safe and healthy workplaces and activities ?', 'Description of the OH&S MS organization
OH&S Policy
Charts
Job descriptions
OH&S task matrix
Nomination letters
Mandated OH&S-MS and/or legally required functions'),
(1,7,10, '5 Leadership', '', '5.1', 'Are OH&S-relevant tasks, responsibilities and duties defined, documented ?', 'Description of the OH&S MS organization
OH&S Policy
Charts
Job descriptions
OH&S task matrix
Nomination letters
Mandated OH&S-MS and/or legally required functions'),
(1,7,11, '5 Leadership', '', '5.2', 'Is an OH&S Policy issued and approved by the Top Management? 
Is the posted OH&S policy up to date?', 'Internet
Intranet
Information boards,
Notice of the OH&S policy,
Training evidence of the OH&S policy
Investment plans
Action plans'),
(1,7,12, '5 Leadership', '', '5.2', 'Does the content of the OH&S policy meet the normative requirements?
', 'Internet
Intranet
Information boards,
Notice of the OH&S policy,
Training evidence of the OH&S policy
Investment plans
Action plans'),
(1,7,13, '5 Leadership', '', '5.2', 'Is OH&S policy appropriate to the purpose and context of the organization (taking into account the characteristics, size, context  and to the specific nature of its OH&S risks and OH&S opportunities ?', 'Internet
Intranet
Information boards,
Notice of the OH&S policy,
Training evidence of the OH&S policy
Investment plans
Action plans'),
(1,7,14, '5 Leadership', '', '5.2', 'Is the OH&S policy documented, communicated internally and available to interested parties?', 'Internet
Intranet
Information boards,
Notice of the OH&S policy,
Training evidence of the OH&S policy
Investment plans
Action plans'),
(1,7,15, '5 Leadership', '', '5.3 ', 'Are OH&S related responsibilities and authorities including the reporting obligations defined and communicated by the top management at all levels?
', 'Description of the OH&S organization
OH&S Policy
Charts
Job descriptions
OH&S-MS task matrix
Nomination letters
Mandated OH&S-MS and/or legally required functions
KPIS Reporting
SharePoint data
OH&S action lists'),
(1,7,16, '5 Leadership', '', '5.3 ', 'Have the duties and responsibility for the application and maintenance of the entire OH&S-MS been delegated?', 'Description of the OH&S organization
OH&S Policy
Charts
Job descriptions
OH&S-MS task matrix
Nomination letters
Mandated OH&S-MS and/or legally required functions
KPIS Reporting
SharePoint data
OH&S action lists'),
(1,7,17, '5 Leadership', '', '5.3', 'Does the Top Management regularly receive  OH&S performance information and data and does it involve in the definition of an action plan?', 'Description of the OH&S organization
OH&S Policy
Charts
Job descriptions
OH&S-MS task matrix
Nomination letters
Mandated OH&S-MS and/or legally required functions
KPIS Reporting
SharePoint data
OH&S action lists'),
(1,7,18, '5 Leadership', '', '5.3 ', 'Is a consultation process established with employee representatives when HSE-relevant roles, responsibilities and authorities including reporting obligations are defined or changed?', ''),
(1,7,19, '5 Leadership', '', '5.4 ', 'Does the process for consultation and participation of workers?
', ''),
(1,7,20, '6 Planning', '', '6.1.1', 'Does the organization consider the  following topics in the OH&S planning?
', '• Context of the organization
• Needs and expectations of interested parties
• Scope of the OH&S-MS
• OH&S related risks and opportunities, binding obligations and other requirements'),
(1,7,21, '6 Planning', '', '6.1.2.1', 'Is there a procedure for the identification of hazards (ongoing and proactive)  ? The process(es) shall take into account, but not be limited to:
', '
b) routine and non-routine activities and situations
c) past relevant incidents, internal or external to the organization, including (potential) emergencies, and their causes;
d) potential emergency situations
e) people (internal/external)
f)  other issues like design of work areas, installations, machinery / situations occurring in the vicinity
'),
(1,7,22, '6 Planning', '', '6.1.2.1', 'The identification of hazards is an ongoing and proactive task, therefore the risk assessments shall be review within a 3-year period according to internal procedure. ', '1)  actual or proposed changes in organization, operations, processes
2)  changes in knowledge of, and information about, hazards'),
(1,7,23, '6 Planning', '', '6.1.2.2', 'Is it  ensured that other risks to the OH&S-MS (e.g. caused due to restructuring, peaks in work flow, changes in work load) are assessed appropriately?', '1)  actual or proposed changes in organization, operations, processes
2)  changes in knowledge of, and information about, hazards'),
(1,7,24, '6 Planning', '', '6.1.2.3', 'Is there a procedure for the assessment  of identified opportunities?
', 'OH&S opportunities to enhance OH&S performance, by taking into account of planned changes to the organization, its policies, its processes or its activities and:
1) opportunities to adapt work, work organization and work environment to workers;
2) opportunities to eliminate hazards and reduce OH&S risks'),
(1,7,25, '6 Planning', '', '6.1.2. ', 'Are there  participation processes  established with employee representatives for identifying hazards, and assesing risks and opportunities ?', 'HSE Governance
OH&S Policy
H&S Committee'),
(1,7,26, '6 Planning', '', '6.1.3
', 'Are processes established  to identify, are accessible and apply binding obligations/commitments, is this documented 
Have the workers representative been consulted when determining the process ? Are there any document available?
', 'HSE Manual'),
(1,7,27, '6 Planning', '', '6.1.4. ', 'Is a participation process established with employee representatives for determining actions to eliminate OH&S hazards and reduce OH&S risks , is the hierarchy of controls defined, and best practices adopted?', 'Hse best practice documents.'),
(1,7,28, '6 Planning', '', '6.2.1', 'Are OH&S objectives at relevant functions and levels established  in order to maintain & continually improve the OH&S management system and OH&S performance ?', 'OH&S Action Plasmas Budget plans, investment plans for OH&S relevant investments
Documented OH&S program with responsibilities
Minutes of meetings to HSE programs'),
(1,7,29, '6 Planning', '', '6.2.1', 'Have the opportunities determined under 6.1.2.3 also been considered in the establishment of the objectives, Are they consistent with the policy? Are there any measurable targets?', ''),
(1,7,30, '6 Planning', '', '6.2.2', 'Has a plan been drawn up with target contents, resources, responsibilities, completion times and monitoring criteria for OH&S objectives?', 'Roles and Responsibilities'),
(1,7,31, '7 Support', '', '7.1', 'Are the necessary skilled resources for the establishment, maintenance and continuous improvement of the OH&S-MS defined and  available?', 'OH&S-MS organisation
Competences and duties
External resources
Resource planning'),
(1,7,32, '7 Support', '7.2 Competence', '7.2', 'Is the OH&S training requirement systematically determined for the employees'' own and third-party employees?
Is there a corresponding written process? What are the time intervals?', 'Check for training plan and the training documents'),
(1,7,33, '7 Support', '7.2 Competence', '7.2', 'How are the relevant effectiveness checks carried out after training? Are they documented ?', 'After training check for the the training effectiveness document'),
(1,7,34, '7 Support', '7.2 Competence', '7.2', 'Are new employees/Contract employees instructed on the hazards and OH&S impact of their activities? Is Documentation available to evidence?', ''),
(1,7,35, '7 Support', '7.2 Competence', '7.3', 'What types of awareness training are offered and implemented for the different hierarchical levels? What training is mandatory? How is documentation done?', 'Certificates,
Training documents
Awareness programs
Training of new employees
Protocols from relevant events / meetings / etc.
Appraisal interviews
Incentive plans'),
(1,7,36, '7 Support', '7.2 Competence', '7.4.1', 'Are internal and external communication processes defined?
', 'annual and quarterly reports
Employee Information ,Company newspaper,OH&S,publications,OH&S,requests,OH&Scomplaints,Exchange of letters with authorities, Notifications to authorities, Information to the public in case of operational disturbances ,Emergency information
'),
(1,7,37, '7 Support', '7.2 Competence', '7.4.2', 'Does the communication process ensure that all workers have the opportunity to contribute to continual improvement ?', 'Suggestion Scheme, or suggestion procedure etc.
'),
(1,7,38, '7 Support', '7.2 Competence', '7.5.1', 'Includes the OH&S-MS documentation:
• documented information according to ISO 45001: 2019
• necessary documentation for the effectiveness of the OH&S-MS?', 'HSE processes
Enforcement of the HSE management system
Operating and operating instructions
List of applicable documents
Document management system
'),
(1,7,39, '7 Support', '7.2 Competence', '7.5.3', 'Were relevant external documented information collected, steered and managed?', 'External vendor agreements? Like scrap handling? Etc'),
(1,7,40, '7 Support', '7.2 Competence', '7.5.3', 'Is special attention paid to the requirement of confidentiality agreements?', 'NDA, MOU documents with external service providers.'),
(1,7,41, '8 Operation', '', '8.1.1', 'Has an evaluation been done on which processes / procedures are needed to meet the requirements of the OH&S Management System ?
Are the processes required, implemented, managed and maintained? 
', 'Risk management, emergency preparedness, OH&S representatives / functions (legally required), delegation of OH&S responsibility, training / instruction, management of external contractor companies,  Planning, conversion, maintenance of buildings and facilities (change management), permitting/approval management process, handling and storage of hazardous substances, Incident Investigation, Evaluation of workplace conditions, Communication'),
(1,7,42, '8 Operation', '', '8.1.1', 'multi- employer workplaces: Is it ensured that the relevant OH&S requirements are communicated and coordinated with the external organization ?', 'Instructions to contractors/external service providers.'),
(1,7,43, '8 Operation', '', '8.1.3.', 'Does the organization define, implement and maintain processes for the control of temporary and permanent changes that impact OH&S performance,', ' changes to legal requirements and other binding obligations, changes in knowledge or information about hazards and OH&S risks; developments in knowledge and technology.'),
(1,7,44, '8 Operation', '', '8.1.4.', 'Does the organization establish, implement and maintain a process(es) to control the procurement of products and services in order to ensure their conformity to its OH&S management system?', 'Approval process e.g. for machines, chemicals, materials, contractors'),
(1,7,45, '8 Operation', '', '8.2', 'Have potential emergency situations been identified, resulting from routine- and non-routine operations, potential failure or defects at infrastructure (technical installations, utility units) or production machines as well as staff related incidents?', 'Emergency Preparedness Plan. Emergency Response Plan
Risk Assessments
Alarm/reporting plans/lines
Public emergency information plans
Escape routes and their marking and signposting
Fire brigade plans
Listings of near-emergencies units 
Safety Data Sheets
Operating instructions
Training records
Fire extinguish water basins/barriers
Instructions
Telephone numbers (list)
Maps'),
(1,7,46, '8 Operation', '', '8.2', 'Are performance evaluations for drills, exercises and performed emergency response measures implemented ? 
Are appropriate conclusions drawn and measures checked for effectiveness ? 
Are the results of these evaluations reviewed by the local Health & Safety Committee?', 'Training Records
'),
(1,7,47, '9 Performance Evaluation', '', '9.1.1', 'Has it been determined what is going to be measured, analysed, calibrated and evaluated? when and with what methods? Are appropriate criteria defined to evaluate the measurement results and OH&S performance?', '
Schedule of recurring measurements
Testing, measuring or monitoring instructions
Testing, measuring or monitoring protocols
Alarm measurement units (e.g. smoke detectors, gas detectors,....)
Measurements of working conditions, e.g. hazardous concentrations / noise level / illumination at the work place.
Measurements of body functions e.g. within medical check-ups.
List of test / measuring devices
Calibration records
Maintenance records
Maintenance contracts
External test reports
'),
(1,7,48, '9 Performance Evaluation', '', '9.1.2', 'Has a procedure for assessing compliance with binding obligations been established, implemented and maintained (including determination the frequency of the assessment,  including regulations to define and perform corrective measures)?', 'Legal documents, necessary approvals.'),
(1,7,49, '9 Performance Evaluation', '', '9.2.1', 'Are ""Internal OH&S Audits"" performed? Is an audit program established, implemented and maintained?', '
Process description for internal OH&S-MS audits
Audit program
Audit plans
Audit reports
Reports on OH&S-MS audit corrective actions
OH&S-MS audit checklists
OH&S-MS audit logs
Training and qualification Certificates of OH&S-MS auditors
Assessment protocols for compliance with legal requirements
Compliance HSE audits
Official external inspections
Self-assessments
Certification Audits
Customer Audits
'),
(1,7,50, '9 Performance Evaluation', '', '9.3', 'Is the OH&S-MS  assessed at scheduled intervals (at least annually) by the top management in order to ensure the continued suitability, adequacy and effectiveness? Is this review/evaluation taking place? Documents?', 'a. Internal and external issues with an impact on the OH&S-MS
b. Needs and expectations of interested parties
c. Binding obligations
d. Risks and opportunities
monitoring + measurement results
consultation and participation of workers
'),
(1,7,51, '10 Improvement', '', '10.1', 'Are the opportunities for continuous improvement of the OH&S-MS identified and implemented? What measures are available to reach the target?', 'risk identifications, suggestions etc.'),
(1,7,52, '10 Improvement', '', '10.2', 'Is a process implemented and maintained for the reporting, investigation and taking action to determine and manage incidents (e.g. near misses, accidents, emergencies, fire, occupational illnesses,…)?', 'List with containment action, correction and systematic corrective actions,
(8D Reports) 
HSE Alerts'),
(1,7,53, '10 Improvement', '', '10.2', 'How is ensured, that documented information regarding the nature of incidents / nonconformities, the taken immediate and corrective measures and their effectivity are communicated with the relevant workers, with the workers’ representatives  and with other relevant interested parties ?', ''),
(1,7,54, '10 Improvement', '', '10.3', 'Are there any continuous improvements to the OH&S-MS (suitability, adequacy, effectiveness, outcome considerations, opportunities for improvement)?', 'KPI Charts,
Safety tasks
Lessons Learnt
Company suggestion schemes
HSE Awards
Regional HSE Calls
Training programs
MHN Standards with HS-requirements
')


select * into tempsupplier from tbl_question_master where Audit_type_id=2
DELETE FROM tbl_question_master where Audit_type_id=2

INSERT INTO tbl_question_master(module_id,Audit_type_id ,section_name,question_id, question,help_text )
VALUES
(4,2,'1 Design & Development', 1, 'Are customer needs and requirements incorporated into product designs and/or manufacturing processes?', 'Market studies, customer/end-user surveys, technical design reviews '),
(4,2,'1 Design & Development', 2, 'Are Critical-to-Quality (CTQ) characteristics are identified, understood and records retained?', 'Process capability studies, process plan, manufacturing verification tests'),
(4,2,'1 Design & Development', 3, 'Are product specifications and drawings generated, controlled and maintained for new or changed product designs?', 'Product characteristics, application requirements and other information  for safe and proper use and disposal'),
(4,2,'1 Design & Development', 4, 'Is design validation is an integral part of the design process and occurs prior to production release?', 'Design results, manufacturability, productivity and cost studies, confirmation that product fulfils its specified requirements or intended use or applications'),
(4,2,'1 Design & Development', 5, 'Are human and technical resources are adequate to meet the requirements for design collaboration, tooling design and electronic drawing and data exchange? ', 'Qualification of technical staff.  Equipment/software capabilities, CAD'),
(4,2,'2 Customer Documentation', 6, 'Are new and revised customer specifications reviewed and implemented in a timely manner?', 'Technical review of methods to be used, capability studies on similar parts, documented review procedure'),
(4,2,'2 Customer Documentation', 7, 'Are current process control documents in place and used for production start-up and continuing production? ', 'Specifications, engineering drawings, change notices, work instructions and specifications as applicable'),
(4,2,'2 Customer Documentation', 8, 'Does customer notification/approval occur for changes to control plans, manufacturing site, product transfers, raw material or product obsolescence?', 'Customer notification procedure on major changes'),
(4,2,'2 Customer Documentation', 9, 'Is there a record control system is in place for the identification, storage, protection, retrieval, retention time, and disposition of quality records?', 'Document control procedure'),
(4,2,'2 Customer Documentation', 10, 'Are quality records maintained?', 'List of records to be kept with retention periods specified'),
(4,2,'3 Purchase', 11, 'Is there a formal process used for the selection, qualification and re-qualification of suppliers?', 'Supplier quality audits and corrective actions, engineering testing, approval records, production trials'),
(4,2,'3 Purchase', 12, 'Are purchases from unapproved suppliers prevented by a properly controlled and available approved supplier list?', 'Approved supplier list, procedures, production material receipt records'),
(4,2,'3 Purchase', 13, 'Are preventive actions taken to continuously improve performance of the supplier base?', 'Supplier quality performance analysis, performance trends, supplier audit reports'),
(4,2,'3 Purchase', 14, 'Does the supplier assurance system ensure that all purchased product or material conforms to defined specifications and applicable regulatory or customer requirements?', 'Receiving inspection, supplier audits, source inspection, qualification testing, Certificate of Compliance, component marking, labelling, etc.'),
(4,2,'3 Purchase', 15, 'Does a system exist for the identification, verification and protection of customer supplied product that includes notifying the customer if product is damaged or lost?', 'Procedures, segregation during storage, limited and controlled access to stored inventories'),
(4,2,'3 Purchase', 16, 'Is receiving inspection performed per documented procedures and detailed work instructions?', 'Procedures, inspection instructions resources (manpower and equipment) allocated for incoming inspection'),
(4,2,'3 Purchase', 17, 'Is inspected material adequately identified as to acceptance or rejection and traceable to receiving inspection report?', 'Quality control  label, marking or use of designated hold area as indicated in the procedure'),
(4,2,'3 Purchase', 18, 'Do supplier corrective action requests requiring root cause investigation show responses are analysed?', 'Availability of written procedure, standardized corrective action form, analysis of corrective action cycle time and closure measurements'),
(4,2,'3 Purchase', 19, 'Are areas around the facility clean and orderly and are tools and equipment properly stored and readily available for use and is lighting and air quality are adequate?', 'Observe production, office & product storage areas. (Sort, Set-in-order, Shine, Standardize, Sustain + Safety)'),
(4,2,'3 Purchase', 20, 'Is proper equipment and methods used to prevent product damage or loss in all phases of the material handling process?', 'Observe handling and transit of raw material, work-in-process, and finished goods.'),
(4,2,'3 Purchase', 21, 'Are documented procedures followed to ensure proper control and preservation of handling, storage (FIFO), packaging, and delivery of product?', 'FIFO practices are defined, packaging specifications, test results, handling and storage procedures.'),
(4,2,'3 Purchase', 22, 'Is the suitability of product packaging reviewed and concerns communicated to the customer prior to initial production shipment?', 'Technical review, packaging/shipping tests, packaging work instructions, carton strength tests'),
(4,2,'3 Purchase', 23, 'Is stored product/material periodically inspected, and where applicable, actions are taken to prevent deterioration per documented procedures?', 'Lists of shelf-life sensitive materials.  Look for poor storage conditions and damage. Handling procedures'),
(4,2,'3 Purchase', 24, 'Have contingency plans been developed that describe actions to be taken in the event of a major interruption of the manufacturing process?', 'Process covering utility interruptions, labour shortages, key equipment failures, major production issues'),
(4,2,'4 Quality Management', 25, 'Is the quality system documented, controlled and maintained to clearly describe current practice?', 'Quality manual and all procedures show revision control (sign-offs & dates), history of changes'),
(4,2,'4 Quality Management', 26, 'Do quality reports, trend charts and data analysis identify areas of opportunity and are used by management on a routine basis?  ', 'Product quality yield data, problems and corresponding improvement actions, status of preventive/ corrective/audit results'),
(4,2,'4 Quality Management', 27, 'Are quality-performance targets clearly defined, included in the business plan and monitored for improvements? ', 'Strategic and tactical objectives, goals, action plans, etc.'),
(4,2,'4 Quality Management', 28, 'Does executive management participate in periodic quality system reviews that address quality related feedback from customers and internal quality metrics?', 'Analysis of field failures, inspection yields, resource needs, internal audit results, corrective action status, etc.'),
(4,2,'4 Quality Management', 29, 'Are production samples inspected and provided to customers upon request? ', 'Completed PPAP or similar forms, inspection reports, availability of qualified resources'),
(4,2,'4 Quality Management', 30, 'Are customer production requirements and quality specifications are reviewed to ensure they can be met on a consistent basis?', 'Procedures, design/process review,  capacity plans, resource plans, product test, storage, packaging and shipment requirements'),
(4,2,'4 Quality Management', 31, 'Are reliability test plans developed and routinely followed?', 'Reliability test plans, test reports'),
(4,2,'4 Quality Management', 32, 'Is testing is used to verify the design specifications, drive design improvements and provide an on-going check of materials and workmanship?', 'Improvement/corrective actions taken, design changes implemented'),
(4,2,'4 Quality Management', 33, 'Is product reliability test data is available upon request and historical test performance data shows a highly stable process and product design?', 'Reliability test summary reports/charts'),
(4,2,'4 Quality Management', 34, 'Is there is a formal method used to qualify new or rebuilt production equipment prior to production use? ', 'Qualification plan that includes established goals for process yields. Records of process capability, review and approval'),
(4,2,'4 Quality Management', 35, 'Are control plans used to plan and deploy inspection and test functions throughout the production process?', 'Process flow chart, statistical tools,  key inspection points, inspection frequency, inspection/test method, gaging used, acceptable yield rates'),
(4,2,'4 Quality Management', 36, 'Are appropriate work instructions are available where needed that accurately describe all work methods including inspections and tests to be done during production? ', 'Sample size, frequency, method, document control dates/revision level'),
(4,2,'4 Quality Management', 37, 'Are appropriate inspections, tests and process adjustments made per applicable work instructions to verify conformance at key points throughout the process and prior to shipment?', 'Records of inspections performed at incoming, first piece, in-process and/or final inspection or test'),
(4,2,'4 Quality Management', 38, 'Is the inspection and process status of the product identified and maintained throughout the production process?', 'Batch records, travellers, tags, labels, product markings or use of designated and identified areas'),
(4,2,'4 Quality Management', 39, 'Are customers notified of low yield production lots or issues that affect product reliability?', 'Corrective actions, records of customer notifications, reliability test data'),
(4,2,'4 Quality Management', 40, 'Are nonconforming materials, parts and assemblies are segregated (where practical) and identified to prevent unapproved use?', 'Tags, marking, controlled staging areas'),
(4,2,'4 Quality Management', 41, 'Is reworked material, parts and assemblies are re-inspected or re-tested to confirm compliance to requirements?', 'Inspection record, tag and stamp'),
(4,2,'4 Quality Management', 42, 'Is the use of nonconforming material is documented under a formal waiver or concession system?', 'Written procedure, waiver or concession records'),
(4,2,'4 Quality Management', 43, 'Is product traceability maintained to facilitate problem evaluation and corrective action?', 'Serial number records, lot number, date of manufacture, labelling and marking of containers or product'),
(4,2,'4 Quality Management', 44, 'Is there a positive recall system to notify customers of nonconforming product that has already been shipped?', 'Documented procedure and review of system'),
(4,2,'5 Measurement & Monitoring ', 45, 'Are gauge repeatability and reproducibility studies conducted to verify suitability of measuring devices for their use in checking product quality or control of processes?', 'GR&R studies, reports'),
(4,2,'5 Measurement & Monitoring ', 46, 'Are measuring devices and gauges and test equipment are routinely calibrated and controlled per documented procedures?', 'Calibration stickers and records, positive identification or segregation of out-of-calibration devices, and inventory, location & status records. '),
(4,2,'5 Measurement & Monitoring ', 47, 'Are gauges and test equipment calibrated against standards traceable to a recognized regulatory body or agency?', 'Calibration procedures, and calibration stickers and other records'),
(4,2,'5 Measurement & Monitoring ', 48, 'Are assessments made to check the validity of previous measurements done on products where out-of-calibration measuring devices were used?', 'Assessment records and corrective actions'),
(4,2,'5 Measurement & Monitoring ', 49, 'Are appropriate controls are in place to verify the suitability and accuracy of computer software prior to initial use in checking product quality or control of processes?', 'Verification methods and records, revision levels, distribution/use control'),
(4,2,'6 Process Control', 50, 'Are key part characteristics and process parameters are reviewed and statistically based controls and/or problem solving tools are used to control variation?', 'Histograms, run charts, SPC charts, pareto analysis, cause and effect diagrams, mistake proofing, reaction plan & process corrections. '),
(4,2,'6 Process Control', 51, 'Are written improvement plans are implemented to reduce sources of variation? ', 'Documented reaction plan and process corrections. SPC trend charts showing current status vs. goals, improvement plans'),
(4,2,'6 Process Control', 52, 'Is process capability is measured and actions are taken to maintain established minimum Cpk/Ppk targets?', 'Documented process capability studies and results (actual vs target Cpk/Ppk)'),
(4,2,'6 Process Control', 53, 'Are out of control conditions are noted on charts and documented corrective action is taken to bring the process back into control?', 'Control charts'),
(4,2,'7 Maintenance', 54, 'Are tools stored in an appropriate, clearly defined area, with systematic tracking that provides traceability, particularly of customer-owned tools and equipment?', 'Review of storage area, labelling, tooling records'),
(4,2,'7 Maintenance', 55, 'Does a formal preventive maintenance system (PM) exist for production equipment, tools and fixtures?', 'Review of system, PM plans, PM schedule and compliance results'),
(4,2,'7 Maintenance', 56, 'Is the preventive maintenance schedule is followed since product cannot be made with tools that are outside of maintenance period?', 'No equipment, tools, or fixtures are in use that are outside TPM schedule, or have unclear status'),
(4,2,'8 Training & Awareness', 57, 'Is the skill and education level required for each job documented and appropriate training provided?', 'Look for use of training aids and work instructions at work stations'),
(4,2,'8 Training & Awareness', 58, 'Is employee qualification/certification maintained where the quality outcome of the process cannot be verified and is strongly dependent upon operator skill?', 'Qualification records, certification history'),
(4,2,'8 Training & Awareness', 59, 'Are suitable methods used to verify training effectiveness?', 'Records of testing, production quality records, audit records, interview workers to validate training records '),
(4,2,'8 Training & Awareness', 60, 'Are suitable records of maintained?', 'Job descriptions, job skills assessment, training records, training manuals'),
(4,2,'9 Continuous Improvement ', 61, 'Are preventive actions taken based on the analysis of significant business trends, design reviews, customer satisfaction surveys or other meaningful inputs? ', 'Management review meetings, goal setting, performance measurement, internal audits, action plans, customer surveys'),
(4,2,'9 Continuous Improvement ', 62, 'Is there a formal approach used to actively pursue cost containment and other continual improvement activities throughout the organization?', 'Employee involvement/recognition program, Lean, Six Sigma, kaizen, SPC, 5-S, cost reduction programme'),
(4,2,'9 Continuous Improvement ', 63, 'Is a corrective action system in place that provides root cause analysis and takes timely and effective action to prevent recurrence?', 'Corrective actions, trend charts, meeting minutes, non-conformance frequency & cost analysis'),
(4,2,'9 Continuous Improvement ', 64, 'Does the corrective action system cover customer, internal and supplier issues?', 'Management review meetings and corrective actions')


UPDATE tbl_audit_type set Audit_Type='5S Audit (Shop Floor)' WHERE ID=6

SET IDENTITY_INSERT [dbo].[tbl_audit_type] ON 

GO
INSERT [dbo].[tbl_audit_type] ([ID], [Audit_Type], [module_id], [Status], [Color_code], [Parts], [display_seq])
 VALUES (8, N'5S Audit (Office)', 2, 1, N'#283747', NULL, 4)
GO

SET IDENTITY_INSERT [dbo].[tbl_audit_type] OFF
GO


select * from tbl_question_master where Audit_type_id=6


select * into temp5S from tbl_question_master where Audit_type_id=6
DELETE FROM tbl_question_master where Audit_type_id=6



select * from tbl_section_master

INSERT INTO tbl_question_master(module_id,Audit_type_id ,section_id,question_id, question,help_text )
VALUES
(2,6,8, 1, 'No irrelevant reference materials, documents, drawings, etc.', 'Cabinets and shelves'),
(2,6,8, 2, 'No irrelevant reference materials, documents, etc.', 'Desks and tables'),
(2,6,8, 3, 'No excess pieces of equipment, documents, etc.', 'Drawers'),
(2,6,8, 4, 'Storage area is defined to store unneeded items and out-dated documents', 'Other storage area'),
(2,6,8, 5, 'Standards for eliminating unnecessary items exist and are being followed', 'Standards for disposal'),
(2,6,9, 6, 'Locations of tools and equipment are clear and well organized', 'Tools and equipment'),
(2,6,9, 7, 'Locations of materials and products are clear and well organized', 'Materials and products'),
(2,6,9, 8, 'Labels exist to indicate locations, containers, boxes, shelves & stored items', 'Labeling'),
(2,6,9, 9, 'Evidence of inventory control exists (i.e. Kanban cards, FIFO, min & max)', 'Inventory control'),
(2,6,9, 10, 'Dividing lines are clearly identified and clean as per standard', 'Outlining / dividing lines'),
(2,6,9, 11, 'Safety equipment and supplies are clear and in good condition', 'Safety'),
(2,6,10, 12, 'Floors, walls, ceilings & pipework are in good condition & free from dirt/dust', 'Building structure'),
(2,6,10, 13, 'Racks, cabinets and shelves are kept clean', 'Racks and cabinets'),
(2,6,10, 14, 'Machines, equipment and tools are kept clean', 'Machines and tools'),
(2,6,10, 15, 'Stored items, materials and products are kept clean', 'Stored items'),
(2,6,10, 16, 'Lighting is enough and all lighting is free from dust', 'Lighting'),
(2,6,10, 17, 'Good movement of air exists through the room (limits the spread of viruses)', 'Ventilation'),
(2,6,10, 18, 'Pest control exists and effective', 'Pest control'),
(2,6,10, 19, 'Cleaning tools and materials are easily accessible', 'Cleaning tools'),
(2,6,10, 20, 'Cleaning assignments are defined and are being followed', 'Cleaning responsibilities'),
(2,6,11, 21, 'Information displays, signs, color coding & other markings are established', 'Visual controls'),
(2,6,11, 22, 'Procedures for maintaining the first three S''s are being displayed', 'Procedures'),
(2,6,11, 23, '5S checklists, schedules and routines are defined and being used', '5S documentation'),
(2,6,11, 24, 'Everyone knows his responsibilities, when and how', 'Responsibilities'),
(2,6,11, 25, 'Regular audits are carried out using checklists and measures ', 'Regular Audits'),
(2,6,12, 26, '5S seems to be the way of life rather than just a routine', '5S System'),
(2,6,12, 27, 'Success stories are being displayed (i.e. before and after pictures)', 'Success stories'),
(2,6,12, 28, 'Rewards and recognition is part of the 5S system', 'Rewards and recognition')



INSERT INTO tbl_question_master(module_id,Audit_type_id ,section_id,question_id, question,help_text )
VALUES
(2,8,8, 1, 'No irrelevant reference materials, documents, drawings, etc.', 'Cabinets and shelves'),
(2,8,8, 2, 'No irrelevant reference materials, documents, etc.', 'Desks and tables'),
(2,8,8, 3, 'No excess pieces of equipment, documents, etc.', 'Drawers'),
(2,8,8, 4, 'Storage area is defined to store unneeded items and out-dated documents', 'Other storage area'),
(2,8,8, 5, 'Standards for eliminating unnecessary items exist and are being followed', 'Standards for disposal'),
(2,8,9, 6, 'Desks and cabinets are free of accumulations of papers and other objects', 'Desks, shelves & cabinets'),
(2,8,9, 7, 'All tools and equipment are stored in a fixed place', 'Tools and equipment'),
(2,8,9, 8, 'Tools and equipment are well organized for ease of take and return', 'Easy of take and return'),
(2,8,9, 9, 'Labeling of cabinets, shelves and files allows immediate identification', 'Storage labels'),
(2,8,9, 10, 'Documents are filed in accordance with the Record Retention Guidelines', 'Documents'),
(2,8,9, 11, 'Displays are tidy, free of clutter, labeled and up-to-date', 'Display areas'),
(2,8,9, 12, 'Safety equipment easily accessible and in good condition', 'Safety'),
(2,8,10, 13, 'The floor is kept clean and no signs of damage', 'Floor'),
(2,8,10, 14, 'Walls and ceilings are in good condition and free from dirt/dust', 'Building structure'),
(2,8,10, 15, 'Racks and cabinets are kept clean and in good condition', 'Racks and cabinets'),
(2,8,10, 16, 'Equipment and tools are kept clean and in good condition', 'Equipment and tools'),
(2,8,10, 17, 'Desks, tables and other furniture are kept clean', 'Furniture'),
(2,8,10, 18, 'Lighting is enough & the angle and intensity of illumination are appropriate', 'Lighting'),
(2,8,10, 19, 'Good movement of air exist through the room', 'Ventilation'),
(2,8,10, 20, 'Trash containers are emptied on a regular basis', 'Trash containers'),
(2,8,11, 21, 'Visual controls and display boards are used and regularly updated', 'Display boards'),
(2,8,11, 22, 'Procedures for maintaining the first three S''s are being displayed', 'Procedures'),
(2,8,11, 23, '5S checklists, schedules and routines are defined and being used', '5S documentation'),
(2,8,11, 24, 'Everyone knows his responsibilities, when and how', 'Responsibilities'),
(2,8,11, 25, 'Regular audits are taking place using checklists and measures ', 'Regular Audits'),
(2,8,12, 26, '5S seems to be the way of life rather than just a routine', '5S System'),
(2,8,12, 27, 'Success stories are being displayed (i.e. before and after pictures)', 'Success stories'),
(2,8,12, 28, 'Rewards and recognition is part of the 5S system', 'Rewards and recognition')


DELETE FROM [tbl_audit_type] WHERE ID=2008
SET IDENTITY_INSERT [dbo].[tbl_audit_type] ON 

GO
INSERT [dbo].[tbl_audit_type] ([ID], [Audit_Type], [module_id], [Status], [Color_code], [Parts], [display_seq])
 VALUES (9, N'Layered Process Audit', 2, 1, N'#283747', NULL, 3)
GO

SET IDENTITY_INSERT [dbo].[tbl_audit_type] OFF
GO

select * from tbl_question_master where Audit_type_id=2008

INSERT INTO tbl_question_master(module_id,Audit_type_id ,question_id, question )
VALUES
(2,9,1,'Part/Product : Error Proofing System')
,(2,9,2,'Part/Product : First Piece Inspection')
,(2,9,3,'Part/Product : Last piece Inspection')
,(2,9,4,'Part/Product : Standard Work Instruction Present')
,(2,9,5,'Part/Product : Operator Training Track Sheet')
,(2,9,6,'Part/Product : Safety issue is taken care')
,(2,9,7,'Process : Set up Sheet is available?')
,(2,9,8,'Process : SPC/MSA Compliance')
,(2,9,9,'Process : Tooling Approval Available')
,(2,9,10,'Process : Quality Gate Data')
,(2,9,11,'Process : POKE YOKE is working')
,(2,9,12,'System : Preventive Maintenance')
,(2,9,13,'System : Calibration of the measuring instrument is done')
,(2,9,14,'System : Identification and Traceability')
,(2,9,15,'System : 5 S is done or not?')
,(2,9,16,'System : Voice of Customer or Customer Feedback')
,(2,9,17,'System : Quality issue from customer is displayed')
,(2,9,18,'System : Customer Delivery performance is displayed')
,(2,9,19,'System : OK not OK part is available?')
,(2,9,20,'Assembly : Are the line marks are proper')
,(2,9,21,'Assembly : Tools and moulds are kept in designated area')
,(2,9,22,'Assembly : RED Bin is available to keep the scrap parts')
,(2,9,23,'Assembly : Rework and Repair station available')
