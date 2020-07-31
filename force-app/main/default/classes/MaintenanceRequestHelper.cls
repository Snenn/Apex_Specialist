public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> caseList) {
	List<case> newCaseList = new List<Case>();
    Map<String,Integer> dueDates=getDueDate(caseList);
    for(Case ca : caseList){
        if(ca.status == 'closed' && (ca.type == 'Repair' || ca.type == 'Routine Maintenance')){
            Case newCase = new Case();
            newCase.Status='New';
            newCase.Origin='phone';
            newCase.Type='Routine Maintenance';
            newCase.Subject='Subject';
            newCase.Vehicle__c=ca.Vehicle__c;
            newCase.Equipment__c=ca.Equipment__c;
            newCase.Date_Reported__c=Date.today();
            if(dueDates.get(ca.Id)!=null)
            newCase.Date_Due__c=Date.today()+dueDates.get(ca.Id);
            else
            newCase.Date_Due__c=Date.today();
            newCaseList.add(newCase);           
    	}
    }
    insert newCaseList;
    }
    
    public static  Map<String,Integer> getDueDate(List<case> CaseIDs){
        Map<String,Integer> result = new Map<String,Integer>();
		Set<Id> Ids = (new Map<Id,SObject>(CaseIDs)).keySet();
        List<AggregateResult> dates = [select Maintenance_Request__r.ID mrID,min(Equipment__r.Maintenance_Cycle__c)cycle
        							from Work_Part__c where Maintenance_Request__r.ID 
                                    in :Ids group by Maintenance_Request__r.ID ];
        for(AggregateResult d :dates){
            Integer addDays = 0;
            if(d.get('cycle') != null) {
                addDays+=Integer.valueOf(d.get('cycle'));
            }
            result.put((String)d.get('mrID'), addDays);
    	}
    	return result;
    }          
}