/**
 * Created by Bogdan_Krasun on 16.01.2023.
 */
@IsTest
public with sharing class FindClosestFibonacciBatchTest {
    @IsTest
    private static void test() {
        insert new Search_request__c(Name = 'hello', Numeric_value__c = 532);
        Test.startTest();
        Database.executeBatch(new FindClosestFibonacciBatch());
        Test.stopTest();
        Search_request__c sr = [SELECT Name, Fibonacci_Above__c, Fibonacci_Below__c FROM Search_request__c][0];
        System.assertEquals(377, sr.Fibonacci_Below__c, 'Fibonacci number not correct');
        System.assertEquals(610, sr.Fibonacci_Above__c, 'Fibonacci number not correct');
    }
}