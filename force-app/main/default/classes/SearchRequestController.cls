/**
 * Created by Bogdan_Krasun on 14.01.2023.
 */

public with sharing class SearchRequestController {
    private final static Integer MAX_ROWS = 10;
    private Integer rows = 0;
    public List<SearchRequestWrapper> requestsToHandle { get; set; }

    public SearchRequestController() {
        requestsToHandle = new List<SearchRequestWrapper>();
        addRows();
    }

    public void handleEnter() {
        System.debug('Key pressed Enter!!!');
        addRows();
    }

    public void addRows() {
        if (rows < MAX_ROWS) {
            requestsToHandle.add(new SearchRequestWrapper());
            rows++;
        }
    }

    public void submitRequests() {
        System.debug('Submit button clicked');
        List<Search_request__c> searchRequests = new List<Search_request__c>();
        for (SearchRequestWrapper sr : requestsToHandle) {
            if (sr.searchRequest.Name != '') {
                sr.searchRequest.Hash__c = sr.searchRequest.Name.hashCode();
                sr.searchRequest.Numeric_value__c = getNumericValue(sr.searchRequest.Name);
                searchRequests.add(sr.searchRequest);
                System.debug('Search request==> ' + sr.searchRequest);
            }
        }
    }

    public void clearTable(){
        requestsToHandle.clear();
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


    public class SearchRequestWrapper {
        public Search_request__c searchRequest { get; set; }
        public Integer fibonacciBelow { get; set; }
        public Integer fibonacciAbove { get; set; }

        public SearchRequestWrapper() {
            searchRequest = new Search_request__c(Name = '');
        }
    }
}