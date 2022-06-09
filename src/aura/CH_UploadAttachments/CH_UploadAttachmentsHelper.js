({
    CHUNK_SIZE: 7120000,
    initiateUpload : function(component, inputFiles, executionIndex) {
        const helper = this;
        helper.apexAction(component, 'c.initiateAttachmentsUpload', { caseId : component.get('v.recordId'), file : inputFiles[executionIndex] }, true)
        .then(uploadInfo => {
            if(uploadInfo.caseHasBeenClosed != null && uploadInfo.caseHasBeenClosed != ''){
            	helper.cancelUpload(component);
                return helper.showToast(component, 'error', 'Error', uploadInfo.caseHasBeenClosed);
        	} else { delete uploadInfo.caseHasBeenClosed; } 
            const { signature, jsonString } = uploadInfo;
            delete uploadInfo.signature;
            delete uploadInfo.jsonString;
            component.set('v.uploadInfo', uploadInfo);
        	//
            helper.httpRequest("POST", uploadInfo.baseURL + uploadInfo.logApiURL, true,{
                'Content-Type': 'application/json',
                'x-amz-date' : uploadInfo.nowFormatted,
                'X-End-User' : 'CAPSCLI',
                'Authorization' : 'Signature keyId="'+uploadInfo.signatureKey+'",' + 'algorithm="hmac-sha256", ' + 'headers="(request-target) x-amz-date x-end-user",' + 'signature= "' + signature + '"',
            }, jsonString).then((request) => {
                if(request.status == 200 || request.status == 201){
                    if(component.get('v.uploadStatus') === 'In Progress') {
                        if(inputFiles[executionIndex].Status !== 'Cancelled') {
                        	inputFiles[executionIndex].Status = 'Preparing';
                			component.set('v.inputFiles', inputFiles);
                			helper.getUploadId(component, inputFiles, executionIndex, request.responseText);
           	 			}
                        else { helper.handleCancelation(component, executionIndex); }
                	}
            	}
                else {
                    helper.cancelUpload(component);
                    return helper.showToast(component, 'error', 'Error', 'Please validate if Customer, Product, Product Release Informations are correct.\n\n Still if you have the error, Please contact System Administrator.');   
                }
            });
        });
    },
    getUploadId : function(component, inputFiles, executionIndex, responseString) { //old > 141lines
        const helper = this;
        const { baseURL, s3SignApiURL, s3SignApiV4URL } = component.get('v.uploadInfo');
        helper.apexAction(component, 'c.parseAttachmentResponse', { response : responseString }, true)
        .then(response => {
            let upload = {
            	baseURL : baseURL,
            	sign : {
            		version : response.aws_signature_version,
            		apiURl : s3SignApiURL,
            		apiV4URl : s3SignApiV4URL,
        		},
              	filename : encodeURIComponent(response.s3keyname),
        	};
            const date = new Date();
            const dateTime = $A.localizationService.formatDateTimeUTC(date, 'yyyyMMddTHHmmss')+'Z';
            const payloadHash = __sjcl().codec.hex.fromBits(__sjcl().hash.sha256.hash(''));
            const credentialScope = $A.localizationService.formatDateUTC(date,'yyyyMMdd') + '/' + response.s3_region + '/s3/aws4_request';
            //
            let getURL = '';
            if(upload.sign.version === '2'){
            	getURL = upload.baseURL + upload.sign.apiURl + '?to_sign=' + encodeURIComponent('POST\n\n\n\n'+'x-amz-acl:'+response.acl+'\n'+'x-amz-date:'+response.amzdate+'\n'+'/'+response.bucket+'/'+ upload.filename +'?uploads') +
                         '&signer=' + encodeURIComponent(response.signer) + '&user=' + encodeURIComponent(response.user) + '&expiration=' + encodeURIComponent(response.expiration) + '&permission=' + 
            			 encodeURIComponent(response.permission) + '&signtoken=' + encodeURIComponent(response.signtoken);
        	}
            else if(upload.sign.version === '4'){
            	const canonicalRequest = 'POST\n/' + response.aws_url.split('/')[3] + '/' + response.aws_url.split('/')[4] + '/' + response.bucket + '/' + upload.filename +
                    				   '\nuploads=\nhost:' + response.aws_url.split('/')[2] + '\nx-amz-acl:private\nx-amz-date:' + dateTime + '\n\nhost;x-amz-acl;x-amz-date\n' + payloadHash;
            	const toSign = 'AWS4-HMAC-SHA256\n' +  dateTime + '\n' +  credentialScope + '\n' + __sjcl().codec.hex.fromBits(__sjcl().hash.sha256.hash(canonicalRequest));
            	getURL = upload.sign.apiV4URl + '?to_sign=' + encodeURIComponent(toSign) + '&datetime=' + encodeURIComponent(dateTime) + '&canonical_request=' + encodeURIComponent(canonicalRequest) +
                    	 '&signer=' + encodeURIComponent(response.signer) + '&user=' + encodeURIComponent(response.user) + '&expiration=' + encodeURIComponent(response.expiration) +
                    	 '&permission='  +encodeURIComponent(response.permission) + '&signtoken=' + encodeURIComponent(response.signtoken);
        	}
        	helper.httpRequest("GET", getURL, true).then((request) => {
                if(request && request.status == 200) {
                	let headers = {};
                  	if(upload.sign.version === '2') {
                		headers['Authorization'] = 'AWS ' + response.aws_key + ':' + request.responseText;
                        headers['x-amz-acl'] = response.acl;
                        headers['x-amz-date'] = response.amzdate;
                    }else if(upload.sign.version === '4'){
                        headers['x-amz-content-sha256'] = payloadHash;
                        headers['x-amz-acl'] = response.acl;
                        headers['x-amz-date'] = dateTime;
                        headers['Authorization'] = 'AWS4-HMAC-SHA256 ' + 'Credential=' + response.aws_key + '/' + credentialScope + ', SignedHeaders=host;x-amz-acl;x-amz-date, Signature=' + request.responseText;
                    }
                	return helper.httpRequest("POST", response.aws_url + '/' + response.bucket + '/' + upload.filename + '?uploads', true, headers);
            	}
            }).then((request) => {
                if(request && request.status == 200) {
                	upload.id = new DOMParser().parseFromString(request.responseText,"text/xml").getElementsByTagName("UploadId")[0].childNodes[0].nodeValue;
					upload.start = 0, upload.end = Math.min(inputFiles[executionIndex].File.size, upload.start + helper.CHUNK_SIZE);
                	upload.partNumber = 1, upload.blob = inputFiles[executionIndex].File.slice(upload.start, upload.end);
                    if(component.get('v.uploadStatus') === 'In Progress') {
                        if(inputFiles[executionIndex].Status !== 'Cancelled') {
                        	inputFiles[executionIndex].Status = 'Uploading';
                			component.set('v.inputFiles', inputFiles);
                			//
                            if(upload.sign.version === '2'){
                				helper.upload(component, inputFiles, executionIndex, response, upload);
                            }
                    		else if(upload.sign.version === '4'){
                                var fileReader = new FileReader();
                                fileReader.onload = () => helper.upload(component, inputFiles, executionIndex, response, upload, helper.md5digest(fileReader.result));
                                fileReader.readAsArrayBuffer(upload.blob)
                            }
           	 			}
                        else { helper.handleCancelation(component, executionIndex); }
                	}
            	}
                else helper.showToast(component, 'error', 'Error', 'An error has occurred. Call out does not have "OK" status.');
            });
        });
	},
    upload : function (component, inputFiles, executionIndex, response, upload, digest1) { //old > 147lines
        const helper = this;
        const date = new Date();
        const dateTime = $A.localizationService.formatDateTimeUTC(date, 'yyyyMMddTHHmmss')+'Z';
        //
        let getURL = '';
        if(upload.sign.version === '2'){
            var urlToSign = 'PUT\n\ntext/plain;charset=UTF-8\n\nx-amz-date:' + date.toGMTString() + '\n/' + response.bucket +
                			'/' + upload.filename + '?partNumber=' + upload.partNumber.toString() + '&uploadId=' + upload.id;
            getURL = upload.baseURL + upload.sign.apiURl + '?to_sign=' + encodeURIComponent(urlToSign) + 
                     '&signer=' + encodeURIComponent(response.signer) + '&user=' + encodeURIComponent(response.user) +
                	 '&expiration=' + encodeURIComponent(response.expiration) + '&permission=' + encodeURIComponent(response.permission) +
                	 '&signtoken=' + encodeURIComponent(response.signtoken);
        }
        else if(upload.sign.version === '4'){
            const canonicalRequest = 'PUT\n/' + response.aws_url.split('/')[3] + '/' + response.aws_url.split('/')[4] + '/' + response.bucket + '/' + upload.filename +
                    				 '\npartNumber=' + upload.partNumber.toString() + '&uploadId=' + upload.id + '\ncontent-md5:' + digest1 + '\n' +
                					 'host:' + response.aws_url.split('/')[2] + '\nx-amz-date:' + dateTime + '\n\ncontent-md5;host;x-amz-date\nUNSIGNED-PAYLOAD';
            const toSign = 'AWS4-HMAC-SHA256\n' + dateTime + '\n' +  $A.localizationService.formatDateUTC(date,'yyyyMMdd') + '/' + response.s3_region + '/s3/' +
                		   'aws4_request' + '\n' +  __sjcl().codec.hex.fromBits(__sjcl().hash.sha256.hash(canonicalRequest));
            getURL = upload.sign.apiV4URl + '?to_sign=' + encodeURIComponent(toSign) + '&datetime=' + encodeURIComponent(dateTime) + '&canonical_request=' + encodeURIComponent(canonicalRequest) + 
                	 '&signer='+encodeURIComponent(wrapperData.signer) + '&user=' + encodeURIComponent(response.user) + '&expiration=' + encodeURIComponent(response.expiration) + 
                	 '&permission=' + encodeURIComponent(response.permission) + '&signtoken=' + encodeURIComponent(response.signtoken);
        }
        helper.httpRequest("GET", getURL, true).then((request) => {
            if(request && request.status == 200) {
            	let headers = {};
        		if(upload.sign.version === '2'){
            		headers['Authorization'] = 'AWS '+  response.aws_key + ':'+ request.responseText;
                    headers['x-amz-date'] = date.toGMTString();
                    headers['Content-Type'] = 'text/plain;charset=UTF-8';
                }
                else if(upload.sign.version === '4'){
            		headers['Authorization'] = 'AWS4-HMAC-SHA256 Credential=' + response.aws_key + '/' + $A.localizationService.formatDateUTC(date,'yyyyMMdd') + '/' + response.s3_region + '/s3/aws4_request, SignedHeaders=content-md5;host;x-amz-date, Signature=' + request.responseText
                    headers['x-amz-content-sha256'] = 'UNSIGNED-PAYLOAD'; 
                    headers['x-amz-date'] = dateTime;
                    headers['content-md5'] = digest1;
                }
            	return helper.httpRequest("PUT", response.aws_url + '/' + response.bucket + '/' + upload.filename + '?partNumber=' + upload.partNumber.toString()+ '&uploadId=' + upload.id, true, headers, upload.blob);
        	}
        }).then((request) => {
            if(request && request.status == 200) {
                if(!upload.partToETag) { upload.partToETag = {}; }
                upload.partToETag[upload.partNumber] = request.getResponseHeader('ETag');
                upload.start = upload.end;
				upload.end = Math.min(inputFiles[executionIndex].File.size, upload.start + helper.CHUNK_SIZE);
				upload.partNumber++;
				if(upload.start  < upload.end) {
                    upload.blob = inputFiles[executionIndex].File.slice(upload.start, upload.end);
                    if(component.get('v.uploadStatus') === 'In Progress') {
                        if(inputFiles[executionIndex].Status !== 'Cancelled') {
                            inputFiles[executionIndex].Progress += (100 / Math.round(inputFiles[executionIndex].File.size / helper.CHUNK_SIZE));
                            component.set('v.inputFiles', inputFiles);
                            //
                            if(upload.sign.version === '2'){
                				helper.upload(component, inputFiles, executionIndex, response, upload);
                            }
                    		else if(upload.sign.version === '4'){
                                var fileReader = new FileReader();
                                fileReader.onload = () => helper.upload(component, inputFiles, executionIndex, response, upload, helper.md5digest(fileReader.result));
                                fileReader.readAsArrayBuffer(upload.blob)
                            }
           	 			}
                        else { helper.handleCancelation(component, executionIndex); }
                	}
                }
                else {
                    if(component.get('v.uploadStatus') === 'In Progress') {
                        if(inputFiles[executionIndex].Status !== 'Cancelled') {
                            inputFiles[executionIndex].Progress = 100;
                            component.set('v.inputFiles', inputFiles);
                            //
                            helper.completeUpload(component, inputFiles, executionIndex, response, upload);
                        }
                        else { helper.handleCancelation(component, executionIndex); }
                    }
                }
        	}
            else helper.showToast(component, 'error', 'Error', 'An error has occurred. Call out does not have "OK" status.');
        })
    },
    completeUpload : function(component, inputFiles, executionIndex, response, upload) {
        const helper = this;
        if(component.get('v.uploadStatus') === 'In Progress') {
            if(inputFiles[executionIndex].Status !== 'Cancelled') {
                inputFiles[executionIndex].Status = 'Completing';
                component.set('v.inputFiles', inputFiles);
                const failUpload = (err) => {
                    console.error('Upload Failed: ' + err);
                    inputFiles[executionIndex].Status = 'Failed';
                    inputFiles[executionIndex].Progress = 0;
                    component.set('v.inputFiles', inputFiles);
                }
                //
                helper.apexAction(component, 'c.completeAttachmentUpload', {
                    caseId : component.get('v.recordId'),
                    file : inputFiles[executionIndex],
                    initialMap : response,
                    partToETagMap : upload.partToETag,
                    uploadId : upload.id,
                    s3KeyNameInUTF8 : encodeURIComponent(response.s3keyname),
                	isFromEmail : false
                }, true).then(result => {
                    if(result == null) { return failUpload('Null Response'); }
                    inputFiles[executionIndex].Status = 'Completed';
                    inputFiles[executionIndex].Progress = 100;
                    component.set('v.inputFiles', inputFiles);
                	$A.get('e.force:refreshView').fire(); 
                	if(inputFiles[executionIndex+1] != null) {
                        helper.initiateUpload(component, inputFiles, executionIndex+1);
                    }
                	else { component.set('v.uploadStatus', 'Completed'); }
            	}).catch(err => failUpload(err));
            }
        }
	},
    //
    handleCancelation : function(component, executionIndex) {
        let inputFiles = component.get('v.inputFiles');
        if(inputFiles[executionIndex+1] != null){
            this.initiateUpload(component, inputFiles, executionIndex+1);
        }
        else { this.cancelUpload(component); }
	},
    cancelUpload : function(component) {
		component.set('v.uploadStatus', '');
        component.set('v.inputFiles', []);
	},
    //
    httpRequest: function(method, url, async, header, sendBody) {
        var xhr = new XMLHttpRequest();
        xhr.open(method, url, async?true:false);
        if(header != null && typeof header === 'object') {
            const headerKeys = Object.keys(header);
            for(let i = 0, len = headerKeys.length; i < len; i++) {
                xhr.setRequestHeader(headerKeys[i], header[headerKeys[i]]);
            }
        }
        return new Promise((resolve) => (xhr.onload = () => resolve(xhr), (sendBody?xhr.send(sendBody):xhr.send())));
    },
    md5digest : function(result){
        var SparkMD5 = __SparkMD5().ArrayBuffer.hash(result);
        var hex  = SparkMD5.toString();
        var str = '';
        for (var n = 0; n < hex.length; n += 2) {
            str += String.fromCharCode(parseInt(hex.substr(n, 2), 16));
        }
        var digestValue = btoa(str);
        return digestValue;
    },
    //
    apexAction: function(component, method, params, handleError) {
        let helper = this, action = component.get(method);
        helper.incrementActionCounter(component);
        return new Promise(function(resolve, reject) { 
        	if(params) action.setParams(params);
        	action.setCallback(helper, function(response) {
                let state = response.getState();
                helper.decrementActionCounter(component);
                if (state === "SUCCESS") {
                    resolve(response.getReturnValue());
                } else {
                    if(handleError) {
                        var error = response.getError();
                        var message =  error && error[0] && error[0].message ? error[0].message : "Something went wrong";
                        helper.showToast(component, 'error', 'Error', message);
                    }
                    else reject(response.getError());
                }
            });
            $A.enqueueAction(action);
        });
    },
    // Generic Toast Message
    showToast: function(component, sType, title, message) {
        const helper = this;
        let showToast = $A.get("e.force:showToast");
        if(showToast) {
            showToast.setParams({
                "title": title,
                "message": message,
                "type": sType
            }).fire();
        }
        else {
            component.set('v.portalToast', {
                "title": title,
                "message": message,
                "type": sType
            });
            clearTimeout(helper.timeout);
            helper.timeout = setTimeout(() => component.set('v.portalToast', null), 5000);
        }
    },
    // Loading Framework
    isLoading: function(component) {
        return component.get("v.showSpinner");
    },
    incrementActionCounter: function(component) {
        var counter = component.get("v.actionCounter") + 1;
        if (counter === 1) {
            component.set("v.showSpinner", true);
        }
        component.set("v.actionCounter", counter);
    },
    decrementActionCounter: function(component) {
        var counter = component.get("v.actionCounter") - 1;
        if (counter === 0) {
            component.set("v.showSpinner", false);
        }
        component.set("v.actionCounter", counter);
    }
})