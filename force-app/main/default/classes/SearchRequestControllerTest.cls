/**
 * Created by Bogdan_Krasun on 16.01.2023.
 */
@IsTest
private class SearchRequestControllerTest {

    private static final SearchRequestController CONTROLLER = new SearchRequestController();

    @IsTest
    private static void handleEnterTest() {
        CONTROLLER.isDisabledButton = true;
        CONTROLLER.handleEnter();
        System.assert(CONTROLLER.isDisabledButton == false);
    }

    @IsTest
    private static void addRowsTest() {
        System.assertEquals(1, CONTROLLER.rows);
        CONTROLLER.addRows();
        System.assertEquals(2, CONTROLLER.rows);

    }

    @IsTest
    private static void submitRequestsTest() {
        System.debug('requests==> ' + CONTROLLER.requestsToHandle);
        CONTROLLER.requestsToHandle.add(new Search_request__c(Name = 'hello'));
        CONTROLLER.requestsToHandle.add(new Search_request__c(Name = 'test'));
        System.debug('requests==> ' + CONTROLLER.requestsToHandle);

        CONTROLLER.submitRequests();

        Search_request__c sr = [SELECT Name, Hash__c, Numeric_value__c FROM Search_request__c WHERE Name = 'hello'];
        System.assertEquals(532, sr.Numeric_value__c);
        System.assertEquals(99162322, sr.Hash__c);

    }

    @IsTest
    private static void processBatchTest() {
        System.assertEquals(false, CONTROLLER.waitPoll);

        Test.startTest();
        CONTROLLER.processBatch();
        Test.stopTest();

        System.assertEquals(true, CONTROLLER.waitPoll);
        System.assertEquals(1, [SELECT Status FROM AsyncApexJob].size());

    }

    @IsTest
    private static void rerenderFibonacciNearestTest() {
        CONTROLLER.waitPoll = true;
        Search_request__c sr = new Search_request__c(Name = 'hello');
        insert sr;
        CONTROLLER.requestsToHandle.add(sr);
        Test.startTest();
        CONTROLLER.processBatch();
        Test.stopTest();

        CONTROLLER.rerenderFibonacciNearest();

        System.assertEquals(1, CONTROLLER.requestsToHandle.size());
        System.assertEquals(false, CONTROLLER.waitPoll);
    }

    @IsTest
    private static void clearTableTest() {
        Search_request__c sr = new Search_request__c(Name = 'hello');
        CONTROLLER.requestsToHandle.add(sr);

        CONTROLLER.clearTable();

        System.assertEquals(1, CONTROLLER.requestsToHandle.size());
        System.assertEquals(1, CONTROLLER.rows);
        System.assertEquals(false, CONTROLLER.renderFibonacciButton);
        System.assertEquals(true, CONTROLLER.isDisabledButton);
    }

    @IsTest
    private static void getNumericValueTest() {
        System.assertEquals(532, CONTROLLER.getNumericValue('hello'));
    }

}