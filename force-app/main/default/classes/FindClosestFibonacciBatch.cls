/**
 * Created by Bogdan_Krasun on 15.01.2023.
 */

public without sharing class FindClosestFibonacciBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext param1) {
        return Database.getQueryLocator([SELECT Name, Numeric_value__c FROM Search_request__c]);
    }

    public void execute(Database.BatchableContext param1, List<Search_request__c> searchRequests) {
        for (Search_request__c sr : searchRequests) {
            Integer num = (Integer) sr.Numeric_value__c;
            Integer first = 0, second = 1;
            Integer third = first + second;
            while (third < num) {
                first = second;
                second = third;
                third = first + second;
            }
            sr.Fibonacci_Below__c = second;
            sr.Fibonacci_Above__c = third;
        }
        update searchRequests;
    }

    public void finish(Database.BatchableContext param1) {
    }
}