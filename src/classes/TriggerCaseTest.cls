@isTest
private class TriggerCaseTest {
	
	@isTest static void NoCasesToday() {
		Contact con  = new Contact();
		con.LastName = 'Zamit';
		insert con;

		Case myCase      = new Case();
		myCase.ContactId = con.Id;
		myCase.Status    = 'New';
		insert myCase;

		Test.startTest();

			Case updatedCase = [SELECT Status
								  FROM Case
								 WHERE Id=: myCase.Id];

			System.assertEquals('New', updatedCase.Status);

		Test.stopTest();


	}
	
	@isTest static void MoreThanTwoCasesToday() {
		Contact con  = new Contact();
		con.LastName = 'Zamit';
		insert con;

		List<Case> oldCases = new List<Case>();
		Case myCase      = new Case();
		myCase.ContactId = con.Id;
		myCase.Status    = 'New';
		oldCases.add(myCase);
		Case myCase2      = new Case();
		myCase2.ContactId = con.Id;
		myCase2.Status    = 'New';
		oldCases.add(myCase2);
		Case myCase3      = new Case();
		myCase3.ContactId = con.Id;
		myCase3.Status    = 'New';
		oldCases.add(myCase3);

		insert oldCases;

		Test.startTest();

		Case newCase = new Case();
		newCase.ContactId = con.Id;
		newCase.Status    = 'New';
		insert newCase;

			Case updatedCase = [SELECT Status
								  FROM Case
								 WHERE Id=: newCase.Id];

			System.assertEquals('Closed', updatedCase.Status);

		Test.stopTest();

	}
	
}