public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @future(callout=true)
    public static void runWarehouseEquipmentSync() {
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(WAREHOUSE_URL);
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        
        List<Product2> equipmentList = new List<Product2>();
        if(res.getStatusCode()==200){
            List< Object> result =(List<Object>)JSON.deserializeUntyped(res.getBody());
            for(Object resultMap: result){
            	Map<String,Object> eqMap = (Map<String,Object>)resultMap;
                Product2 equipment = new Product2( Replacement_Part__c = true,
                                                   Current_Inventory__c = (Decimal)eqMap.get('quantity'),
                                                   Name = (String)eqMap.get('name'),
                                                   Maintenance_Cycle__c = (Integer)eqMap.get('maintenanceperiod'),
                                                   Lifespan_Months__c = (Double)eqMap.get('lifespan'),
                                                   Cost__c=(Decimal)eqMap.get('cost'),
                                                   ExternalId=(String)eqMap.get('sku') 
                                               );
                				
                equipmentList.add(equipment);				
            }
        
		upsert equipmentList;        
        
        }
                
    }
}