({    
    fetchPickListValforclassification: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
            }
            component.set("v.classifications", opts);
        });
        $A.enqueueAction(action);
    },   
    CHUNK_SIZE: 7120000,
    uploadHelper : function(component,counter) {
        var counter = counter;
        var filesSelectedForUpload = component.get("v.filesSelectedForUpload");
        var fileSelectedForUpload = filesSelectedForUpload[counter];
        var totalCounter = filesSelectedForUpload.length;       
        var filenumber = counter+1;
        var currentFileName='';
        if(fileSelectedForUpload != undefined && fileSelectedForUpload.File != undefined && fileSelectedForUpload.File.name!= undefined){
            currentFileName=fileSelectedForUpload.File.name;
        }
        var showStatus = 'Uploading File '+ filenumber +'/'+totalCounter+', File Name: ' +currentFileName;
        component.set("v.status",showStatus);
        var self = this;
        if(totalCounter != counter){
            if(component.get("v.uploadCancelled") == false){
                if(fileSelectedForUpload.CancelcurrentFileUpload==false){
                    self.createAttachment(component,counter,fileSelectedForUpload,filesSelectedForUpload);
                }
                else{
                    self.whenCancelled(component,counter);
                }
            }else{
                return;
            }
        }
    },
    createAttachment: function(component,counter,fileSelectedForUpload,filesSelectedForUpload) {
        var self = this;        
        if(component.get("v.uploadCancelled") == false){
            if(fileSelectedForUpload.CancelcurrentFileUpload==false ){
                self.CallProgressBarMethod(component,counter, '0', false,'Preparing'); 
            }
            else{
                self.whenCancelled(component,counter);
            }
        }else{
            return;
        }
        if(fileSelectedForUpload != undefined){
            var action = component.get("c.initiateUpload");
            action.setParams({
                caseRecordId: component.get("v.recordId"),
                customervisible: fileSelectedForUpload.CustomerVisible,
                fileName: fileSelectedForUpload.File.name,
                description: fileSelectedForUpload.Description,
                classifications : fileSelectedForUpload.Classification,
                fileSize: fileSelectedForUpload.File.size
            });     	
            action.setCallback(this, function(response) {
                if(response.getReturnValue() == null){
                    self.errorMessageDisplay(component,'','');
                }
                else if(response.getState() == "SUCCESS"){
                    /*if(component.get("v.uploadCancelled") == false ){
                        if(fileSelectedForUpload.CancelcurrentFileUpload==false){
                            self.CallProgressBarMethod(component,counter, '0', false,'Preparing');
                        }else{
                            self.whenCancelled(component,counter);
                        }
                    }else{
                        return;
                    }*/
                    var wrapResponse = response.getReturnValue();
                    if(wrapResponse.caseHasBeenClosed != undefined && wrapResponse.caseHasBeenClosed != null && wrapResponse.caseHasBeenClosed != ''){
                        var title = 'An error has occurred.';
                        var message = wrapResponse.caseHasBeenClosed;
                        self.errorMessageDisplay(component,title,message);
                        return;
                    }
                    var signature = wrapResponse.signature;
                    var jsonString = wrapResponse.jsonString;
                    console.log(jsonString);
                    component.set("v.baseURL",wrapResponse.baseURL);
                    component.set("v.logApiURL",wrapResponse.logApiURL);
                    component.set("v.s3SignApiURL",wrapResponse.s3SignApiURL);
                    component.set("v.s3SignApiV4URL",wrapResponse.s3SignApiV4URL);
                    var jSONResponse = '';
                    var enpointurl = wrapResponse.baseURL + wrapResponse.logApiURL;
                    var authHeader = 'Signature keyId="'+wrapResponse.signatureKey+'",' + 'algorithm="hmac-sha256", ' + 'headers="(request-target) x-amz-date x-end-user",' + 'signature= "' + signature + '"';
                    var xhr = new XMLHttpRequest();
                    xhr.open("POST", enpointurl, true);
                    xhr.setRequestHeader('Content-Type', 'application/json');
                    xhr.setRequestHeader('x-amz-date', wrapResponse.nowFormatted);
                    xhr.setRequestHeader('X-End-User', 'CAPSCLI');
                    xhr.setRequestHeader('Authorization', authHeader);
                    xhr.onload = function () 
                    {
                        if(xhr.status == 200 || xhr.status == 201){ 
                            jSONResponse = xhr.responseText;
                            if(component.get("v.uploadCancelled") == false && jSONResponse != ''){
                                if(fileSelectedForUpload.CancelcurrentFileUpload==false){
                                    self.CallProgressBarMethod(component,counter, '0' , false,'Preparing');
                                    self.getUploadId(component,counter,fileSelectedForUpload,filesSelectedForUpload,jSONResponse);
                                }else{
                                    self.whenCancelled(component,counter); 
                                }
                            }else{
                                return;
                            }
                        }
                        else{
                            
                            console.log('XHR Request ' + JSON.stringify(xhr));
                            console.log('XHR Request string  ' + JSON.stringify(xhr.responseText));
                            var title = 'An error has occurred. Call out does not have "OK" status.';
                            var message = 'Please validate if Customer, Product, Product Release Informations are correct. \n\n'+ 'Still if you have the error, Please contact System Administrator.';
                            self.errorMessageDisplay(component,title,message);
                        }
                    };
                    xhr.send(jsonString);
                }
                    else if (response.getState() === "INCOMPLETE") {
                    } else if (response.getState() === "ERROR") {
                        self.errorMessageDisplay(component,'','');
                    }
            });
            $A.enqueueAction(action);
        }
    },
    getUploadId: function(component,counter,fileSelectedForUpload,filesSelectedForUpload,jSONResponse) {
        var s3uploadid = '';
        var self = this;
        var baseURL = component.get("v.baseURL");
        var s3SignApiURL = component.get("v.s3SignApiURL");
        var s3SignApiV4URL = component.get("v.s3SignApiV4URL");
        var action = component.get("c.parseAttachmentResponse");
        action.setParams({
            "parseResponse": jSONResponse
        });
        action.setCallback(this, function(response) {
            if(response.getReturnValue() == null){
                self.errorMessageDisplay(component,'','');
            }
            else if (response.getState() == "SUCCESS") {
                var wrapperData = response.getReturnValue();
                component.set("v.uploadWrapper",wrapperData);
                var signatureVersion = wrapperData.aws_signature_version;
                var jSONResponseUploadIDS3Token = '';
                var jSONResponseUploadIDS3Token1 = '';
                var urlPOST = '';
                var credential_scope1 = '';
                var signed_headers1 = '';
                var payload_hash1 = '';
                var dateTimeStamp1 = '';
                var filenameUTF8 = encodeURIComponent(wrapperData.s3keyname);
                var amzdate = '';
                var xhr1 = new XMLHttpRequest();
                if(signatureVersion === '2'){
                    //filenameUTF8 = encodeURIComponent(wrapperData.s3keyname);
                    amzdate = wrapperData.amzdate;
                    var urlToSignPOST = 'POST\n\n\n\n'+'x-amz-acl:'+wrapperData.acl+'\n'+'x-amz-date:'+amzdate+'\n'+'/'+wrapperData.bucket+'/'+filenameUTF8+'?uploads';
                    urlPOST = baseURL+s3SignApiURL+'?to_sign='+encodeURIComponent(urlToSignPOST)+'&signer='+encodeURIComponent(wrapperData.signer)+'&user='+encodeURIComponent(wrapperData.user)+'&expiration='+encodeURIComponent(wrapperData.expiration)+'&permission='+encodeURIComponent(wrapperData.permission)+'&signtoken='+encodeURIComponent(wrapperData.signtoken);
                }else if(signatureVersion === '4'){
                    var emptyString = '';
                    var algorithm1 = 'AWS4-HMAC-SHA256';
                    var version4Now = new Date();
                    dateTimeStamp1 = $A.localizationService.formatDateTimeUTC(version4Now, 'yyyyMMddTHHmmss')+'Z';
                    var dateStamp1 = $A.localizationService.formatDateUTC(version4Now,'yyyyMMdd');
                    var region1 = wrapperData.s3_region;
                    var service1 = 's3';
                    credential_scope1 = dateStamp1 + '/' + region1 + '/' + service1 + '/' + 'aws4_request';
                    var method1 = 'POST';
                    var bucket1 = wrapperData.bucket;
                    var s3keyname1 =encodeURIComponent(wrapperData.s3keyname);
                    var canonical_uri1 = '/'+wrapperData.aws_url.split('/')[3]+'/'+wrapperData.aws_url.split('/')[4]+'/'+bucket1+'/'+s3keyname1;
                    var canonical_querystring1 = 'uploads=';
                    var host1 = wrapperData.aws_url.split('/')[2];
                    var canonical_headers1 = 'host:' + host1 + '\n' +'x-amz-acl:' +'private'+'\n'+ 'x-amz-date:' + dateTimeStamp1 +'\n';
                    signed_headers1 = 'host;x-amz-acl;x-amz-date';
                    payload_hash1 = __sjcl().codec.hex.fromBits(__sjcl().hash.sha256.hash(emptyString));//EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(''))); 
                    var canonical_request1 = method1 + '\n' + canonical_uri1 + '\n' + canonical_querystring1 + '\n' + canonical_headers1 + '\n' + signed_headers1 + '\n' + payload_hash1;
                    var to_sign1 = algorithm1 + '\n' +  dateTimeStamp1 + '\n' +  credential_scope1 + '\n' + __sjcl().codec.hex.fromBits(__sjcl().hash.sha256.hash(canonical_request1));//EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(canonical_request)));
                    urlPOST = s3SignApiV4URL+'?to_sign='+encodeURIComponent(to_sign1)+'&datetime='+encodeURIComponent(dateTimeStamp1)+'&canonical_request='+encodeURIComponent(canonical_request1)+'&signer='+encodeURIComponent(wrapperData.signer)+'&user='+encodeURIComponent(wrapperData.user)+'&expiration='+encodeURIComponent(wrapperData.expiration)+'&permission='+encodeURIComponent(wrapperData.permission)+'&signtoken='+ encodeURIComponent(wrapperData.signtoken);
                }
                xhr1.open("GET", urlPOST, true);
                xhr1.onload = function () 
                {
                    if(xhr1.status == 200){
                        /*if(component.get("v.uploadCancelled") == false){
                            if(fileSelectedForUpload.CancelcurrentFileUpload==false){
                                self.CallProgressBarMethod(component,counter, '0', false,'Preparing');
                            }else{
                                self.whenCancelled(component,counter);
                            }
                        }else{
                            return;
                        }*/
                        jSONResponseUploadIDS3Token1 = xhr1.responseText;
                        var xhr2 = new XMLHttpRequest();
                        var enpointPOST = wrapperData.aws_url + '/' + wrapperData.bucket + '/' + filenameUTF8 + '?uploads';
                        xhr2.open("POST", enpointPOST, true);
                        if(signatureVersion === '2'){
                            var s3authPOST = wrapperData.aws_key+':'+jSONResponseUploadIDS3Token1;
                            var authHead = 'AWS ' + s3authPOST;
                            xhr2.setRequestHeader('Authorization', authHead);
                            xhr2.setRequestHeader('x-amz-acl', wrapperData.acl);
                            xhr2.setRequestHeader('x-amz-date', amzdate);
                        }else if(signatureVersion === '4'){
                            var authHeadV41 = 'AWS4-HMAC-SHA256 '+'Credential='+wrapperData.aws_key+'/'+credential_scope1+', SignedHeaders='+signed_headers1+', Signature='+jSONResponseUploadIDS3Token1;
                            xhr2.setRequestHeader('x-amz-content-sha256', payload_hash1);
                            xhr2.setRequestHeader('x-amz-acl', wrapperData.acl);
                            xhr2.setRequestHeader('x-amz-date', dateTimeStamp1);
                            xhr2.setRequestHeader('Authorization', authHeadV41);
                        }
                        xhr2.onload = function () 
                        {
                            if(xhr2.status == 200){ 
                                jSONResponseUploadIDS3Token = xhr2.responseText;
                                var parser;
                                var xmlDoc;
                                parser = new DOMParser();
                                xmlDoc = parser.parseFromString(jSONResponseUploadIDS3Token,"text/xml");
                                s3uploadid = xmlDoc.getElementsByTagName("UploadId")[0].childNodes[0].nodeValue;
                                var startPosition = 0;
                                var partNumber = 1;   
                                var endPosition = Math.min(fileSelectedForUpload.File.size, startPosition + self.CHUNK_SIZE);
                                var blob = fileSelectedForUpload.File.slice(startPosition, endPosition);
                                if(component.get("v.uploadCancelled") == false){
                                    if(fileSelectedForUpload.CancelcurrentFileUpload==false){
                                        var digest1;
                                        self.CallProgressBarMethod(component,counter, '0', false,'Uploading');
                                        if(signatureVersion === '2'){
                                            self.uploadMultipart(component,counter,s3uploadid,partNumber,startPosition,endPosition,fileSelectedForUpload,filesSelectedForUpload,'',blob,digest1);
                                        }else if(signatureVersion === '4'){
                                            var fileReader = new FileReader();
                                            fileReader.onload = function(){
                                                digest1 = self.md5digest(component,fileReader.result);
                                                self.uploadMultipart(component,counter,s3uploadid,partNumber,startPosition,endPosition,fileSelectedForUpload,filesSelectedForUpload,'',blob,digest1);
                                            }
                                            fileReader.readAsArrayBuffer(blob)
                                        }
                                    }else{
                                        self.whenCancelled(component,counter);
                                    }
                                }
                                else{
                                    return;
                                }
                            }
                            else{
                                var title = 'An error has occurred. Call out does not have "OK" status.';
                                self.errorMessageDisplay(component,title,'');
                            }
                        };
                        xhr2.send();
                    }
                    else{
                        var title = 'An error has occurred. Call out does not have "OK" status.';
                        self.errorMessageDisplay(component,title,'');
                    }
                };
                xhr1.send();
            }
                else if (response.getState() === "INCOMPLETE") {
                } else if (response.getState() === "ERROR") {
                    var errors = response.getError();
                    self.errorMessageDisplay(component,'','');
                }
        });
        $A.enqueueAction(action);
    },
    Y:0,
    uploadMultipart: function(component,counter,s3uploadid,partNumber,startPosition,endPosition,fileSelectedForUpload,filesSelectedForUpload,partVsetagjson,blob,digest1){
        var partVsetagjson = partVsetagjson;
        var self = this;
        var s3SignApiV4URL = component.get("v.s3SignApiV4URL");
        var jSONResponseETag = '';
        var wrapperData = component.get("v.uploadWrapper");
        var signatureVersion = wrapperData.aws_signature_version;
        var filenameUTF8 = encodeURIComponent(wrapperData.s3keyname);
        var ts4 = new Date();
        var nowFormatted = ts4.toGMTString();
        var JSONResponseS3 = '';
        var xhr3 = new XMLHttpRequest();
        var urlPUT = '';
        var dateTimeStamp2 = '';
        var sign_headers2 = '';
        var credential_scope2 = '';
        var md5data = '';
        if(signatureVersion === '2'){
            var urlToSignPUT = 'PUT\n\n'+'text/plain;charset=UTF-8'+'\n\n'+'x-amz-date:'+nowFormatted+'\n'+'/'+wrapperData.bucket+'/'+filenameUTF8+'?partNumber='+partNumber.toString()+'&uploadId='+s3uploadid;
            urlPUT = component.get("v.baseURL") + component.get("v.s3SignApiURL") +'?to_sign='+encodeURIComponent(urlToSignPUT)+'&signer='+encodeURIComponent(wrapperData.signer)+'&user='+encodeURIComponent(wrapperData.user)+'&expiration='+encodeURIComponent(wrapperData.expiration)+'&permission='+encodeURIComponent(wrapperData.permission)+'&signtoken='+encodeURIComponent(wrapperData.signtoken);
        }else if(signatureVersion === '4'){
            var algorithm2 = 'AWS4-HMAC-SHA256';
            var version4Now1 = new Date();
            dateTimeStamp2 = $A.localizationService.formatDateTimeUTC(version4Now1, 'yyyyMMddTHHmmss')+'Z';
            var dateStamp2 = $A.localizationService.formatDateUTC(version4Now1,'yyyyMMdd');
            var region2 = wrapperData.s3_region;
            var service2 = 's3'; 
            credential_scope2 = dateStamp2 + '/' + region2 + '/' + service2 + '/' + 'aws4_request';
            var method2 = 'PUT';
            var bucket2 = wrapperData.bucket;
            var s3keyname2 =filenameUTF8;
            var canonical_uri2 = '/'+wrapperData.aws_url.split('/')[3]+'/'+wrapperData.aws_url.split('/')[4]+'/'+bucket2+'/'+s3keyname2;
            var canonical_part = 'partNumber='+partNumber.toString()+'&uploadId='+s3uploadid;
            var canonical_querystring2 = 'uploads=';
            var host2 = wrapperData.aws_url.split('/')[2];
            var canonical_headers2 = 'host:' + host2 + '\n' + 'x-amz-date:' + dateTimeStamp2;
            sign_headers2 = 'content-md5;host;x-amz-date';
            var canonical_part2 = 'content-md5:'+digest1;
            var canonical_request2 = method2 + '\n' + canonical_uri2 + '\n' + canonical_part + '\n' + canonical_part2 + '\n' + canonical_headers2 + '\n'+'\n'+sign_headers2 + '\n' + 'UNSIGNED-PAYLOAD';
            var to_sign2 = algorithm2 + '\n' +  dateTimeStamp2 + '\n' +  credential_scope2 + '\n' +  __sjcl().codec.hex.fromBits(__sjcl().hash.sha256.hash(canonical_request2));//EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(canonical_request2)));
            var urlPUT = s3SignApiV4URL+'?to_sign='+encodeURIComponent(to_sign2)+'&datetime='+encodeURIComponent(dateTimeStamp2)+'&canonical_request='+encodeURIComponent(canonical_request2)+'&signer='+encodeURIComponent(wrapperData.signer)+'&user='+encodeURIComponent(wrapperData.user)+'&expiration='+encodeURIComponent(wrapperData.expiration)+'&permission='+encodeURIComponent(wrapperData.permission)+'&signtoken='+ encodeURIComponent(wrapperData.signtoken);
        }
        var viewData = { 
            Name : [] 
        };
        xhr3.open("GET", urlPUT, true);
        xhr3.onload = function () 
        {
            if(xhr3.status == 200){
                JSONResponseS3 = xhr3.responseText;
                var uploadEndPointUrl = '';
                var xhr4 = new XMLHttpRequest();
                uploadEndPointUrl = wrapperData.aws_url + '/'+wrapperData.bucket+'/'+filenameUTF8+'?partNumber='+partNumber.toString()+'&uploadId='+s3uploadid;
                xhr4.open("PUT", uploadEndPointUrl, true);
                if(signatureVersion === '2'){
                    var s3authPUT = wrapperData.aws_key + ':'+JSONResponseS3;
                    var authHead3 = 'AWS '+s3authPUT;
                    xhr4.setRequestHeader('Authorization', authHead3);
                    xhr4.setRequestHeader('x-amz-date', nowFormatted);
                    xhr4.setRequestHeader('Content-Type', 'text/plain;charset=UTF-8');
                }else if(signatureVersion === '4'){
                    var s3auth = 'Credential='+wrapperData.aws_key+'/'+credential_scope2+', SignedHeaders='+sign_headers2+', Signature='+JSONResponseS3;
                    var authHead3PUT = 'AWS4-HMAC-SHA256 '+s3auth;
                    xhr4.setRequestHeader('Authorization', authHead3PUT);
                    xhr4.setRequestHeader('x-amz-content-sha256', 'UNSIGNED-PAYLOAD'); 
                    xhr4.setRequestHeader('x-amz-date', dateTimeStamp2);
                    xhr4.setRequestHeader('content-md5', digest1); 
                    
                }
                xhr4.onload = function () 
                {
                    if(xhr4.status == 200){
                        jSONResponseETag = xhr4.getResponseHeader('ETag');
                        if(partVsetagjson == null || partVsetagjson == ''){
                            partVsetagjson = { 
                                Name : [] 
                            };
                        }
                        var jsonData = {};
                        var columnName = 'partNumber';
                        jsonData[columnName] = partNumber;
                        var columnName = 'etag';
                        jsonData[columnName] = jSONResponseETag;
                        partVsetagjson.Name.push(jsonData);
                        startPosition = endPosition;
                        endPosition = Math.min(fileSelectedForUpload.File.size, startPosition + self.CHUNK_SIZE);
                        partNumber = partNumber + 1;
                        if(startPosition  < endPosition){
                            var blob = fileSelectedForUpload.File.slice(startPosition, endPosition);
                            if(component.get("v.uploadCancelled") == false){
                                if(fileSelectedForUpload.CancelcurrentFileUpload==false){
                                    var barChunkNo =Math.round(fileSelectedForUpload.File.size / self.CHUNK_SIZE);
                                    var progressBarPart = (100 / barChunkNo);
                                    var x ;
                                    x = self.Y;
                                    if(x == 0 ){ self.Y = 0 + progressBarPart; }
                                    else {self.Y =progressBarPart + x;}
                                    self.CallProgressBarMethod(component,counter,  self.Y,false,'Uploading'); 
                                    var digest2;
                                    if(signatureVersion === '2'){
                                        self.uploadMultipart(component,counter,s3uploadid,partNumber,startPosition,endPosition,fileSelectedForUpload,filesSelectedForUpload,partVsetagjson,blob,digest2);
                                    }else if(signatureVersion === '4'){
                                        var fileReader = new FileReader();
                                    	fileReader.onload = function(){
                                            digest2 = self.md5digest(component,fileReader.result);
                                            self.uploadMultipart(component,counter,s3uploadid,partNumber,startPosition,endPosition,fileSelectedForUpload,filesSelectedForUpload,partVsetagjson,blob,digest2);
                                        }
                                        fileReader.readAsArrayBuffer(blob)
                                    }
                                }else{
                                    self.whenCancelled(component,counter);                                
                                }
                            }
                            else{
                                return;
                            }
                        }else{
                            if(component.get("v.uploadCancelled") == false){
                                if(fileSelectedForUpload.CancelcurrentFileUpload==false){
                                    var removeElement=document.getElementById('removeId-'+counter);
                                    if(removeElement){
                                        document.getElementById('removeId-'+counter).remove('lightning-icon');
                                    }
                                    self.CallProgressBarMethod(component,counter, '100', false,'Uploading'); 
                                    self.Y = 0;
                                    self.completeFile(component,counter, partVsetagjson, s3uploadid,fileSelectedForUpload,filesSelectedForUpload); 
                                }else{
                                    self.whenCancelled(component,counter);
                                }
                            }
                            else{
                                return;
                            }
                        }
                    }else{
                        var title = 'An error has occurred. Call out does not have "OK" status.';
                        self.errorMessageDisplay(component,title,'');
                    }
                }; 
                xhr4.send(blob);
            }
            else{
                var title = 'An error has occurred. Call out does not have "OK" status';
                self.errorMessageDisplay(component,title,'');
            }
        };
        xhr3.send();
    },    
    completeFile: function(component,counter,partVsetagjson,s3uploadid,fileSelectedForUpload,filesSelectedForUpload) {
        var wrapperData = component.get("v.uploadWrapper");
        var filenameUTF8 = encodeURIComponent(wrapperData.s3keyname);
        var self = this;
        //console.log('partVsetagjson'+JSON.stringify(partVsetagjson));
        if(component.get("v.uploadCancelled") == false){
            if(fileSelectedForUpload.CancelcurrentFileUpload==false){
                self.CallProgressBarMethod(component,counter, '100', false,'Completing');
            }
            
        }
        if(fileSelectedForUpload != undefined){
            var action = component.get("c.uploadComplete");
            action.setParams({
                "partVsetagjson": JSON.stringify(partVsetagjson),
                "s3uploadid": s3uploadid,
                "wrapperFromJs": JSON.stringify(component.get("v.uploadWrapper")),
                "fileName" : fileSelectedForUpload.File.name,
                "fileSize" : fileSelectedForUpload.File.size,
                "caseRecordId" : component.get("v.recordId"),
                "customervisible" : fileSelectedForUpload.CustomerVisible,
                "description" : fileSelectedForUpload.Description,
                "classfication" : fileSelectedForUpload.Classification,
                "s3KeyNameInUTF8" : encodeURIComponent(wrapperData.s3keyname),
                "isFromEmail" : false
            });
            action.setCallback(this, function(response) {
                if(response.getReturnValue() == null){
                    self.CallProgressBarMethod(component,counter, '0', true,'Failed');
                    self.Y = 0;
                    self.errorMessageDisplay(component,'','');
                }
                else if(response.getState() == "SUCCESS"){
                    self.CallProgressBarMethod(component,counter, '100', false,'Completed');
                    self.Y = 0;
                    counter++;
                    var appEvent = $A.get("e.c:CH_UploadEvent");
                    appEvent.fire();
                    if(counter < filesSelectedForUpload.length){
                        self.uploadHelper(component,counter);
                    }
                    else{
                        component.set("v.status",'Upload Completed');
                        component.set("v.uploadStarted", false);
                        component.set("v.filesSelectedForUpload", []);
                    }
                }
                    else if (response.getState() === "INCOMPLETE") {
                    } else if (response.getState() === "ERROR") {
                        self.CallProgressBarMethod(component,counter, '0', true,'Failed');
                        self.Y = 0;
                        var errors = response.getError();
                        self.errorMessageDisplay(component,'','');
                    }
            });
        }
        $A.enqueueAction(action);
    },
    removeItem: function(component, index) {
        var filesSelectedForUpload = component.get("v.filesSelectedForUpload");      
        var fileSelectedForUpload = filesSelectedForUpload[index];
        fileSelectedForUpload.CancelcurrentFileUpload=true;
        var self = this;
        var newList = component.get("v.filesSelectedForUpload");
        var uploadStarted = component.get("v.uploadStarted");
        if(!uploadStarted){
            newList.splice(index, 1);
        }
        if(uploadStarted){
            var removeElement=document.getElementById('removeId-'+index);
            if(removeElement){
                document.getElementById('removeId-'+index).remove('lightning-icon');
                self.CallProgressBarMethod(component,index, '0', true,'Upload Cancelled');
            }
            var allTrue = true;
            for(var i in newList){
                if(!newList[i].CancelcurrentFileUpload){
                    allTrue = false;
                }
            }
            component.set("v.isAllCancelled", allTrue);
        }
        component.set("v.filesSelectedForUpload", newList);
        if(newList.length ==0){
            component.set("v.uploadButtonIsDisabled", true);
        }
    },
    isCommunity: function(component) {
        var action = component.get("c.isCommunity");
        action.setCallback(this, function(response) {
            component.set("v.isCommunity", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    errorMessageDisplay: function(component,title,message) {
        if(title != null && title != ''){
            title = title;
        }else{
            title = 'An internal server error has occurred.'; 
        }
        if(message != null && message != ''){
            message = message;
        }else{
            message = 'Your File Upload Failed. Please refresh the Page.';
        }
        if(!component.get("v.isCommunity")){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : title,
                message: message,
                type : 'Error',
                mode: 'sticky'
            });
            toastEvent.fire();
        }else if(component.get("v.isCommunity")){
            component.set("v.errorMessagePopup", title+ '\n\n'+message);
            component.set("v.isMessageModalOpened", true);
        }
        component.set("v.uploadStarted", false);
        component.set("v.filesSelectedForUpload", []);
        component.set("v.status",'');
        return;
    },
    getCaseInfo: function(component) {
        var action = component.get("c.getCaseInfo");
        action.setParams({
            "caseId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            if(result != null){
                component.set("v.caseDetails",result);
            } 
        });
        $A.enqueueAction(action);
    },
    isWorkgroupMember: function(component) {
        var action = component.get("c.getCaseTeamMembers");
        action.setParams({
            "caseId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            if(result == true){
                component.set("v.isCaseWorkgroupMember",true);
            } 
        });
        $A.enqueueAction(action);
    },
    CallProgressBarMethod : function(component,counter, progressBarAal, isAbort,statusVal){
        var progressBarAuraMethod = component.find("ProgressBarId");
        if(progressBarAuraMethod != undefined){
            if(progressBarAuraMethod.length > 1){
                progressBarAuraMethod[counter].progressBarMethod(progressBarAal,isAbort,statusVal);
            }else{
                progressBarAuraMethod.progressBarMethod(progressBarAal,isAbort,statusVal);
            }
        }
    },
    whenCancelled : function(component,counter){
        var self = this;
        var filesSelectedForUpload = component.get("v.filesSelectedForUpload");
        self.Y = 0;
        if(filesSelectedForUpload[counter+1] != undefined){
            self.uploadHelper(component,counter+1);
        }else
        {	
            component.set("v.uploadStarted", false);
            component.set("v.filesSelectedForUpload", []);
            if(component.get("v.isAllCancelled")){
                component.set("v.status",'Upload Cancelled');   
            }else{
                component.set("v.status",'Upload Completed');
            }
            return;
        }
    },
    md5digest : function(component, result){
        var SparkMD5 = __SparkMD5().ArrayBuffer.hash(result);
        var hex  = SparkMD5.toString();
        var str = '';
        for (var n = 0; n < hex.length; n += 2) {
            str += String.fromCharCode(parseInt(hex.substr(n, 2), 16));
        }
        var digestValue = btoa(str);
        return digestValue;
    },
})