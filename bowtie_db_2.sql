DROP TABLE IF EXISTS claim;

CREATE TABLE claim (
  id varchar(36) NOT NULL,
  claim_type varchar(15) DEFAULT NULL,
  claim_status varchar(20) DEFAULT NULL,
  policy_number varchar(10) DEFAULT NULL,
  submit_date datetime DEFAULT NULL,
  payment_date datetime DEFAULT NULL,
  admission_date date DEFAULT NULL,
  total_billed_amount double DEFAULT NULL,
  total_base_payable_amount double DEFAULT NULL,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS invoice;

CREATE TABLE invoice (
  id varchar(36) NOT NULL,
  invoice_type varchar(10) DEFAULT NULL,
  policy_number varchar(10) DEFAULT NULL,
  coverage_start_date datetime DEFAULT NULL,
  coverage_end_date datetime DEFAULT NULL,
  due_date datetime DEFAULT NULL,
  invoice_status varchar(10) DEFAULT NULL,
  pre_levy_amount double DEFAULT NULL,
  total_amount double DEFAULT NULL,
  refund_date datetime DEFAULT NULL,
  charge_date datetime DEFAULT NULL,
  PRIMARY KEY (id)
); 

DROP TABLE IF EXISTS policy;

CREATE TABLE policy (
  id varchar(5) NOT NULL,
  policy_number varchar(10) DEFAULT NULL,
  user_id varchar(36) DEFAULT NULL,
  application_id varchar(36) DEFAULT NULL,
  product varchar(18) DEFAULT NULL,
  issue_date datetime DEFAULT NULL,
  effective_date datetime DEFAULT NULL,
  insured_gender varchar(6) DEFAULT NULL,
  insured_date_of_birth date DEFAULT NULL,
  PRIMARY KEY (id)
); 
