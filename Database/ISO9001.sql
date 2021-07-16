--select * from tbl_audit_type

--select * from tbl_question_master where module_id=1 and Audit_type_id=2010

DELETE FROM  tbl_question_master where module_id=1 and Audit_type_id=2010

INSERT INTO tbl_question_master(module_id,Audit_type_id,question_id, question, clause,section_name, help_text)
VALUES(1,2010,1, 'Has the organization determined external and internal issues relevant to its purpose and strategic direction? If yes, how?', '4.1', '4. Context of the Organization', 'The organization shall determine external and internal issues that are relevant to its purpose and its strategic direction and that affect its ability to achieve the intended result(s) of its quality management system.'),
(1,2010,2, 'Do these issues affect the ability to achieve the intended result of the QMS? If yes, how so?', '4.1', '4. Context of the Organization', 'The organization shall determine external and internal issues that are relevant to its purpose and its strategic direction and that affect its ability to achieve the intended result(s) of its quality management system.'),
(1,2010,3, 'Do you monitor and review information about these internal and external issues? If so, how are they monitored?', '4.2', '4. Context of the Organization', '1) Understanding the external context can be facilitated by considering issues arising from legal, technological, competitive, market, cultural, social, and economic environments, whether international, national, regional or local. 
2)Understanding the internal context can be facilitated by considering issues related to values, culture knowledge and performance of the organization.'),
(1,2010,4, 'Have you determined what interested parties are relevant to the QMS? How have you determined these?', '4.2', '4. Context of the Organization', 'Potential impact on the organization’s ability to consistently provide products and services that meet customer and applicable statutory and regulatory requirements, the organization shall determine: 
1) the interested parties that are relevant to the quality management system; 
2) the requirements of these interested parties that are relevant to the quality management system.'),
(1,2010,5, 'Has impact or potential impact been determined? How has it been determined?', '4.2', '4. Context of the Organization', 'Potential impact on the organization’s ability to consistently provide products and services that meet customer and applicable statutory and regulatory requirements, the organization shall determine: 
1) the interested parties that are relevant to the quality management system; 
2) the requirements of these interested parties that are relevant to the quality management system.'),
(1,2010,6, 'Do you monitor and review the information about interested parties and their relevant requirements? How do you monitor this information?', '4.2', '4. Context of the Organization', 'The organization shall monitor and review the information about these interested parties and their relevant requirements.'),
(1,2010,7, 'Have the boundaries and applicability of the QMS been used to establish the scope of the organization? How have they been used?', '4.3', '4. Context of the Organization', 'The organization shall determine the boundaries and applicability of the quality management system to establish its scope'),
(1,2010,8, 'Have: The external and internal issues; The requirements of relevant interested parties and; The products and services of the organization been considered when determining the scope of the organization? How have they been considered?', '4.3', '4. Context of the Organization', 'When determining this scope, the organization shall consider: 
1) the external and internal issues referred to in 4.1; 
2) the requirements of relevant interested parties referred to in 4.2; 
3) the products and services of the organization.'),
(1,2010,9, 'Has the application of the International Standard within the scope been determined? How has it been determined and how has it been applied by the organization?', '4.3', '4. Context of the Organization', 'Where a requirement of this International Standard within the determined scope can be applied, then 
it shall be applied by the organization.'),
(1,2010,10, 'Have any requirements of the International Standard been determined as not applicable? How were they determined as not applicable? Show how conformity of products and services are not affected by this.', '4.3', '4. Context of the Organization', 'If any requirement(s) of this International Standard cannot be applied, this shall not affect the organization’s ability or responsibility to ensure conformity of products and services.'),
(1,2010,11, 'Where is the scope available? Where is it maintained as documented information? 
Does it state what products and services are covered by the QMS? Does it justify how instances of requirements of the QMS cannot be applied?', '4.3', '4. Context of the Organization', 'The scope shall be available and be maintained as documented information stating the: 
1) products and services covered by the quality management system; 
2)justifications for any instance where a requirement of this International Standard cannot be applied.'),
(1,2010,12, 'How has the QMS been established? Show how this is implemented. How is it maintained and continually improved? How 
have the processes been determined and how do they interact?', '4.4', '4. Context of the Organization', 'The organization shall establish, implement, maintain and continually improve a quality management system, including the processes needed and their interactions, in accordance with the requirements of this International Standard.'),
(1,2010,13, 'How have the processes been determined 
for the QMS? 
What are the inputs and outputs for those 
processes? 
What is the sequence and interaction of the 
processes? ', '4.4', '4. Context of the Organization', '1) the inputs required and the outputs expected from these processes; 
2) the sequence and interaction of these processes; 
3) the criteria, methods, including measurements and related performance indicators needed to ensure the effective operation, and control of these processes; 
4) the resources needed and ensure their availability; 
5) the assignment of the responsibilities and authorities for these processes; 
6) the risks and opportunities in accordance with the requirements of 6.1, and plan and implement the appropriate actions to address them; 
7) the methods for monitoring, measuring, as appropriate, and evaluation of processes and, if needed, the changes to processes to ensure that they achieve intended results; 
8) opportunities for improvement of the processes and the quality management system.'),
(1,2010,14, 'What documented information exists to support the operation of processes? How is this documented information retained? How is confidence that the processes are being carried out as planned determined?', '4.4', '4. Context of the Organization', 'The organization shall maintain documented information to the extent necessary to support the operation of processes and retain documented information to the extent necessary to have confidence that the processes are being carried out as planned.'),
(1,2010,15, 'How is the quality policy and objectives 
established for the QMS and how are they 
compatible with the strategic direction and 
the organizational context? ', '5.1.1', '5. Leadership', '1) taking accountability of the effectiveness of the quality management system; 
2) ensuring that the quality policy and quality objectives are established for the quality management system and are compatible with the strategic direction and the context of the organization; 
3) ensuring that the quality policy is communicated, understood and applied within the organization; 
4) ensuring the integration of the quality management system requirements into the organization’s business processes; 
5) promoting awareness of the process approach; f) ensuring that the resources needed for the quality management system are available; 
6) communicating the importance of effective quality management and of conforming to the quality management system requirements; 
7) ensuring that the quality management system achieves its intended results; 
8) engaging, directing and supporting persons to contribute to the effectiveness of the quality management system; 
9) promoting continual improvement; 
10) supporting other relevant management roles to demonstrate their leadership as it applies to their areas of responsibility.'),
(1,2010,16, 'How is the quality policy communicated 
within the organization? Show how this 
is understood and applied. 
How are the requirements of the QMS 
integrated into the business processes? ', '5.1.1', '5. Leadership', ''),
(1,2010,17, 'How do you promote awareness of the 
process approach?', '5.1.1', '5. Leadership', ''),
(1,2010,18, 'How do you ensure that resources needed 
for the QMS are available? ', '5.1.1', '5. Leadership', ''),
(1,2010,19, 'How do you communicate the importance 
of effective quality management?', '5.1.1', '5. Leadership', ''),
(1,2010,20, 'How do you communicate the importance of conforming to the QMS requirements? How do you ensure that the QMS achieves its intended results?', '5.1.1', '5. Leadership', ''),
(1,2010,21, 'How do you engage, direct and support people to contribute to the effectiveness of the QMS? ', '5.1.1', '5. Leadership', ''),
(1,2010,22, 'How do you promote continual improvement? How do you support other relevant management roles to demonstrate leadership in their areas of responsibility?', '5.1.1', '5. Leadership', ''),
(1,2010,24, 'How does top management establish, review and maintain a quality policy? 
How is it determined to be appropriate to the purpose and context of the organization? 
Does it provide a framework for setting and reviewing quality objectives? 
Does it contain a commitment to satisfy applicable requirements? 
Does it include a commitment to continual improvement of the QMS?', '5.2.1', '5. Leadership', 'Top management shall establish, review and maintain a quality policy that: 
1) is appropriate to the purpose and context of the organization; 
2) provides a framework for setting and reviewing quality objectives; 
3) includes a commitment to satisfy applicable requirements; 
4) includes a commitment to continual improvement of the quality management system.'),
(1,2010,25, 'Where is the quality policy available as documented information? 
How is it communicated? how it is understood and applied within the organization?
How have you made it available to relevant interested parties?', '5.2.2', '5. Leadership', 'The quality policy shall: 
1) be available as documented information; 
2) be communicated, understood and applied within the organization; 
3) be available to relevant interested parties, as appropriate.'),
(1,2010,26, 'How does top management ensure that responsibilities and authorities for relevant roles are assigned, communicated and understood within the organization?', '5.3', '5. Leadership', 'Top management shall ensure that the responsibilities and authorities for relevant roles are assigned, communicated and understood within the organization.'),
(1,2010,27, 'How does top management assign the responsibility and authority for: Ensuring that the QMS conforms to the International standard? ', '5.3', '5. Leadership', 'Top management shall assign the responsibility and authority for: 
1) ensuring that the quality management system conforms to the requirements of this International Standard; 
2) ensuring that the processes are delivering their intended outputs; 
3) reporting on the performance of the quality management system, on opportunities for improvement and on the need for change or innovation, and especially for reporting to top management; 
4) ensuring the promotion of customer focus throughout the organization; 
5) ensuring that the integrity of the quality management system is maintained when changes to the quality management system are planned and implemented.'),
(1,2010,28, 'How is the performance of the QMS,opportunities for improvement and the need for change or innovation reported to top management? ', '5.3', '5. Leadership', 'Top management shall assign the responsibility and authority for: 
a) ensuring that the quality management system conforms to the requirements of this International Standard; 
b) ensuring that the processes are delivering their intended outputs; 
c) reporting on the performance of the quality management system, on opportunities for improvement and on the need for change or innovation, and especially for reporting to top management; 
d) ensuring the promotion of customer focus throughout the organization; 
e) ensuring that the integrity of the quality management system is maintained when changes to the quality management system are planned and implemented.'),
(1,2010,29, 'How is customer focus promoted within the organization? ', '5.3', '5. Leadership', 'Top management shall assign the responsibility and authority for: 
1) ensuring that the quality management system conforms to the requirements of this International Standard; 
2) ensuring that the processes are delivering their intended outputs; 
3) reporting on the performance of the quality management system, on opportunities for improvement and on the need for change or innovation, and especially for reporting to top management; 
4) ensuring the promotion of customer focus throughout the organization; 
5) ensuring that the integrity of the quality management system is maintained when changes to the quality management system are planned and implemented.'),
(1,2010,30, 'How is the integrity of the QMS maintained when changes to the QMS are planned and 
implemented?', '5.3', '5. Leadership', 'Top management shall assign the responsibility and authority for: 
1) ensuring that the quality management system conforms to the requirements of this International Standard; 
2) ensuring that the processes are delivering their intended outputs; 
3) reporting on the performance of the quality management system, on opportunities for improvement and on the need for change or innovation, and especially for reporting to top management; 
4) ensuring the promotion of customer focus throughout the organization; 
5) ensuring that the integrity of the quality management system is maintained when changes to the quality management system are planned and implemented.'),
(1,2010,31, 'How are the internal and external issues and interested parties considered when planning for the QMS? ', '6.1.1', '6. Planning for the quality management system', '1) give assurance that the quality management system can achieve its intended result(s); 
2) prevent, or reduce, undesired effects; 
3) achieve continual improvement.'),
(1,2010,32, 'How are actions planned to address risks and opportunities? 
How are actions integrated and implemented into the QMS processes? 
How do you evaluate the effectiveness of the actions?', '6.1.2', '6. Planning for the quality management system', 'The organization shall plan: 
1) actions to address these risks and opportunities; 
2) how to: a)integrate and implement the actions into its quality management system processes (see 4.4); b) evaluate the effectiveness of these actions.'),
(1,2010,33, 'How are actions taken to address risks and opportunities determined as being 
appropriate to the potential impact on the conformity of products and services?', '6.1.2', '6. Planning for the quality management system', 'Actions taken to address risks and opportunities shall be proportionate to the potential impact on the conformity of products and services.'),
(1,2010,34, 'How do you determine that personnel with product design responsibility are competent 
to achieve design requirements? How do you determine skills required in applicable 
tools and techniques? How do you identify applicable tools and techniques?', '6.2.2.1', '6. Planning for the quality management system', 'The organization shall ensure that personnel with product design responsibility are competent to achieve design requirements and are skilled in applicable tools and techniques. 
Applicable tools and techniques shall be identified by the organization.'),
(1,2010,35, 'Where are the quality objectives and are these at all relevant functions, levels and processes? ', '6.2.1', '6. Planning for the quality management system', 'The quality objectives shall: 
1) be consistent with the quality policy, 
2) be measurable; 
3) take into account applicable requirements; 
4) be relevant to conformity of products and services and the enhancement of customer satisfaction; 
5) be monitored; 
6) be communicated; 
7) be updated as appropriate. 
The organization shall retain documented information on the quality objectives.'),
(1,2010,36, 'Are they consistent with the quality policy? 
Are they measureable? 
Do they consider applicable requirements? ', '6.2.1', '6. Planning for the quality management system', 'The quality objectives shall: 
1) be consistent with the quality policy, 
2) be measurable; 
3) take into account applicable requirements; 
4) be relevant to conformity of products and services and the enhancement of customer satisfaction; 
5) be monitored; 
6) be communicated; 
7) be updated as appropriate. 
The organization shall retain documented information on the quality objectives.'),
(1,2010,37, 'Are they relevant to the conformity of products and services and do they enhance customer satisfaction? 
Are they monitored? How? How often? ', '6.2.1', '6. Planning for the quality management system', 'The quality objectives shall: 
1) be consistent with the quality policy, 
2) be measurable; 
3) take into account applicable requirements; 
4) be relevant to conformity of products and services and the enhancement of customer satisfaction; 
5) be monitored; 
6) be communicated; 
7) be updated as appropriate. 
The organization shall retain documented information on the quality objectives.'),
(1,2010,38, 'How are they communicated? 
How are they updated? 
Where is the documented information on 
the quality objectives?', '6.2.1', '6. Planning for the quality management system', 'The quality objectives shall: 
1) be consistent with the quality policy, 
2) be measurable; 
3) take into account applicable requirements; 
4) be relevant to conformity of products and services and the enhancement of customer satisfaction; 
5) be monitored; 
6) be communicated; 
7) be updated as appropriate. 
The organization shall retain documented information on the quality objectives.'),
(1,2010,39, 'How does the organization determine what will be done, with what resources, when 
completed and how will results be evaluated for quality objectives?', '6.2.2', '6. Planning for the quality management system', 'When planning how to achieve its quality objectives, the organization shall determine:
1) what will be done; 
2) what resources will be required; 
3) who will be responsible; 
4) when it will be completed; 
5) how the results will be evaluated.'),
(1,2010,40, 'How are changes to the QMS planned systematically? ', '6.3', '6. Planning for the quality management system', 'The organization shall consider: 
1) the purpose of the change and any of its potential consequences; 
2) the integrity of the quality management system; 
3) the availability of resources; 
4) the allocation or reallocation of responsibilities and authorities.'),
(1,2010,41, 'how resources are determined for the establishment, implementation, maintenance and continual improvement of the QMS. ', '7.1.1', '7. Support', 'The organization shall consider: 
1) the capabilities of, and constraints on, existing internal resources; 
2) what needs to be obtained from external providers'),
(1,2010,42, 'how the capabilities and constraints on internal resources are considered. ', '7.1.1', '7. Support', 'The organization shall consider: 
1) the capabilities of, and constraints on, existing internal resources; 
2) what needs to be obtained from external providers'),
(1,2010,43, 'how needs from external providers are considered.', '7.1.1', '7. Support', 'The organization shall consider: 
1) the capabilities of, and constraints on, existing internal resources; 
2) what needs to be obtained from external providers'),
(1,2010,44, 'How do you provide persons necessary to consistently meet customer, applicable statutory and regulatory requirements for the QMS including the necessary processes?', '7.1.2', '7. Support', 'To ensure that the organization can consistently meet customer and applicable statutory and regulatory requirements, the organization shall provide the persons necessary for the effective operation of the quality management system, including the processes needed.'),
(1,2010,45, 'The organization shall determine, provide and maintain the infrastructure for the operation of its processes to achieve conformity of products and services.', '7.1.3', '7. Support', 'Any product realization change affecting customer requirements requires notification to, and agreement from, the customer'),
(1,2010,46, 'How do you determine, provide and maintain the environment for the operation 
of processes to achieve products and service conformity?', '7.1.4', '7. Support', 'The organization shall determine, provide and maintain the environment necessary for the operation of its processes and to achieve conformity of products and services.'),
(1,2010,47, 'How are the resources determined for ensuring valid and reliable monitoring and 
measuring results, where used?', '7.1.5', '7. Support', 'Where monitoring or measuring is used for evidence of conformity of products and services to specified requirements the organization shall determine the resources needed to ensure valid and reliable monitoring and measuring results.'),
(1,2010,48, 'How do you ensure that resources provided are suitable for the specific monitoring and measurement activities and are maintained to ensure continued fitness ', '7.1.5', '7. Support', 'The organization shall ensure that the resources provided: 
1) are suitable for the specific type of monitoring and measurement activities being undertaken; 
2) are maintained to ensure their continued fitness for their purpose.'),
(1,2010,49, 'Show the documented information which is evidence of fitness for purpose of monitoring and measurement resources.', '7.1.5', '7. Support', 'The organization shall retain appropriate documented information as evidence of fitness for purpose of monitoring and measurement resources'),
(1,2010,50, 'Where applicable, show how measurement instruments are: Verified or calibrated at specified intervals against national or international measurement standards; ', '7.1.5', '7. Support', 'Where measurement traceability is: a statutory or regulatory requirement; a customer or relevant interested party expectation; or considered by the organization to be an essential part of providing confidence in the validity of measurement results; measuring instruments'),
(1,2010,51, 'How do you determine the validity of previous measurements if you find an instrument to be defective during verification or calibration? What appropriate actions can you take?', '7.1.5', '7. Support', 'The organization shall determine if the validity of previous measurement results has been adversely affected when an instrument is found to be defective during its planned verification or calibration, or during its use, and take appropriate corrective action as necessary.'),
(1,2010,52, 'How do you determine necessary knowledge for the operation of processes? How do you determine necessary knowledge to achieve conformity of products and services?', '7.1.6', '7. Support', 'The organization shall determine the knowledge necessary for the operation of its processes and to achieve conformity of products and services'),
(1,2010,53, 'How do you maintain this knowledge and how do you make it available to the extent necessary?', '7.1.6', '7. Support', 'This knowledge shall be maintained, and made available to the extent necessary.'),
(1,2010,54, 'How do you consider current knowledge and how do you acquire additional knowledge when addressing changing needs and trends?', '7.1.6', '7. Support', 'When addressing changing needs and trends, the organization shall consider its current knowledge and determine how to acquire or access the necessary additional knowledge.'),
(1,2010,55, 'How do You determine the necessary competence of people doing work under your control that affects quality performance; How do you determine competence on the basis of appropriate education, training or 
experience? How do you take actions to acquire necessary competence where applicable and how do you evaluate the effectiveness of those actions? Show documented information where appropriate of competence.', '7.2', '7. Support', 'The organization shall: 
1) determine the necessary competence of person(s) doing work under its control that affects its quality performance; 
2) ensure that these persons are competent on the basis of appropriate education, training, or experience; 
3) where applicable, take actions to acquire the necessary competence, and evaluate the effectiveness of the actions taken; 
4) retain appropriate documented information as evidence of competence.'),
(1,2010,56, 'How are people aware of: The quality policy? Relevant quality objectives? Their contribution to the effectiveness of the QMS? The benefits of improved performance? The implications of not conforming with the QMS requirements?', '7.3', '7. Support', 'Persons doing work under the organization’s control shall be aware of: 
1) the quality policy; 
2) relevant quality objectives; 
3) their contribution to the effectiveness of the quality management system, including the benefits of improved quality performance; 
4) the implications of not conforming with the quality management system requirements.'),
(1,2010,57, 'How do you determine internal and external communications relevant to the QMS? How do you determine: What? When? With Whom? How?', '7.4', '7. Support', 'The organization shall determine the internal and external communications relevant to the quality management system including: 
1) on what it will communicate; 
2) when to communicate; 
3) with whom to communicate; 
4) how to communicate'),
(1,2010,58, 'What documented information do you have as required by this standard? What documented information do you have as being necessary for the effectiveness of your QMS?', '7.5.1', '7. Support', 'The organization’s quality management system shall include: 
1) documented information required by this International Standard; 
2) documented information determined by the organization as being necessary for the effectiveness of the quality management system.'),
(1,2010,59, 'Show that your documented information contains: Identification; Description; In what media format? Show how the documented information is reviewed and approved for suitability and adequacy.', '7.5.2', '7. Support', 'When creating and updating documented information the organization shall ensure appropriate: 
1) identification and description (e.g. a title, date, author, or reference number); 
2) format (e.g. language, software version, graphics) and media (e.g. paper, electronic); 3) review and approval for suitability and adequacy.'),
(1,2010,60, 'Show how you control documented information. Show how you make it available and suitable for use. How do you protect your documented information?', '7.5.3.1', '7. Support', 'Documented information required by the quality management system and by this International Standard shall be controlled to ensure: 
1) it is available and suitable for use, where and when it is needed; 
2) it is adequately protected (e.g. from loss of confidentiality, improper use, or loss of integrity).'),
(1,2010,61, 'When controlling documented information, how do you address: 
Distribution; Access; Retrieval; Use; 
Storage and preservation; Legibility; 
Control of changes; Retention and disposition.', '7.5.3.2', '7. Support', 'For the control of documented information, the organization shall address the following activities, as applicable: 
1) distribution, access, retrieval and use; b) storage and preservation, including preservation of legibility; 
2) control of changes (e.g. version control); 
3) retention and disposition.'),
(1,2010,62, 'How do you identify as appropriate and control documented information of external origin which you have determined as necessary for the QMS', '7.5.3.2', '7. Support', 'Documented information of external origin determined by the organization to be necessary for the planning and operation of the quality management system shall be identified as appropriate, and controlled'),
(1,2010,63, 'How are processes needed to meet requirements for provision of products and services planned, implemented and controlled? How are requirements for products and services determined? How is criteria for processes and acceptance for products and services determined? How are resources determined? How is process control implemented?  the documented information that shows confidence in that the processes have been carried out as planned and can demonstrate conformity of products and services.', '8.1', '8. Operation', '1) determining requirements for the product and services; 
2) establishing criteria for the processes and for the acceptance of products and services; 
3) determining the resources needed to achieve conformity to product and service requirements; 
4) implementing control of the processes in accordance with the criteria; 
5) retaining documented information to the extent necessary to have confidence that the processes have been carried out as planned and to demonstrate conformity of products and services to requirements'),
(1,2010,64, 'How have you determined that the output from the planning process is suitable for your operations?', '8.1', '8. Operation', 'The output of this planning shall be suitable for the organization''s operations.'),
(1,2010,65, 'How do you control planned changes? How do you review the consequences of unintended changes? What action is taken to mitigate any adverse effects?', '8.1', '8. Operation', 'The organization shall control planned changes and review the consequences of unintended changes, taking action to mitigate any adverse effects, as necessary'),
(1,2010,66, 'How do you control outsourced processes?', '8.1', '8. Operation', 'The organization shall ensure that outsourced processes are controlled in accordance with 8.4.'),
(1,2010,67, 'What are your processes for communicating with customers? How do you communicate information relating to: Products; Services; Enquiries; Contracts; Order handling; customer views, perceptions and complaints; Handling or treatment of customer 
property; Specific requirements for contingency actions?', '8.2.1', '8. Operation', '1) information relating to products and services; 
2) enquiries, contracts or order handling, including changes; 
3) obtaining customer views and perceptions, including customer complaints; 
4) the handling or treatment of customer property, if applicable; 
5) specific requirements for contingency actions, when relevant'),
(1,2010,68, 'What is your process to determine the requirements for products and services to be offered to potential customers? How do 
you establish, implement and maintain this process?', '8.2.2', '8. Operation', 'The organization shall establish, implement and maintain a process to determine the requirements for the products and services to be offered to potential customers'),
(1,2010,69, 'How do you define product and service requirements including statutory and regulatory requirements? How do you ensure that you have the ability to meet the defined requirements and substantiate any claims for your products and services?', '8.2.2', '8. Operation', '1) product and service requirements (including those considered necessary by the organization), and applicable statutory and regulatory requirements, are defined; 
2) it has the ability to meet the defined requirements and substantiate the claims for the products and services it offers'),
(1,2010,70, 'How do you review: Customer requirements for delivery and post-delivery? Requirements necessary for customers’ specified or intended use, where known; Additional statutory and regulatory requirements applicable to products and services; Any other contract or order requirements.', '8.2.3', '8. Operation', '1) requirements specified by the customer, including the requirements for delivery and post- delivery activities; 
2) requirements not stated by the customer, but necessary for the customers'' specified or intended use, when known; 
3) additional statutory and regulatory requirements applicable to the products and services; 
4) contract or order requirements differing from those previously expressed'),
(1,2010,71, ' that the review is conducted prior to your commitment to supply products and services to your customers. How do you resolve contract or order requirements which differ from those previously defined?', '8.2.3', '8. Operation', 'This review shall be conducted prior to the organization’s commitment to supply products and services to the customer and shall ensure contract or order requirements differing from those previously defined are resolved.'),
(1,2010,72, 'How do you confirm customer 
requirements where the customer does not provide a documented statement?', '8.2.3', '8. Operation', 'Where the customer does not provide a documented statement of their requirements, the customer requirements shall be confirmed by the organization before acceptance'),
(1,2010,73, ' where you retain documented information which describes results of the review including any new or changed requirements', '8.2.3', '8. Operation', 'Documented information describing the results of the review, including any new or changed requirements for the products and services, shall be retained.'),
(1,2010,74, ' the documented information containing changes to products and services. How do you ensure that relevant personnel are made aware of those changes?', '8.2.3', '8. Operation', 'Where requirements for products and services are changed, the organization shall ensure that relevant documented information is amended and that relevant personnel are made aware of the changed requirements.'),
(1,2010,75, 'How do you establish, implement and maintain a design and development process (where detailed requirements of your products and services are not already established or defined by the customer or other parties).', '8.3.1', '8. Operation', 'Where the detailed requirements of the organization’s products and services are not already established or not defined by the customer or by other interested parties, such that they are adequate for subsequent production or service provision, the organization shall establish, implement and maintain a design and development process.'),
(1,2010,76, 'When determining the stages and control for design and development, show how you consider: The nature, duration and complexity of the activities; Requirements that specify particular process stages including applicable reviews; Required verification and validation; Responsibilities and authorities; How interfaces are controlled between individuals and parties; ', '8.3.2', '8. Operation', '1) the nature, duration and complexity of the design and development activities; 
2) requirements that specify particular process stages, including applicable design and development reviews; 
3) the required design and development verification and validation; 
4) the responsibilities and authorities involved in the design and development process; 
5) the need to control interfaces between individuals and parties involved in the design and development process; 
6) the need for involvement of customer and user groups in the design and development process; 
8) the necessary documented information to confirm that design and development requirements have been met.'),
(1,2010,77, ' show how you determine: 
Requirements essential for the type of 
products and services being designed and 
developed, including as applicable: 
Functional & performance requirements; Statutory and regulatory requirements; Standards or codes of practice where there is a commitment to implement; Internal and external resources needed for the design and development of products and services; Potential consequences of failure; Level of control expected of the design and development process by customers and other relevant parties.', '8.3.3', '8. Operation', 'a) requirements essential for the specific type of products and services being designed and developed, including, as applicable, functional and performance requirements; 
b) applicable statutory and regulatory requirements; 
c) standards or codes of practice that the organization has committed to implement; 
d) internal and external resource needs for the design and development of products and services; e) the potential consequences of failure due to the nature of the products and services; 
f) the level of control expected of the design and development process by customers and other relevant interested parties'),
(1,2010,78, 'How do you determine that inputs are adequate, complete and unambiguous for design and development? How do you 
resolve conflicts among inputs?', '8.3.3', '8. Operation', 'Inputs shall be adequate for design and development purposes, complete, and unambiguous. Conflicts among inputs shall be resolved.'),
(1,2010,79, 'How do controls that are applied to the design and development process ensure: Results achieved by design and development activities are clearly defined? Design and development reviews are conducted as planned? Outputs meet the input requirements by verification/ Validation is conducted to ensure that the resulting products and services are capable of meeting the requirements for the specified application or intended use (when known)?', '8.3.4', '8. Operation', '1) the results to be achieved by the design and development activities are clearly defined; 
2) design and development reviews are conducted as planned; 
3) verification is conducted to ensure that the design and development outputs have met the design and development input requirements; 
4) validation is conducted to ensure that the resulting products and services are capable of meeting the requirements for the specified application or intended use (when known).'),
(1,2010,80, 'How do you ensure that design and development outputs: Meet the input requirements for design and development? Are adequate for the subsequent processes for the provision of products and services? Include or reference monitoring and measuring requirements, and acceptance criteria, as applicable? 
Ensure products to be produced, or services to be provided, are fit for intended purpose and their safe and proper use?', '8.3.5', '8. Operation', '1) meet the input requirements for design and development; 
2) are adequate for the subsequent processes for the provision of products and services; 
3) include or reference monitoring and measuring requirements, and acceptance criteria, as applicable; 
4) ensure products to be produced, or services to be provided, are fit for intended purpose and their safe and proper use.'),
(1,2010,81, ' the documented information which results from the design and development process.', '8.3.5', '8. Operation', 'The organization shall retain the documented information resulting from the design and development process.'),
(1,2010,82, 'How do you review, control and identify changes made to the design inputs and outputs during design and development of products and services ensuring no impact on conformity to requirements?', '8.3.6', '8. Operation', 'The organization shall review, control and identify changes made to design inputs and design outputs during the design and development of products and services or subsequently, to the extent that there is no adverse impact on conformity to requirements'),
(1,2010,83, 'Show the documented information for design and development changes.', '8.3.6', '8. Operation', 'Documented information on design and development changes shall be retained.'),
(1,2010,84, 'How do you ensure externally provided processes, products and services conform to specified requirements?', '8.4.1', '8. Operation', 'The organization shall ensure that externally provided processes, products, and services conform to specified requirements'),
(1,2010,85, ' how you apply specified requirements for the control of externally provided products and services when: Products and services are provided by external providers for incorporation into your own products and services; You provide products and services directly to customers by external providers on your behalf; A process or part-process is provided by an external provider as a result of a decision to outsource a process or function.', '8.4.1', '8. Operation', '1) products and services are provided by external providers for incorporation into the organization’s own products and services; 
2) products and services are provided directly to the customer(s) by external providers on behalf of the organization; 
3) a process or part of a process is provided by an external provider as a result of a decision by the organization to outsource a process or function.'),
(1,2010,86, 'How you establish and apply criteria for evaluation, selection, monitoring of performance and re-evaluation of external providers. How do you assess their ability to provide processes or products and services in accordance with specified requirements?', '8.4.1', '8. Operation', 'The organization shall establish and apply criteria for the evaluation, selection, monitoring of performance and re-evaluation of external providers based on their ability to provide processes or products and services in accordance with specified requirements.'),
(1,2010,87, 'What documented information do you have of the results of evaluations, monitoring of performance and re- evaluations of external providers?', '8.4.1', '8. Operation', 'The organization shall retain appropriate documented information of the results of the evaluations, monitoring of the performance and re- evaluations of the external providers'),
(1,2010,88, 'How do you determine the controls applied to the external provision of processes, products and services and take into consideration: 
1) The potential impact of the externally provided processes, products and services on the ability to consistently meet customer and applicable statutory and regulatory requirements? 
2) The perceived effectiveness of the controls applied by the external provider?', '8.4.2', '8. Operation', '1) the potential impact of the externally provided processes, products and services on the organization’s ability to consistently meet customer and applicable statutory and regulatory requirements; 
2) the perceived effectiveness of the controls applied by the external provider.'),
(1,2010,89, 'What verification or other activities do you have to ensure externally provided processes, products and services do not adversely affect your ability to consistently deliver conforming products and services to your customers?', '8.4.2', '8. Operation', 'The organization shall establish and implement verification or other activities necessary to ensure the externally provided processes, products and services do not adversely affect the organization''s ability to consistently deliver conforming products and services to its customers.'),
(1,2010,90, 'When processes or functions have been outsourced to external providers, how do you consider a) and b) in 8.4.1 and how do you define the controls intended to be applied to the external provider and to the resulting process output?', '8.4.2', '8. Operation', 'Processes or functions of the organization which have been outsourced to an external provider remain within the scope of the organization’s quality management system; accordingly, the organization shall consider a) and b) above and define both the controls it intends to apply to the external provider and those it intends to apply to the resulting process output.'),
(1,2010,91, ' how you communicate to external providers, applicable requirements 
for: Products and services to be provided or the processes to be performed on behalf of the organization; ', '8.4.3', '8. Operation', '1) the products and services to be provided or the processes to be performed on behalf of the organization; 
2) approval or release of products and services, methods, processes or equipment; 
3) competence of personnel, including necessary qualification; 
4) their interactions with the organization''s quality management system; 
5) the control and monitoring of the external provider''s performance to be applied by the organization; 
6) verification activities that the organization, or its customer, intends to perform at the external provider’s premises.'),
(1,2010,92, 'Before you communicate with external providers, how do you ensure the adequacy of specified requirements?', '8.4.3', '8. Operation', 'The organization shall ensure the adequacy of specified requirements prior to their communication to the external provider.'),
(1,2010,93, 'What controlled conditions do you have for production and service provision, including delivery and post-delivery activities?', '8.5.1', '8. Operation', 'The organization shall implement controlled conditions for production and service provision, including delivery and post-delivery activities.'),
(1,2010,94, ' show controlled conditions for: 
1) the availability of documented information defining the characteristics of the products and services; 
2) the availability of documented information defining the activities to be performed and the results to be achieved; 
3) monitoring and measurement activities at appropriate stages to verify that criteria for control of processes and process outputs, and acceptance criteria for products and services, have been met. ', '', '8. Operation', '1) the availability of documented information that defines the characteristics of the products and services; 
2) the availability of documented information that defines the activities to be performed and the results to be achieved; 
3) monitoring and measurement activities at appropriate stages to verify that criteria for control of processes and process outputs, and acceptance criteria for products and services, have been met. 
4) the use, and control of suitable infrastructure and process environment; 
5) the availability and use of suitable monitoring and measuring resources; 
6) the competence and, where applicable, required qualification of persons; 
7) the validation, and periodic revalidation, of the ability to achieve planned results of any process for production and service provision where the resulting output cannot be verified by subsequent monitoring or measurement; 
8) the implementation of products and services release, delivery and post-delivery activities.'),
(1,2010,95, ' show controlled conditions for: 
1) the use, and control of suitable infrastructure and process environment; 
2) the availability and use of suitable monitoring and measuring resources; 
3) the competence and, where applicable, required qualification of persons;', '', '8. Operation', '1) the availability of documented information that defines the characteristics of the products and services; 
2) the availability of documented information that defines the activities to be performed and the results to be achieved; 
3) monitoring and measurement activities at appropriate stages to verify that criteria for control of processes and process outputs, and acceptance criteria for products and services, have been met. 
4) the use, and control of suitable infrastructure and process environment; 
5) the availability and use of suitable monitoring and measuring resources; 
6) the competence and, where applicable, required qualification of persons; 
7) the validation, and periodic revalidation, of the ability to achieve planned results of any process for production and service provision where the resulting output cannot be verified by subsequent monitoring or measurement; 
8) the implementation of products and services release, delivery and post-delivery activities.'),
(1,2010,96, 'Show how 
1) the validation, and periodic revalidation, of the ability to achieve planned results of any process for production and service provision where the resulting output cannot be verified by subsequent monitoring or measurement; 
2) the implementation of products and services release, delivery and post-delivery activities.', '8.5.1', '8. Operation', '1) the availability of documented information that defines the characteristics of the products and services; 
2) the availability of documented information that defines the activities to be performed and the results to be achieved; 
3) monitoring and measurement activities at appropriate stages to verify that criteria for control of processes and process outputs, and acceptance criteria for products and services, have been met. 
4) the use, and control of suitable infrastructure and process environment; 
5) the availability and use of suitable monitoring and measuring resources; 
6) the competence and, where applicable, required qualification of persons; 
7) the validation, and periodic revalidation, of the ability to achieve planned results of any process for production and service provision where the resulting output cannot be verified by subsequent monitoring or measurement; 
8) the implementation of products and services release, delivery and post-delivery activities.'),
(1,2010,97, 'What means do you use to identify process outputs to ensure conformity of products and services?', '8.5.2', '8. Operation', 'Where necessary to ensure conformity of products and services, the organization shall use suitable means to identify process outputs.'),
(1,2010,98, 'How do you identify the status of process outputs?', '8.5.2', '8. Operation', 'The organization shall identify the status of process outputs with respect to monitoring and measurement requirements throughout production and service provision.'),
(1,2010,99, 'How do you control the unique identification of process outputs, where applicable? What documented information do you retain?', '8.5.2', '8. Operation', 'Where traceability is a requirement, the organization shall control the unique identification of the process outputs, and retain any documented information necessary to maintain traceability'),
(1,2010,100, 'What care do you provide for customer or external provider’s property while under your control? 
How do you identify, verify, protect and safeguard that property which is provided for use or incorporation into your products or services?', '8.5.3', '8. Operation', 'The organization shall exercise care with property belonging to the customer or external providers while it is under the organization''s control or being used by the organization. The organization shall identify, verify, protect and safeguard the customer’s or external provider’s property provided for use or incorporation into the products and services.'),
(1,2010,101, 'What means do you use to report to the customer or external provider if their property is incorrectly used, lost, damaged or found to be unsuitable for use?', '8.5.3', '8. Operation', 'When property of the customer or external provider is incorrectly used, lost, damaged or otherwise found to be unsuitable for use, the organization shall report this to the customer or external provider'),
(1,2010,102, 'How do you ensure preservation of process 
outputs during production and service provision to maintain conformity to product requirements?', '8.5.4', '8. Operation', 'The organization shall ensure preservation of process outputs during production and service provision, to the extent necessary to maintain conformity to requirements'),
(1,2010,103, 'How do you meet requirements for post- delivery activities associated with products and services?', '8.5.5', '8. Operation', 'As applicable, the organization shall meet requirements for post-delivery activities associated with the products and services.'),
(1,2010,104, 'How do you determine: Risk; Nature, use and intended lifetime; Customer feedback; 
Statutory and Regulatory requirements, when determining the extent of post- delivery activities required with products and services?', '8.5.5', '8. Operation', '1) the risks associated with the products and services; 
2) the nature, use and intended lifetime of the products and services; 
3) customer feedback; 
4) statutory and regulatory requirements.'),
(1,2010,105, 'How do you review and control unplanned changes to ensure continuing conformity with specified requirements?', '8.5.6', '8. Operation', 'The organization shall review and control unplanned changes essential for production or service provision to the extent necessary to ensure continuing conformity with specified requirements.'),
(1,2010,106, 'What documented information can you  which describes the results of reviews of changes, the personnel authorizing change and any necessary actions?', '8.5.6', '8. Operation', 'The organization shall retain documented information describing the results of the review of changes, the personnel authorizing the change, and any necessary actions.'),
(1,2010,107, 'how planned arrangement have been implemented at appropriate stages to verify product and service requirements have been met.  what evidence you retain.', '8.6', '8. Operation', 'The organization shall implement the planned arrangements at appropriate stages to verify that product and service requirements have been met. Evidence of conformity with the acceptance criteria shall be retained.'),
(1,2010,108, 'Show how the release of products and services is held until planned arrangements for verification of conformity have been satisfactorily completed, unless approved by a relevant authority, or the customer if applicable. Show documented information which shows traceability to the person authorizing release of products and services.', '8.6', '8. Operation', 'The release of products and services to the customer shall not proceed until the planned arrangements for verification of conformity have been satisfactorily completed, unless otherwise approved by a relevant authority and, as applicable, by the customer. Documented information shall provide traceability to the person(s) authorizing release of products and services for delivery to the customer.'),
(1,2010,109, 'How do you identify and control process outputs, products and services that do not conform to requirements and prevent their unintended use or delivery?', '8.7', '8. Operation', 'The organization shall ensure process outputs, products and services that do not conform to requirements are identified and controlled to prevent their unintended use or delivery.'),
(1,2010,110, 'What appropriate corrective actions are taken based on the nature of the nonconformity and its impact on the conformity of products and services? How do you apply this to nonconformity detected after delivery?', '8.7', '8. Operation', 'The organization shall take appropriate corrective action based on the nature of the nonconformity and its impact on the conformity of products and services. This applies also to nonconforming products and services detected after delivery of the products or during the provision of the service'),
(1,2010,111, 'How you deal with nonconforming process outputs, products and services in terms of: Correction; 
Segregation, containment, return or suspension of provision of products and services? 
Informing the customer? Obtaining authorization for use as-is? Release, continuation or re-provision of the products and service? Acceptance under concession?', '8.7', '8. Operation', 'As applicable, the organization shall deal with nonconforming process outputs, products and services in one or more of the following ways: 
1) correction; 
2) segregation, containment, return or suspension of provision of products and services; 
3) informing the customer; 
4) obtaining authorization for: 
- use “as-is’; 
- release, continuation or re-provision of the products and services; 
- acceptance under concession'),
(1,2010,112, 'How do you verify conformance where process outputs, products and services are corrected following nonconformance?', '8.7', '8. Operation', 'Where nonconforming process outputs, products and services are corrected, conformity to the requirements shall be verified.'),
(1,2010,113, 'What documented information do you keep following actions taken to address nonconformities, including any concessions obtained and on the person or authority that made the decision regarding dealing with the nonconformance.', '8.7', '8. Operation', 'The organization shall retain documented information of actions taken on nonconforming process outputs, products and services, including on any concessions obtained and on the person or authority that made the decision regarding dealing with the nonconformity.'),
(1,2010,114, 'Show how you determine: What needs to be monitored and measured? 
Methods for monitoring, measurement, analysis and evaluation to ensure valid results? When to perform monitoring and measuring? When results shall be analyzed and evaluated?', '9.1.1', '9. Performance evaluation', 'The organization shall determine: 
a) what needs to be monitored and measured; b) the methods for monitoring, measurement, analysis and evaluation, as applicable, to ensure valid results; 
c) when the monitoring and measuring shall be performed; 
d) when the results from monitoring and measurement shall be analyzed and evaluated.'),
(1,2010,115, 'What documented information can you show that monitoring and measurement activities have been implemented in accordance with determined requirements?', '9.1.1', '9. Performance evaluation', 'The organization shall ensure that monitoring and measurement activities are implemented in accordance with the determined requirements and shall retain appropriate documented information as evidence of the results.'),
(1,2010,116, 'Show how you evaluate the quality performance and the effectiveness of the QMS.', '9.1.1', '9. Performance evaluation', 'The organization shall evaluate the quality performance and the effectiveness of the quality management system.'),
(1,2010,117, 'How do you monitor customer perception of the degree to which requirements have been met?', '9.1.2', '9. Performance evaluation', 'The organization shall monitor customer perceptions of the degree to which requirements have been met.'),
(1,2010,118, 'How do you obtain information relating to customer views and opinions of your products and services?', '9.1.2', '9. Performance evaluation', 'The organization shall obtain information relating to customer views and opinions of the organization and its products and services.'),
(1,2010,119, 'What methods for obtaining and using this information do you have?', '9.1.2', '9. Performance evaluation', 'The methods for obtaining and using this information shall be determined'),
(1,2010,120, 'Show how you analyze and evaluate data and information arising from monitoring, measurement and other sources.', '9.1.3', '9. Performance evaluation', 'The organization shall analyze and evaluate appropriate data and information arising from monitoring, measurement and other sources.'),
(1,2010,121, 'how the output of analysis and evaluation is used to: 
Demonstrate conformity of products and services to requirements? 
Assess and enhance customer satisfaction? 
Ensure conformity and effectiveness of the QMS? 
Demonstrate that planning has been successfully implemented? 
Assess process performance? 
Assess performance of external providers? Determine the need or opportunities for Improvements within the QMS?', '9.1.3', '9. Performance evaluation', 'The output of analysis and evaluation shall be used to: 
1) demonstrate conformity of products and services to requirements; 
2) assess and enhance customer satisfaction;
3) ensure conformity and effectiveness of the quality management system; 
4) demonstrate that planning has been successfully implemented; 
5) assess the performance of processes; 
6) assess the performance of external provider(s); g) determine the need or opportunities for improvements within the quality management system.'),
(1,2010,122, 'Show where the results of analysis and evaluation are used to provide inputs to management review.', '9.1.3', '9. Performance evaluation', 'The results of analysis and evaluation shall also be used to provide inputs to management review.'),
(1,2010,123, 'Are internal audits being conducted at planned intervals? Do they determine whether the QMS conforms to the requirements of ISO 9001 and to the other requirements established by Organization? 
(Review records to demonstrate conformance) 
Do they determine whether the QMS is effectively implemented and maintained? 
(Review records)', '9.2.1', '9. Performance evaluation', 'The organization shall conduct internal audits at planned intervals to provide information on whether the quality management system; 
a) conforms to: 
1) the organization’s own requirements for its quality management system; 
2) the requirements of this International 
Standard; 
b) is effectively implemented and maintained'),
(1,2010,124, 'Show audit programme(s) that takes into consideration the quality objectives, importance of the processes, customer feedback, changes impacting the organization and the results of previous audits? 
Where are the audit criteria and scope for each audit? 
Can you demonstrate that selection of auditors and the conduct of audits are objective and impartial and that auditors don’t audit their own work? 
How are audit results reported to relevant management? 
Can you demonstrate that necessary correction and corrective actions are taken without undue delay? 
Can you show documented information of the audit programme and the audit results?', '9.2.2', '9. Performance evaluation', '1) plan, establish, implement and maintain an audit programme(s) including the frequency, methods, responsibilities, planning requirements and reporting, which shall take into consideration the quality objectives, the importance of the processes concerned, customer feedback, changes impacting on the organization, and the results of previous audits; 
2) define the audit criteria and scope for each audit; 
3) select auditors and conduct audits to ensure objectivity and the impartiality of the audit process; 
4) ensure that the results of the audits are reported to relevant management; 
5) take necessary correction and corrective actions without undue delay; 
6) retain documented information as evidence of the implementation of the audit programme and the audit results.'),
(1,2010,125, 'What is the frequency that top management reviews the organization''s QMS? How is the QMS deemed suitable, adequate and effective?', '9.3.1', '9. Performance evaluation', 'Top management shall review the organization''s quality management system, at planned intervals, to ensure its continuing suitability, adequacy, and effectiveness'),
(1,2010,126, 'What kinds of information are reviewed in management reviews? These must include: actions status of previous reviews; 
changes to internal/external issues relevant to the QMS; issues that affect strategy; KPIs for nonconformities and corrective actions; monitor and measurement of results; audit results; customer satisfaction; issues concerning external providers; issues concerning other relevant parties; adequacy of resources and effectiveness of QMS; process performance; conformity of products and services; actions taken to address risks and opportunities and their effectiveness; new potential opportunities for continual improvement.', '9.3.1', '9. Performance evaluation', 'The management review shall be planned and carried out taking into consideration: 
1) the status of actions from previous management reviews; 
2) changes in external and internal issues that are relevant to the quality management system including its strategic direction; 
3) information on the quality performance, including trends and indicators for: nonconformities and corrective actions; monitoring and measurement results; audit results; 
4) customer satisfaction; 
5) issues concerning external providers and other relevant interested parties; 
6) adequacy of resources required for maintaining an effective quality management system; 
7) process performance and conformity of products and services; 
8) the effectiveness of actions taken to address risks and opportunities (see clause 6.1); 
9) new potential opportunities for continual improvement.'),
(1,2010,127, 'Show that management reviews include decisions and actions relating to: Continual improvement opportunities; The need for changes to the QMS including resource needs.', '9.3.2', '9. Performance evaluation', 'The outputs of the management review shall include decisions and actions related to: 
1) continual improvement opportunities; 
2) any need for changes to the quality management system, including resource needs.'),
(1,2010,128, 'Show what documented information you have as evidence of management reviews.', '9.3.2', '9. Performance evaluation', 'The organization shall retain documented information as evidence of the results of management reviews.'),
(1,2010,129, 'How do you determine and select opportunities for improvement? What necessary actions have you implemented so that you have met customer requirements and enhanced customer satisfaction?', '10.1', '10. Improvement', 'The organization shall determine and select opportunities for improvement and implement necessary actions to meet customer requirements and enhance customer satisfaction'),
(1,2010,130, 'Show how you have: Improved processes to prevent nonconformities; 
Improved products and services to meet known and predicted requirements; Improved QMS results.', '10.1', '10. Improvement', '1) improving processes to prevent nonconformities; 
2) improving products and services to meet known and predicted requirements; 
3) improving quality management system results.'),
(1,2010,131, 'When nonconformities occur, how You react; 
Take action to control and correct it; Deal with the consequences; Evaluate the need for action to eliminate the cause so that it does not recur or occur elsewhere by: Reviewing the nonconformity; Determining the cause of the nonconformity; Determining if similar nonconformities exist or could potentially occur; Actions needed are implemented; Review the effectiveness of corrective actions taken, if any; Make necessary changes to the QMS.', '10.2.1', '10. Improvement', '1) react to the nonconformity, and as applicable: 
a) take action to control and correct it; 
b) deal with the consequences; 
2) evaluate the need for action to eliminate the cause(s) of the nonconformity, in order that it does not recur or occur elsewhere, by: 
a) reviewing the nonconformity; 
b) determining the causes of the nonconformity; 
c) determining if similar nonconformities exist, or could potentially occur; 
3) implement any action needed; 
4) review the effectiveness of any corrective action taken; 
5) make changes to the quality management system, if necessary.'),
(1,2010,132, 'Show how correction actions were appropriate to the effects of the nonconformities encountered.', '10.2.1', '10. Improvement', 'Corrective actions shall be appropriate to the effects of the nonconformities encountered.'),
(1,2010,133, 'What documented information can you show as evidence of: The nature of the nonconformities and subsequent actions taken; The results of any corrective action', '10.2.2', '10. Improvement', 'The organization shall retain documented information as evidence of: 
1) the nature of the nonconformities and any subsequent actions taken; 
2) the results of any corrective action.'),
(1,2010,134, 'Demonstrate that you continually improve the suitability, adequacy and effectiveness of the QMS.', '10.3', '10. Improvement', 'The organization shall continually improve the suitability, adequacy, and effectiveness of the quality management system.'),
(1,2010,135, 'Demonstrate that outputs of analysis and evaluation and the outputs from management review are considered to confirm if there are areas of underperformance or opportunities that shall be addressed as part of continual improvement.', '10.3', '10. Improvement', 'The organization shall consider the outputs of analysis and evaluation, and the outputs from management review, to confirm if there are areas of underperformance or opportunities that shall be addressed as part of continual improvement.'),
(1,2010,136, 'What applicable tools and methodologies for investigation of the causes of underperformance and to support continual improvement are selected?', '10.3', '10. Improvement', 'Where applicable, the organization shall select and utilize applicable tools and methodologies for investigation of the causes of underperformance and for supporting continual improvement.')