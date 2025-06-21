/* BTCPay Server basic Cryptocurrencies Tip-jar Script for experimental and educational proposes.

THIS SCRIPT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SCRIPT OR THE USE OR OTHER DEALINGS IN THE SCRIPT.

Copyright © 2023 Adil El Farissi (Web Rain in SL and OSG) Under MIT License. */

// Change the following to your btcpay server instance URL, IP and storeID.
string BTCPayServerURL = "https://testnet.demo.btcpayserver.org";
string HttpInAllowedIP = "172.81.181.89";
string storeID = "BVhCURCQPEe6mUSBuwvUciYvy15ikx42g1Vizx8YBG1f";

// Set some "Thank you" words or leave empty to show the default text.
string checkoutDesc = "";

// If you want to recive notifications by Email, set it here or leave empty.
string notificationEmail = "";

// If you want to redirect your user to a webpage after a payment, set an URL here or leave empty:
string redirectURL = "";

//Advanced Options: Specify additional query string parameters that should be appended to the checkout page once the invoice is created. For example, lang=da-DK would load the checkout page in Danish by default. 
string checkoutQueryString = "";

// Important: The cryptocurrency code (ticker) of the crypto that you want to recive as payment. This value depend on your BTCPay server settings and Altcoins support... Default is Bitcoin "BTC", If your BTCPay instance support Litecoin Dogecoin and Monero you can set "LTC" or "DOGE" or "XMR"...
string defaultPaymentMethod = "BTC";

// Default: TRUE. if set to TRUE will inform you if you when you recive donations in the chat.
integer notifications = TRUE;

// Update RGB color change interval in seconds
float timerInterval = 0.1;

// Starting hue value (0.0 to 1.0)
float hue = 0.0;

/*** The following dont need change ***/
key IPNEndpointRequest_id = NULL_KEY;
key requestRates_id = NULL_KEY;
key requestInvoice_id = NULL_KEY;
string IPNEndpointURL = "";
string orderID = ""; 
string currency = "";
string price = "0";
key avatar = NULL_KEY;
integer active = FALSE;
string invoiceID = "";
string invoiceURL = "";
integer channel;
integer CListener;
integer isWaitingAmount = FALSE;
integer isOutOfService = FALSE;
string txStatus = "";
string errorLog = "";
float donated = 0.0;
integer textRGB = TRUE;
integer objectRGB = TRUE;
string hoverText = llKey2Name(llGetOwner())+"'s Crypto Tip-Jar\nPowered By BTCPay Server\n>>> Click To Donate "+defaultPaymentMethod+" <<<\nDonated: "+ donated +" "+defaultPaymentMethod;
string donors = "";

// Function to reset the script
reset(){
    requestRates_id = NULL_KEY;
    requestInvoice_id = NULL_KEY;
    currency = "";
    price = "0";
    orderID = ""; 
    avatar = NULL_KEY;
    active = FALSE;
    invoiceID = "";
    invoiceURL = "";
    llListenRemove(CListener);
    isWaitingAmount = FALSE;
    txStatus = "";
    llSetTimerEvent(0);
    if (!isOutOfService){
        resetRGB();
    }
    else{
       llSetText("Out Of Service!",<1,0,0>, 1.0); 
    }
}

requestCurrentRate(){
    requestRates_id = llHTTPRequest(
        BTCPayServerURL +"/api/rates?storeId="+ storeID +"&currencyPairs="+ defaultPaymentMethod +"_"+ currency,
        [
            HTTP_METHOD,"GET",
            HTTP_MIMETYPE,"application/json",
            HTTP_BODY_MAXLENGTH,16384
        ],"");
}

requestInvoice(){
    string rBody = "";
    rBody += "storeId="+ storeID;
    rBody += "&price="+ price;
    rBody += "&currency="+ currency;
    rBody += "&defaultPaymentMethod="+ defaultPaymentMethod;
    rBody += "&orderId="+ orderID;
    rBody += "&serverIpn="+ IPNEndpointURL;
    if(checkoutDesc != ""){
        rBody += "&checkoutDesc="+  llEscapeURL(checkoutDesc);
    }
    else{
        rBody += "&checkoutDesc="+  llEscapeURL("Thank you "+ llKey2Name(avatar) +" for your donation.");
    }
    if (redirectURL != ""){
        rBody += "&browserRedirect="+ llEscapeURL(redirectURL);
    }
    if (notificationEmail != ""){
        rBody += "&notifyEmail="+ llEscapeURL(notificationEmail);
    }
    if (checkoutQueryString != ""){
        rBody += "&checkoutQueryString="+ llEscapeURL(checkoutQueryString);
    }
    rBody += "&jsonResponse=true";
    requestInvoice_id = llHTTPRequest(BTCPayServerURL+"/api/v1/invoices",[HTTP_METHOD,"POST",HTTP_MIMETYPE,"application/x-www-form-urlencoded",HTTP_BODY_MAXLENGTH,16384,HTTP_VERIFY_CERT,FALSE],rBody);
}

// Function to convert HSL to RGB
vector hsl_to_rgb(float h, float s, float l)
{
    float r;
    float g;
    float b;
    if (s == 0.0)
    {
        r = g = b = l; // Achromatic
    }
    else
    {
        float q = l < 0.5 ? l * (1.0 + s) : l + s - l * s;
        float p = 2.0 * l - q;
        r = hue_to_rgb(p, q, h + 1.0/3.0);
        g = hue_to_rgb(p, q, h);
        b = hue_to_rgb(p, q, h - 1.0/3.0);
    }
    return <r, g, b>;
}

// Helper function for HSL to RGB conversion
float hue_to_rgb(float p, float q, float t)
{
    if (t < 0.0) t += 1.0;
    if (t > 1.0) t -= 1.0;
    if (t < 1.0/6.0) return p + (q - p) * 6.0 * t;
    if (t < 1.0/2.0) return q;
    if (t < 2.0/3.0) return p + (q - p) * (2.0/3.0 - t) * 6.0;
    return p;
}

resetRGB(){
    hoverText = llKey2Name(llGetOwner())+"'s Crypto Tip-Jar\nPowered By BTCPay Server\n>>> Click To Donate "+defaultPaymentMethod+" <<<\nDonated: "+ donated +" "+defaultPaymentMethod;
    if(!textRGB) llSetText(hoverText,<1,1,0>,1.0);
    if(!objectRGB) llSetColor(<1,1,1>,ALL_SIDES);
    if(textRGB || objectRGB){
        llSetTimerEvent(timerInterval);
    }
    else{
        llSetTimerEvent(0);
    }
}

integer isValidAmount(string var){
    return osRegexIsMatch(var, "^[0-9|.]+$") && (float)var > 0;     
}

default
{
    state_entry(){
        if(!isOutOfService){
            resetRGB();
            if(IPNEndpointURL == ""){
                IPNEndpointRequest_id = llRequestURL();
            }
        }
    }
    
    touch_start(integer n){  
        channel = (integer)llFrand(123456789.0) + 1 * -1;
        CListener = llListen( channel, "", "", "");
        avatar = llDetectedKey(0);
        if (avatar == llGetOwner()){
            if (isOutOfService){
                llDialog(avatar,"\nWarning: This Tip-Jar is OUT OF SERVICE!\n[Reset]: Click to make available.\n[Log Error]: Click to view the saved error.\n[Close]: Close this box without enabling the Tip-jat",["Reset","Log Error","Close"],channel);
            }
            else{
                llDialog(avatar, "\n[RGB On/Off]: Turn the RGB effect On/Off.\n[donors]: Show the list of the donors in the chat.\n[Tip Test]: Start the donation process.",[" ","Close"," ","RGB On/Off","Donors","Tip Test"],channel);
            }       
        }
        else{
            if(isOutOfService){
                llInstantMessage(avatar,"\nWarning: This Tip-Jar is OUT OF SERVICE!\nPlease secondlife:///app/agent/"+ llGetOwner() +"/im for support.");
            }
            else{
                llListenRemove(CListener);
                state inUse;
            }
        }
    }
    
     http_request(key id, string method, string body){
        if (id == IPNEndpointRequest_id && method == URL_REQUEST_GRANTED){
            IPNEndpointURL = llEscapeURL(body);
            llHTTPResponse(id, 200, "success"); 
        }        
        else if (method == "POST" && llGetHTTPHeader(id, "x-remote-ip") == HttpInAllowedIP){
	    string status = llJsonGetValue(body, ["status"]);
            if(status == "expired" || status == "invalid"){
                if (notifications){
                        llInstantMessage(llGetOwner(),"\nWarning: Invoice ID: "+ llJsonGetValue(body, ["id"]) +" expired!\n"+ llKey2Name(avatar) +" did not pay in time...");
                }
                llHTTPResponse(id, 200, "success");          
            }
            else if(status == "paid"){
                if (notifications){
                    llInstantMessage(llGetOwner(),"\nsecondlife:///app/agent/"+llJsonGetValue(body, ["orderId"]) +"/about donated: "+ llJsonGetValue(body, ["btcPrice"]) +" "+ defaultPaymentMethod +".\nInvoice ID: "+ llJsonGetValue(body, ["id"]) +" Paid (waiting confirmations).");
                }
                llHTTPResponse(id, 200, "success");
            }
            else if(status == "confirmed" || status == "complete"){
                donors += "\nsecondlife:///app/agent/"+ llJsonGetValue(body, ["orderId"])+"/about : "+ llJsonGetValue(body, ["price"])+" "+ llJsonGetValue(body, ["currency"]) +" ~ "+ llJsonGetValue(body, ["btcPrice"]) +" "+ defaultPaymentMethod +".";
                donated += (float)llJsonGetValue(body, ["btcPrice"]);
                resetRGB();
                if (notifications){
                    llInstantMessage(llGetOwner(),"\nInvoice ID: " + llJsonGetValue(body, ["id"]) +" Confirmed.\nDonated sum: "+ donated +" "+defaultPaymentMethod);                    
                }
                llHTTPResponse(id, 200, "");   
            }
        }
        else{
            llHTTPResponse(id, 403, "");
        }
    }
    
    listen(integer channel, string name, key id, string Box){
        if(avatar == llGetOwner()){
            if (Box == "Close" || Box == " "){ 
                avatar =  NULL_KEY;
                llListenRemove(CListener);
            }
            else if (Box == "RGB On/Off"){
                llDialog(avatar,"\n# Text RGB is: "+(textRGB ? "On" : "Off")+".\n# Object RGB is: "+(objectRGB ? "On" : "Off")+".",["Text","Object","Close","Both"],channel);
            }
            else if (Box == "Text"){
                textRGB = textRGB ? FALSE : TRUE;
                resetRGB();
                avatar =  NULL_KEY;
                llListenRemove(CListener);
            }
            else if (Box == "Object"){
                objectRGB = objectRGB ? FALSE : TRUE;
                resetRGB();
                avatar =  NULL_KEY;
                llListenRemove(CListener);
            }
            else if (Box == "Both"){
                if(textRGB == objectRGB){
                    textRGB = textRGB ? FALSE : TRUE;
                    objectRGB = objectRGB ? FALSE : TRUE;
                }
                else{
                    textRGB = TRUE;
                    objectRGB = TRUE;
                }
                resetRGB();
                avatar =  NULL_KEY;
                llListenRemove(CListener);
            }
            else if (Box == "Donors"){
                if(donors != ""){
                    llInstantMessage(llGetOwner(),donors);
                }
                else{
                    llInstantMessage(llGetOwner(),"\nSnifff! Nobody donated yet :(");
                }
                avatar =  NULL_KEY;
                llListenRemove(CListener);
            }
            else if (Box == "Tip Test"){
                llListenRemove(CListener);
                state inUse;
            }
            else if (Box == "Reset" && isOutOfService && avatar == llGetOwner()){
                isOutOfService = FALSE;
                reset();
            }
            else if (Box == "Log Error" && avatar == llGetOwner()){
                if (errorLog == ""){
                    llInstantMessage(llGetOwner(),"No errors to log");
                } 
                else{
                    llInstantMessage(llGetOwner(),errorLog);
                }
            }
        }    
    }
    
    timer(){
        hue += 0.01; // Increment hue for smooth color transition
        if (hue > 1.0) hue -= 1.0; // Loop hue back to 0
        vector rgb = hsl_to_rgb(hue, 1.0, 0.5); // Convert HSL to RGB
        if(textRGB){
            llSetText(hoverText, rgb, 1.0); // Update floating text
        }
        if(objectRGB){
            llSetLinkPrimitiveParamsFast(0,[PRIM_COLOR,ALL_SIDES, rgb, 1.0]);
        }
    }
}

state inUse{
    state_entry(){
        llSetTimerEvent(0);
        channel = (integer)llFrand(123456789.0) + 1 * -1;
        CListener = llListen( channel, "", "", "");
        orderID = avatar;
        active = TRUE;
        llSetText("Processing...",<1,0.6,0.2>, 1.0);
        llDialog(avatar,"\nThank you "+ llKey2Name(avatar) +" for your donation!\nPlease select the currency for the calculation of the " + defaultPaymentMethod +" to send as donation.\nIf you select "+ defaultPaymentMethod +" you can manually set an amount in "+ defaultPaymentMethod +".",[defaultPaymentMethod,"Close"," ","USD","EUR","GBP"],channel);
        txStatus = "new";
        llSetTimerEvent(60);
    }
    
    touch_start(integer n){
        if (active == TRUE && avatar != NULL_KEY && avatar != llDetectedKey(0)){ 
                llInstantMessage(llDetectedKey(0), "This device is in use!/nPlease wait...");
        }
    }
    
    http_response(key id, integer status, list metaData, string Response){
        if (status == 200 ){
            if (id == requestRates_id){
                string rateJson = llJsonGetValue(Response, [0]);
                if(rateJson != JSON_INVALID){
                    string currencyName = llJsonGetValue(rateJson, ["name"]);
                    string rate =  llJsonGetValue(rateJson, ["rate"]);
                    float cryptoAmount = (float)price / (float)rate;
                    llDialog(avatar,"\nThank you for your purchase!\nThe price " + price +" "+ currencyName +"s at the current rate of " + rate +" "+ currency +" per "+ defaultPaymentMethod +", this do ~"+ (string)cryptoAmount + " " + defaultPaymentMethod +".\n\nDo you have enough coins in your wallet ?",["Yes","Close"],channel);
                }
                else{
                    llInstantMessage(avatar,"\nThere is a problem with the BTCPay server: The rates data source is unavailable!.\nPlease try again after some minutes...");
                    llOwnerSay("\nDetected problem with BTCPay server!.\nError:\nRates data source is unavailable.\nStatus :"+ status);
                    reset();
                    state default;            
                }            
            }
            else if (id == requestInvoice_id){ 
                invoiceID = llJsonGetValue(Response, ["invoiceId"]);
                invoiceURL = llJsonGetValue(Response, ["invoiceUrl"]);
                if (invoiceID == JSON_INVALID || invoiceURL == JSON_INVALID){
                    isOutOfService = TRUE;
                    llInstantMessage(llGetOwner(),"\nDetected problem with BTCPay server!. This Tip-Jar is OUT OF SERVICE.\nWarning: Empty invoiceID or invoiceURL.\nStatus :"+ status +"\n"+ Response);
                    errorLog = Response;
                    llInstantMessage(avatar,"\nDetected a problem with BTCPay server!. This Tip-Jar is OUT OF SERVICE.");
                    reset();
                    state default;
                }
                else {
                    llLoadURL(avatar, "Thank you for your donation!\nPlease, click to open the payment page.\nYour invoice ID is : "+ invoiceID +"\n", invoiceURL);
                    reset();
                    state default;
                }
            }
        }
        else if (status != 200){
            isOutOfService = TRUE;
            llInstantMessage(avatar,"This Tip-Jar is OUT OF SERVICE.\n");
            llInstantMessage(llGetOwner(),"\nDetected problem with BTCPay server!. This Tip-Jar is OUT OF SERVICE.\nStatus :"+ status +"\n"+ llJsonGetValue( llJsonGetValue(Response, ["Store"]),0));
            errorLog = Response; 
            reset();
            state default;
        }
    }
    
    listen(integer channel, string name, key id, string Box){
        if (Box == "Close"){ 
            reset();
            state default;
        }
        else if (Box == "USD" || Box == "EUR" || Box == "GBP"){
            currency = Box; 
            llDialog(avatar,"\nPlease select the amount in "+ currency +" to donate.\nYou can set a Custom amount by clicking the [Custom] button. The amount will be automatically calculated in " + defaultPaymentMethod +" to send as donation.",["100 "+ currency,"Custom","Close","10 " + currency,"25 " + currency,"50 " + currency],channel);
        }
        else if (Box == defaultPaymentMethod){
            currency = defaultPaymentMethod;
            isWaitingAmount = TRUE;
            llTextBox(avatar,"Type an amount of "+ defaultPaymentMethod +" and click [Submit] button.", channel);
        }
        else if (Box == "10 " + currency || Box == "25 " + currency || Box == "50 " + currency || Box == "100 " + currency){
        list l = llParseString2List(Box, " ",[]);
        price = llList2String(l,0);
        requestCurrentRate();
        }
        else if (Box == "Custom"){
            isWaitingAmount = TRUE;
            llTextBox(avatar,"\nPlease, type an amount in "+ currency +" and click [Submit] button.\nThank you :)", channel);
        }
        else if (isWaitingAmount){
            if(Box != ""){
                price = Box; 
                if(isValidAmount(price)){
                    requestCurrentRate();
                }
                else{
                llTextBox(avatar,"\nPlease, type a valid amount superior to 0 in "+ currency +" and click [Submit] button.\nThank you :)", channel);
                }
            }
            else{
                 llTextBox(avatar,"\nPlease, type a valid amount superior to 0 in "+ currency +" and click [Submit] button.\nThank you :)", channel);
            }
        }
        else if (Box == "Yes"){
        requestInvoice();
        }
    }
    
    timer(){
        if(active && invoiceID == "" && txStatus == "new"){
            llInstantMessage(avatar,"\nOperation timeout!\nPlease click the Tip-Jar again to retry.");
            reset();
            state default;
        }
    }
}
