 SELECT		TableName, RuleNo, action, COUNT(*) as TotalRecords 
 FROM		DQLog
 GROUP BY	TableName, RuleNo, action;
