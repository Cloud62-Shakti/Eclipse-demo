/*
@Name : LocationCallouts
@Author : customersuccess@cloud62.com
@Date : 2/10/2013
@Description : update geoLocation through HTTP callout.
*/
public class LocationCallouts {
 
     /*
	@Name : getLocation
	@Description : future method needed to run callouts from Triggers.And update GeoLocation in the record.
	*/
     @future (callout=true)  
      static public void getLocation(id rId){
        // create an address string
        String address = '';
        Account a;
        Contact c;
        Lead l;
        
        String ids = rId;
        ids = ids.substring(0,3);
        
        if(ids.startsWith('001')){
            // gather account info
            a = [SELECT BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet FROM Account WHERE id =: rId];
            if (a.BillingStreet != null)
                address += a.BillingStreet +', ';
            if (a.BillingCity != null)
                address += a.BillingCity +', ';
            if (a.BillingState != null)
                address += a.BillingState +' ';
            if (a.BillingPostalCode != null)
                address += a.BillingPostalCode +', ';
            if (a.BillingCountry != null)
                address += a.BillingCountry;
        } else if(ids.startsWith('003')){
            c = [SELECT MailingCity, MailingCountry, MailingState, MailingStreet, MailingPostalCode FROM Contact WHERE id =: rId];
            if (c.MailingStreet != null)
                address += c.MailingStreet +', ';
            if (c.MailingCity != null)
                address += c.MailingCity +', ';
            if (c.MailingState != null)
                address += c.MailingState +' ';
            if (c.MailingPostalCode != null)
                address += c.MailingPostalCode +', ';
            if (c.MailingCountry != null)
                address += c.MailingCountry;
        } else if(ids.startsWith('00Q')){
            l = [SELECT City, Country, State, Street, PostalCode FROM Lead WHERE id =: rId];
            if (l.Street != null)
                address += l.Street +', ';
            if (l.City != null)
                address += l.City +', ';
            if (l.State != null)
                address += l.State +' ';
            if (l.PostalCode != null)
                address += l.PostalCode +', ';
            if (l.Country != null)
                address += l.Country;
        }
        
        
        address = EncodingUtil.urlEncode(address, 'UTF-8');
 
        // build callout
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false');
        req.setMethod('GET');
        req.setTimeout(60000);
 
        try{
            // callout
            HttpResponse res = h.send(req);
 
            // parse coordinates from response
            JSONParser parser = JSON.createParser(res.getBody());
            double lat = null;
            double lon = null;
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'location')){
                       parser.nextToken(); // object start
                       while (parser.nextToken() != JSONToken.END_OBJECT){
                           String txt = parser.getText();
                           parser.nextToken();
                           if (txt == 'lat')
                               lat = parser.getDoubleValue();
                           else if (txt == 'lng')
                               lon = parser.getDoubleValue();
                       }
 
                }
            }
 
            // update coordinates if we get back
            if (lat != null){
                if(ids.startsWith('001')){
                    a.Location__Latitude__s = lat;
                    a.Location__Longitude__s = lon;
                    update a;
                } else if(ids.startsWith('003')){
                    c.Location__Latitude__s = lat;
                    c.Location__Longitude__s = lon;
                    update c;
                } else if(ids.startsWith('00Q')){
                    l.Location__Latitude__s = lat;
                    l.Location__Longitude__s = lon;
                    update l;
                }
            }
 
        } catch (Exception e) {
        }
    }
}