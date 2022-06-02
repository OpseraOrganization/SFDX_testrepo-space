import { LightningElement, api } from 'lwc';
//Made by tiago.almeida@nokia.com
export default class NokiaUtils extends LightningElement {
    @api buildWordDocument(content, options) {
        const pagebreak = '<p style="page-break-after: always;">&nbsp;</p><p style="page-break-before: always;">&nbsp;</p>';
        content = content || '', options = options || {};
        //
        options.orientation = (!options.orientation?'portrait':(options.orientation==='portrait'||options.orientation==='landscape')?options.orientation:'portrait');
        options.size= (!options.size?'A4':options.size);
        switch(options.size.toUpperCase()){
            case 'A3':
                options.size= (options.orientation==="portrait"?"11.7in 16.5in":"16.5in 11.7in");
            case 'A4':
                options.size= (options.orientation==="portrait"?"8.3in 11.7in":"11.7in 8.3in");
            case 'A5':
                options.size= (options.orientation==="portrait"?"5.8in 8.3in":"8.3in 5.8in");
            default:
                options.size= (options.orientation==="portrait"?"8.3in 11.7in":"11.7in 8.3in");
        }
        options.margins= (!options.margins?'A4':options.margins);
        switch(options.margins.toUpperCase()){
            case 'Narrow':
                options.margins= "0.5in";
            case 'Normal':
                options.margins= "1in";
            case 'Wide':
                options.margins= "2in";
            default:
                options.margins= "1in";
        }
        options.style= (!options.style?'':options.style);
        options.pagination = (!options.pagination?'':'<span style="mso-field-code: PAGE;"></span> of <span style="mso-field-code: NUMPAGES;"></span>');
        if (options.header && options.header.constructor === String) { options.header= "<p>"+options.header+"</p>"; }
        else if (options.header && options.header.constructor === Object) {
            options.header= `<p ${options.header.style?`style="${options.header.style}"`:''}>${options.header.text}</p>`;
        }
        else { options.header = ""; }
        if (options.footer && options.footer.constructor === String) {
            if(options.footer.indexOf('{pagination}') != -1) {
                options.footer= "<p>"+options.footer.replace('{pagination}',options.pagination)+"</p>";
            }
            else options.footer= "<p>"+options.footer+options.pagination+"</p>";
        }
        else if (options.footer && options.footer.constructor === Object) {
            if(options.footer.text.indexOf('{pagination}') != -1) {
                options.footer= `<p ${options.footer.style?`style="${options.footer.style}"`:''}>${options.footer.text.replace('{pagination}',options.pagination)}</p>`;
            }
            else options.footer= `<p ${options.footer.style?`style="${options.footer.style}"`:''}>${options.footer.text}${options.pagination}</p>`;
        }
        else { options.footer = '<p style="font-size: 12pt;">'+options.pagination+'</p>'; }
        //
        let docContent = '';
        if (content.constructor === String) {
            docContent += "<p>"+content+"</p>"
        }
        else if (content.constructor === Object) {
            docContent += "<p" + (content.style?' style="'+ content.style +'" ':'') + ">"+content.text+"</p>" + (content.pagebreak?pagebreak:"");
        }
        else if (content.constructor === Array){
            let lastLinebreak = true;
            for(let i = 0; i < content.length; i++){
                if (content[i].constructor === String) {
                    docContent += "<p>"+docContent[i]+"</p>";
                }
                else if (content[i].constructor === Object){
                    const tag = lastLinebreak?'p':'span';
                    docContent += '<' + tag + (content.style?' style="'+ content[i].style +'" ':'') + '>' + content[i].text + '</' + tag + '>' + content[i].pagebreak?pagebreak:'';
                    lastLinebreak= (content[i].linebreak?true:false);
                }
            }
        }
        const docContainer = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns="http://www.w3.org/TR/REC-html40">' +
                        '<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><title></title><style>' +
                        'p.MsoHeader,li.MsoHeader,div.MsoHeader{margin:0in;margin-top:.0001pt;mso-pagination:widow-orphan;tab-stops:center 3.0in right 6.0in;}' +
                        'p.MsoFooter,li.MsoFooter,div.MsoFooter{margin:0in 0in 1in 0in;margin-bottom:.0001pt;mso-pagination:widow-orphan;tab-stops:center 3.0in right 6.0in;}' +
                        '@page Section1{ size: ' + options.size + '; mso-page-orientation: ' + options.orientation + '; margin: ' + options.margins + '; mso-header-margin:0.5in; mso-header:h1; mso-footer:f1; mso-footer-margin:0.5in; mso-paper-source:0; }' +
                        'div.Section1{ page:Section1; } table#hrdftrtbl{ margin:0in 0in 0in 9in; }</style>' + 
                        '<style type="text/css" media="screen,print">body { ' + options.style + '}</style></head><body style="tab-interval:.5in"><div class="Section1">' +
                        docContent + '<table id="hrdftrtbl" border="1" cellspacing="0" cellpadding="0"><tr><td><div style="mso-element:header" id="h1" ><p class="MsoHeader"><table border="0" width="100%"><tr><td>' +
                        options.header + '</td></tr></table></p></div></td><td><div style="mso-element:footer" id="f1"><p class="MsoFooter"><table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td align="center" class="footer">' +
                        options.footer + '<g:message code="offer.letter.page.label"/></span></td></tr></table></p></div></td></tr></table></div></body></html>';
        const blob = 'data:application/msword;charset=utf-8,' + encodeURIComponent(docContainer);
        //
        return {
            content : docContent, document : docContainer, blob : blob,
            download : () => {
                let file = document.createElement("a");
                document.body.appendChild(file);
                file.href = (typeof blob === 'string'?blob:URL.createObjectURL(blob));
                file.download =  (options.name?options.name+".doc":"word.doc");
                file.click();
                document.body.removeChild(file);
            }
        };
    }
}