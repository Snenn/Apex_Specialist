@isTest
public  class MaintenanceRequestTest {
    
    @isTest static void TestForUpdate() {
        
        
        Product2 equipment = new Product2(Name = 'equipment', Maintenance_Cycle__c = 5, Replacement_Part__c = true);
    	insert equipment;
        Vehicle__c vehicle = new Vehicle__c(name='vehicle');
    	insert vehicle;
        
        List<Case> caseList = new List<Case>();
		List<Work_Part__c> workList = new List<Work_Part__c>();
        
        for (Integer i=0; i<300; i++){
            Case newCase = new Case(Status='New', Origin='phone', Type='Routine Maintenance', 
                              Subject='case'+i, Vehicle__c=vehicle.Id, Equipment__c=equipment.ID);
        	caseList.add(newCase);
        }
        insert caseList;
            
        for(Integer i=0;i<2;i++){
			Work_Part__c work = new Work_Part__c();
            work.Equipment__c = equipment.Id;
            work.Maintenance_Request__c=caseList.get(i).id;
            workList.add(work) ;
		}
        insert workList;

        // Perform test
        Test.startTest();
        for(Case cas: caseList){
            cas.Status ='Closed';
        }
        update(caseList);
        Test.stopTest();
        Integer count = [Select count() from Case];
        // no new cases for all situations
        System.assertEquals(600, count);
        
        
        
    }
    
    
        
    
    @isTest static void TestNotForUpdate() {
        
        Product2 equipment = new Product2(Name = 'equipment', Maintenance_Cycle__c = 5, Replacement_Part__c = true);
    	insert equipment;
        Vehicle__c vehicle = new Vehicle__c(name='vehicle');
    	insert vehicle;
                
        List<Case> caseList = new List<Case>();
        
        Case case1 = new Case(Status='New', Origin='phone', Type='Routine Maintenance', 
                              Subject='case1', Vehicle__c=vehicle.Id, Equipment__c=equipment.ID);
        caseList.add(case1);
        
        Case case2 = new Case(Status='New', Origin='phone', Type='Repair', 
                              Subject='case2', Vehicle__c=vehicle.Id, Equipment__c=equipment.ID);
        caseList.add(case2);
        
        Case case3 = new Case(Status='New', Origin='phone', Type='Malfunctions', 
                              Subject='case3', Vehicle__c=vehicle.Id, Equipment__c=equipment.ID);
        caseList.add(case3);
        insert caselist;
                
        // Perform test
        Test.startTest();
        // Case will update with type Routine Maintenance, but new Status will be Working
        caseList.get(0).status = 'Working';
        // Case will update with type Repair, but new Status will be Working
        caseList.get(1).status = 'Working';
        // Case will update with status Closed, but Type is Malfunctions
        caseList.get(2).status = 'Closed';
        Database.SaveResult[] results = Database.update(caseList);
        Test.stopTest();
        for(Database.SaveResult dr : results) {
            System.assert(dr.isSuccess());
        }
        Integer count = [Select count() from Case];
        // no new cases for all situations
        System.assertEquals(3, count);
    }
}