trigger ComparableOpportunityTrigger on Comparable_Opportunity__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	for (Comparable_Opportunity__c so : Trigger.new) {
		//friends remind friends to bulkify
	}

}