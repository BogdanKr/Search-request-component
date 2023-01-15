/**
 * Created by Bogdan_Krasun on 14.01.2023.
 */

public with sharing class SearchRequestController {
    private final static Integer MAX_ROWS = 10;
    private Integer rows = 0;
    public Boolean renderFibonacciButton { get; set; }
    public List<Search_request__c> requestsToHandle { get; set; }

    public SearchRequestController() {
        requestsToHandle = new List<Search_request__c>();
        addRows();
    }

    public void handleEnter() {
        System.debug('Key pressed Enter!!!');
        addRows();
    }

    public void addRows() {
        if (rows < MAX_ROWS) {
            requestsToHandle.add(new Search_request__c());
            rows++;
        }
    }

    public void submitRequests() {
        renderFibonacciButton = true;
        System.debug('Submit button clicked');
        List<Search_request__c> searchRequests = new List<Search_request__c>();
        for (Search_request__c sr : requestsToHandle) {
            if (sr.Name != '') {
                sr.Hash__c = sr.Name.hashCode();
                sr.Numeric_value__c = getNumericValue(sr.Name);
                searchRequests.add(sr);
                System.debug('Search request==> ' + sr);
            }
        }
    }

    public void clearTable(){
        requestsToHandle.clear();
        rows = 0;
        renderFibonacciButton = false;
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