trigger TriggerCase on Case (before insert) {

	for (Case currentCase : Trigger.new) {
		if(currentCase.ContactId != null){
			//Find all the cases with same Contact Id and created Today
			List<Case> casesFromContactToday = [SELECT Id
												  FROM Case
												 WHERE ContactId =: currentCase.ContactId
												   AND CreatedDate = TODAY];
			if(casesFromContactToday.size() >= 2){
				currentCase.Status = 'Closed';
			}									   		
		}
	}
}