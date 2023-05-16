public with sharing class Reddit_Data_Cls {
   
    @AuraEnabled(cacheable = true )
    public static List<reddit_items__c> getDataReddit(){
        return [SELECT id,Name, Selftext__c, Thumbnail__c,Title__c FROM reddit_items__c ORDER BY Created__c asc];
    }

    @AuraEnabled(cacheable = false )
    public static void deleteRecordRedit(String idDelete){
        List<reddit_items__c> lsDel= [SELECT id FROM reddit_items__c WHERE id =:idDelete];
        System.debug('lsDelete '+lsDel);
        delete lsDel;
    }
}