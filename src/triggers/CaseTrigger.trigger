trigger CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	for (Case so : Trigger.new) {
		//friends remind friends to bulkify
	}

}