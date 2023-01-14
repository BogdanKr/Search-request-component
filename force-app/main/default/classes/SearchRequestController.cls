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