CREATE DATABASE bowtie_test;
USE bowtie_test;

/*create tables*/
CREATE table claim (id VARCHAR (36) NOT NULL PRIMARY KEY, 
					claim_type VARCHAR (15),
                    claim_status VARCHAR (20),
                    policy_number VARCHAR (10),
                    submit_date DATETIME,
                    payment_date DATETIME NULL,
                    admission_date DATE NULL,
                    total_billed_amount DOUBLE,
                    total_base_payable_amount DOUBLE);
                    
CREATE table invoice (id VARCHAR (36) NOT NULL PRIMARY KEY, 
					invoice_type VARCHAR (10),
                    policy_number VARCHAR (10),
                    coverage_start_date DATETIME NULL,
                    coverage_end_date DATETIME NULL,
                    due_date DATETIME,
                    invoice_status VARCHAR (10),
                    pre_levy_amount DOUBLE,
                    total_amount DOUBLE,
                    refund_date DATETIME NULL,
                    charge_date DATETIME NULL);
                    
CREATE table policy (id VARCHAR (5) NOT NULL PRIMARY KEY, 
                    policy_number VARCHAR (10),
					user_id VARCHAR (36),
                    application_id VARCHAR(36),
                    product VARCHAR(18),
                    issue_date DATETIME,
                    effective_date DATETIME,
                    insured_gender VARCHAR (6),
                    insured_date_of_birth DATE);

/* Q5a - number of submitted claims in 2021 by products */
SELECT p.product, COUNT(*) AS no_claims_submitted_in_2021
FROM claim AS c
LEFT JOIN policy AS p
ON c.policy_number = p.policy_number
WHERE c.submit_date > '2020-12-31' AND c.submit_date < '2022-01-01'
GROUP BY p.product;

/* Q5b - avg net premium for new vs returning policies */
/*define policy type & calculate actual policy value*/
WITH mergedTable AS (
	/*join 2 table with necessary field*/
	SELECT p.id AS policy_id,
		   p.policy_number,
           p.user_id, 
           p.issue_date, 
           i.total_policy_value,
           ROW_NUMBER() OVER (PARTITION BY p.user_id ORDER BY p.issue_date) AS policy_rank -- nth policy from same user_id
	FROM policy AS p
	LEFT JOIN ( 
		SELECT	policy_number,
				/*deduct policy value if invoice is voided or refunded*/
				SUM(CASE WHEN invoice_status = 'void' OR invoice_status ='refunded' THEN ROUND((total_amount*-1),2)
						ELSE ROUND(total_amount,2) END) AS total_policy_value
		FROM invoice
		GROUP BY policy_number) AS i
	ON p.policy_number = i.policy_number
    WHERE i.total_policy_value IS NOT NULL -- exclude no total_policy_value records
	ORDER BY p.issue_date ASC)
    
/*find total policies, total premium & avg premium by policy type*/
SELECT policy_type,
	   COUNT(policy_type) AS total_no_of_policies,
	   ROUND(SUM(total_policy_value),2) AS total_premium,
       ROUND(SUM(total_policy_value)/COUNT(policy_type),2) AS avg_premium
FROM (
		/*define policy type & adjust value*/
		SELECT *,
			   CASE WHEN policy_rank = 1 THEN 'new' -- define 1st policy as new
			   ELSE 'returning' END AS policy_type -- define 2nd or above policy as returning
		FROM mergedTable
) AS sub
GROUP BY policy_type;