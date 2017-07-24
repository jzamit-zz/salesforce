trigger LeadTrigger on Lead (before insert) {
	//Retrieve the needed Queue.
	List<Group> dataQualityGroup = [SELECT Id
									  FROM Group
							  		 WHERE DeveloperName = 'Data_Quality'
							 	     LIMIT 1];
	for (Lead currentLead : Trigger.new) {
		if(currentLead.Email != null){
			List<Contact> contactsFromDb = [SELECT Id, FirstName, LastName, Account.Name
											  FROM Contact
											 WHERE Email =: currentLead.Email];

			if(contactsFromDb.size() > 0){
				if(dataQualityGroup.size() > 0){
					///Asign lead to the data quality queue.
					currentLead.OwnerId = dataQualityGroup[0].Id;
				}
				String dupeMessage= 'Duplicated Contact(s) found: ';
				for(Contact con : contactsFromDb){
					dupeMessage += con.FirstName + ' '
								+ con.LastName + ' '
								+ con.Account.Name + ' ('
								+ con.Id + ')\n';
				}
				if(currentLead.Description != null){
					currentLead.Description = dupeMessage + '\n' + currentLead.Description;
				}
			}
		}
	}
}