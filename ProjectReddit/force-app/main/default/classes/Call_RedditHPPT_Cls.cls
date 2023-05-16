public with sharing class Call_RedditHPPT_Cls {
    @AuraEnabled
    public static String callReddit() {
        String mensaje;
        List<WrapperReddit_Cls.Data> lsWrapperData = new List<WrapperReddit_Cls.Data>();
        WrapperReddit_Cls strResponceCls = null;
        String urlSite = 'https://www.reddit.com/r/subreddit/new.json?sort=new';
        if(String.isNotBlank(urlSite)) {
            HttpRequest requestHTTP = new HttpRequest();
            requestHTTP.setEndpoint(urlSite);
            requestHTTP.setMethod('GET');
            try {
                Http htpp = new Http();
                HttpResponse htppRespo = htpp.send(requestHTTP);
                if(htppRespo.getStatusCode() == 200) {
                    strResponceCls = WrapperReddit_Cls.parse(htppRespo.getBody());
                } else {
                    throw new CalloutException(htppRespo.getBody());
                }
            } catch (Exception e) {
                throw e;
            }
        }
        if(strResponceCls != null) {
            List<WrapperReddit_Cls.Children> lsWapperChil = strResponceCls.data.children;
            for(WrapperReddit_Cls.Children tmpChildren : lsWapperChil){
                lsWrapperData.add(tmpChildren.data);
            }
        }
        List<reddit_items__c> lsRedItem = new List <reddit_items__c>();
        for (WrapperReddit_Cls.Data tmpWrapper: lsWrapperData){
            reddit_items__c tmpRedItems = new reddit_items__c();
            tmpRedItems.Name = tmpWrapper.author_fullname;
            tmpRedItems.Selftext__c = tmpWrapper.selftext;
            tmpRedItems.Thumbnail__c = tmpWrapper.thumbnail;
            tmpRedItems.Title__c = tmpWrapper.title;
            tmpRedItems.Created__c = DateTime.newInstance(long.valueOf(tmpWrapper.created));
            lsRedItem.add(tmpRedItems);
        }
        if(lsRedItem.size()>0) {
            insert lsRedItem;
            mensaje = 'Registros Creados Exitosamente';
        } else {
            mensaje= 'Registros No Creados';
        }
        return mensaje;
    }
}