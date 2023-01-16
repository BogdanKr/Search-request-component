/**
 * Created by Bogdan_Krasun on 14.01.2023.
 */

public without sharing class SearchRequestController {
    private final static Integer MAX_ROWS = 10;
    public Integer rows = 0;
    public Id jobId;
    public Boolean renderFibonacciButton { get; set; }
    public Boolean isDisabledButton { get; set; }
    public Boolean isDisabledFibonacciButton { get; set; }
    public Boolean waitPoll { get; set; }
    public List<Search_request__c> requestsToHandle { get; set; }

    public SearchRequestController() {
        waitPoll = false;
        isDisabledButton = true;
        requestsToHandle = new List<Search_request__c>();
        addRows();
    }

    public void handleEnter() {
        isDisabledButton = false;
        addRows();
    }

    public void addRows() {
        if (rows < MAX_ROWS) {
            requestsToHandle.add(new Search_request__c(Name = ''));
            rows++;
        }
    }

    public void submitRequests() {
        isDisabledButton = true;
        renderFibonacciButton = true;
        List<Search_request__c> searchRequests = new List<Search_request__c>();
        for (Search_request__c sr : requestsToHandle) {
            if (sr.Name != '') {
                sr.Hash__c = sr.Name.hashCode();
                sr.Numeric_value__c = getNumericValue(sr.Name);
                searchRequests.add(sr);
                System.debug('Search request==> ' + sr);
            }
        }
        if (requestsToHandle.size() < 10) {
            requestsToHandle.remove(requestsToHandle.size() - 1);
        }
        insert requestsToHandle;
    }

    public void processBatch() {
        jobId = Database.executeBatch(new FindClosestFibonacciBatch());
        waitPoll = true;
        isDisabledFibonacciButton = true;
    }

    public void rerenderFibonacciNearest() {
        AsyncApexJob job = [SELECT Status FROM AsyncApexJob WHERE Id = :jobId];
        System.debug('job status - ' + job.Status);
        if (job.Status == 'Completed') {
            requestsToHandle = [
                    SELECT Name, Numeric_value__c, Hash__c, Fibonacci_Below__c, Fibonacci_Above__c
                    FROM Search_request__c
                    WHERE Id IN :requestsToHandle
            ];
            System.debug('After batch ==> ' + requestsToHandle);
            waitPoll = false;
        }
//        return null;
    }


    public void clearTable() {
        requestsToHandle.clear();
        rows = 0;
        renderFibonacciButton = false;
        isDisabledButton = true;
        isDisabledFibonacciButton = false;
//        delete [SELECT Id FROM Search_request__c];
        addRows();
    }

    public Integer getNumericValue(String str) {
        List<Integer> chars = str.getChars();
        Integer numericValue = 0;
        for (Integer i : chars) {
            System.debug('char: ' + i);
            numericValue += i;
        }
        return numericValue;
    }
}