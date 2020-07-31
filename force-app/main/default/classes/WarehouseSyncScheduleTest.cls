@isTest
private class WarehouseSyncScheduleTest {
    
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @isTest 
    static void testScheduledJob(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        String jobID= System.schedule('TestScheduleJob', CRON_EXP, new WarehouseSyncSchedule());
        Test.stopTest();
        
    }
}