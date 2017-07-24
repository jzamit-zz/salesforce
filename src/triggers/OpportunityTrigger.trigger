trigger OpportunityTrigger on Opportunity (after insert) {

	for (Opportunity opp : Trigger.new) {

		//Need to query Fields thar arent base Fields, like Account.Industry
		//In Trigger.new only have base fileds in memmory.
		Opportunity oppWithAccountInfo = [SELECT id, Account.Industry
											FROM Opportunity
										   WHERE Id =: opp.Id
										   LIMIT 1];
		// Need to do this calculations before, cannot do it directly in Soql bind syntax because it gonna fail.
		Decimal minAmount = opp.Amount * 0.9;
		Decimal maxAmount = opp.Amount * 1.1;

		//Need to exclude current Opportunity (AND Id !=: opp.Id) because is an after insert, our opportunity will be retieved too and we don't want that.
		List<Opportunity> comparableOpps = [SELECT Id
											FROM Opportunity 
										   WHERE (Amount >= :minAmount AND Amount <=: maxAmount) 
										     AND Account.Industry =: oppWithAccountInfo.Account.Industry
										     AND StageName = 'Closed Won'
										     AND CloseDate >= LAST_N_DAYS:365
										     AND Id !=: opp.Id
										     AND Owner.Position_Start_Date__c < LAST_N_DAYS:365];

		System.debug('Comparable opp(s) found: ' + comparableOpps);

		List<Comparable_Opportunity__c> compOpps = new List<Comparable_Opportunity__c>();
		for(Opportunity comp : comparableOpps){
			//Create junction object and then add it to list in order to insert to DB.
			Comparable_Opportunity__c junctionObj = new Comparable_Opportunity__c();
			junctionObj.Base_Opportunity__c = opp.Id;
			junctionObj.Comparable_Opportunity__c = comp.Id;
			compOpps.add(junctionObj);
		}
		insert compOpps;
	}

}